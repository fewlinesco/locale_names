defmodule Locale do
  @moduledoc """
  Utilities for working with locales (in the form of `en-US`).

  The main goal is to be able to display a list of languages in their own spelling (`en-US` is "American English", `fr-CA` is "Français canadien").

  ## The Locale struct

  The fields are:
  * `direction` - In what direction is that language written
  * `english_name` - The English name of this language
  * `locale_code` - The locale code of this Locale
  * `name` - The name of that language in its own spelling
  """

  @type locale_code() :: String.t()
  @type direction_type() :: :left_to_right | :right_to_left | :unknown_direction
  @type locale() :: %Locale{
          direction: direction_type(),
          english_name: String.t(),
          locale_code: locale_code(),
          name: String.t()
        }

  @enforce_keys [:direction, :english_name, :locale_code, :name]
  defstruct [:direction, :english_name, :locale_code, :name]

  @spec locale?(locale_code()) :: boolean()
  @spec locale(locale_code()) :: {:ok, locale()} | {:error, :locale_not_found}

  @doc """
  Returns true if the locale code is supported, false otherwise.

  ## Examples

      iex> Locale.locale?("en-US")
      true

      iex> Locale.locale?("not-a-locale")
      false
  """
  def locale?(locale_code)

  @doc """
  Returns a tuple {:ok, locale()} where `locale()` is a `Locale` struct detailing the locale from the locale code
  passed or a tuple {:error, :locale_not_found}

  ## Examples

      iex> Locale.locale("en-US")
      {:ok,
        %Locale{
          direction: :left_to_right,
          english_name: "American English",
          locale_code: "en-US",
          name: "American English"
        }
      }

      iex> Locale.locale("fr-FR")
      {:ok,
        %Locale{
          direction: :left_to_right,
          english_name: "French",
          locale_code: "fr-FR",
          name: "Français"
        }
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

  def locale?(locale_code) when is_binary(locale_code), do: false

  def locale(locale_code) when is_binary(locale_code), do: {:error, :locale_not_found}
end
