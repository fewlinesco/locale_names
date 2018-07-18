defmodule LocaleNamesTest do
  use ExUnit.Case
  doctest LocaleNames

  test "greets the world" do
    assert LocaleNames.hello() == :world
  end
end
