defmodule TableCheckTest do
  use ExUnit.Case, async: true

  test "lists available tables" do
    assert [] == TableCheck.list_available_tables(%{})
  end
end
