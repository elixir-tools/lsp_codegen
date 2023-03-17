defmodule LSPCodegen.OrType do
  @moduledoc """
  Represents an `or` type (e.g. `Location | LocationLink`).
  """

  use TypedStruct

  alias LSPCodegen.Type

  typedstruct do
    field :kind, :or, default: :or, enforce: true
    field :items, list(Type.t()), default: [], enforce: true
  end

  def new(type) do
    %__MODULE__{
      kind: :or,
      items: for(i <- type.items, do: Type.new(i))
    }
  end

  defimpl LSPCodegen.Codegen do
    def to_string(%{items: items}, metamodel) do
      Enum.map_join(items, " | ", &LSPCodegen.Codegen.to_string(&1, metamodel))
    end
  end

  defimpl LSPCodegen.Schematic do
    def to_string(%{items: items}, metamodel) do
      "oneof([#{Enum.map_join(items, ", ", &LSPCodegen.Schematic.to_string(&1, metamodel))}])"
    end
  end
end
