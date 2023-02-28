defmodule LspCodegenTest do
  use ExUnit.Case
  doctest LspCodegen

  test "greets the world" do
    assert LspCodegen.hello() == :world
  end
end
