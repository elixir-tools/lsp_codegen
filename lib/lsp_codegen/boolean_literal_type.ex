defmodule LSPCodegen.BooleanLiteralType do
  @moduledoc """
  Represents a boolean literal type (e.g. `kind: true`).
  """

  use TypedStruct

  typedstruct do
    field :kind, :boolean_literal, default: :boolean_literal, enforce: true
    field :value, boolean(), enforce: true
  end

  def new(type) do
    %__MODULE__{
      kind: :boolean_literal,
      value: type.value
    }
  end

  defimpl LSPCodegen.Schematic do
    def to_string(boolean_literal, _metamodel) do
      "bool(#{boolean_literal.value})"
    end
  end
end
