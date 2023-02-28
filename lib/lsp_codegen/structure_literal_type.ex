defmodule LSPCodegen.StructureLiteralType do
  @moduledoc """
  Represents a literal structure (e.g. `property: { start: uinteger; end: uinteger; }`).
  """

  alias LSPCodegen.StructureLiteral

  use TypedStruct

  typedstruct do
    field :kind, :literal, default: :literal, enforce: true
    field :value, StructureLiteral.t(), enforce: true
  end

  def new(type) do
    %__MODULE__{
      kind: :literal,
      value: StructureLiteral.new(type.value)
    }
  end

  defimpl LSPCodegen.Codegen do
    def to_string(_type, _metamodel) do
      # dbg("structure literal!")
      "map()"
    end
  end
end
