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
end
