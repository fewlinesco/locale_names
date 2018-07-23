defmodule Locale do
  defstruct [:locale, :name, :direction]

  {:ok, languages} = CLDR.languages()

  for language <- languages do
    def locale?(unquote(language)), do: true
    def locale(unquote(language)), do: unquote(Macro.escape(LocaleBuilder.locale(language)))

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
