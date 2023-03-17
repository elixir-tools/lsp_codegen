defmodule LSPCodegen.MapType do
  @moduledoc """
  Represents a JSON object map (e.g. `interface Map<K extends string | integer, V> { [key: K] => V; }`).
  """

  alias LSPCodegen.MapKeyType
  alias LSPCodegen.Type

  use TypedStruct

  typedstruct do
    field :kind, :map, default: :map, enforce: true
    field :key, MapKeyType.t(), enforce: true
    field :value, Type.t(), enforce: true
  end

  def new(type) do
    %__MODULE__{
      kind: :map,
      key: MapKeyType.new(type.key),
      value: Type.new(type.value)
    }
  end

  defimpl LSPCodegen.Schematic do
    def to_string(type, metamodel) do
      "map(keys: #{LSPCodegen.Schematic.to_string(type.key, metamodel)}, values: #{LSPCodegen.Schematic.to_string(type.value, metamodel)})"
    end
  end

  defimpl LSPCodegen.Codegen do
    def to_string(map_type, metamodel) do
      "%{#{LSPCodegen.Codegen.to_string(map_type.key, metamodel)} => #{LSPCodegen.Codegen.to_string(map_type.value, metamodel)}}"
    end
  end
end
