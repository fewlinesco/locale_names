defmodule Locale do
  @moduledoc """
  Utilities for working with locales (in the form of `en-US`)

  The main goal is to be able to display a list of languages in their own spelling (`en-US` is "American English", `fr-CA` is "Français canadien").
  """

  @type locale_code() :: String.t()
  @type locale() :: %Locale{
          direction: :left_to_right | :right_to_left,
          english_name: String.t(),
          locale: locale_code(),
          name: String.t()
        }

  defstruct [:direction, :english_name, :locale, :name]

  @spec locale?(locale_code()) :: boolean()
  @spec locale(locale_code()) :: locale() | {:error, :locale_not_found}

  @doc """
  Returns true if the locale code is supported by locale_names, false otherwise

  ## Examples

      iex> Locale.locale?("en-US")
      true

      iex> Locale.locale?("not-a-locale")
      false
  """
  def locale?(locale_code)

  @doc """
  Returns a `Locale` struct detailing the locale from the locale code passed.

  It will return the writing direction of the locale, the name of the language in english and in its own language and
  it will return the locale code back.

  ## Examples

      iex> Locale.locale("en-US")
      %Locale{
        direction: :left_to_right,
        english_name: "American English",
        locale: "en-US",
        name: "American English"
      }

      iex> Locale.locale("fr-FR")
      %Locale{
        direction: :left_to_right,
        english_name: "French",
        locale: "fr-FR",
        name: "Français"
      }
  """
  def locale(locale_code)

  for language <- CLDR.languages() do
    def locale(unquote(language)), do: unquote(Macro.escape(LocaleBuilder.locale(language)))
    def locale?(unquote(language)), do: true

    scripts = CLDR.script_for_language(language)

    Enum.each(scripts, fn script ->
      locale = language <> "-" <> script

      def locale(unquote(locale)), do: unquote(Macro.escape(LocaleBuilder.locale(locale)))

      def locale?(unquote(locale)), do: true
    end)

    territories = CLDR.territories_for_language(language)

    Enum.each(territories, fn territory ->
      locale = language <> "-" <> territory

      def locale(unquote(locale)), do: unquote(Macro.escape(LocaleBuilder.locale(locale)))

      def locale?(unquote(locale)), do: true
    end)

    Enum.each(scripts, fn script ->
      Enum.each(territories, fn territory ->
        locale = language <> "-" <> script <> "-" <> territory
        def locale(unquote(locale)), do: unquote(Macro.escape(LocaleBuilder.locale(locale)))

        def locale?(unquote(locale)), do: true
      end)
    end)
  end

  def locale?(_), do: false

  def locale(_), do: {:error, :locale_not_found}
end
