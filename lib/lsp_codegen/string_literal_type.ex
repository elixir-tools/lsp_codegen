defmodule LSPCodegen.StringLiteralType do
  @moduledoc """
  Represents a string literal type (e.g. `kind: 'rename'`).
  """

  use TypedStruct

  typedstruct enforce: true do
    field :kind, :string_literal, default: :string_literal
    field :value, String.t()
  end

  def new(type) do
    %__MODULE__{
      kind: :string_literal,
      value: type.value
    }
  end

  defimpl LSPCodegen.Codegen do
    def to_string(_type, _metamodel) do
      ~s|String.t()|
    end
  end

  defimpl LSPCodegen.Schematic do
    def to_string(type, _metamodel) do
      ~s|str("#{type.value}")|
    end
  end
end
