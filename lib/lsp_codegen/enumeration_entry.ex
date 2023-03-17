defmodule LSPCodegen.EnumerationEntry do
  @moduledoc """
  Defines an enumeration entry.
  """

  use TypedStruct

  typedstruct do
    field :documentation, String.t()
    field :name, String.t(), enforce: true
    field :proposed, boolean()
    field :since, String.t()
    field :value, String.t() | integer(), enforce: true
  end

  def new(entry) do
    %__MODULE__{
      documentation: entry[:documentation],
      name: entry.name,
      proposed: entry[:proposed],
      since: entry[:since],
      value: entry.value
    }
  end

  defimpl LSPCodegen.Schematic do
    def to_string(entry, _metamodel) when is_integer(entry.value) do
      "int(#{entry.value})"
    end

    def to_string(entry, _metamodel) when is_binary(entry.value) do
      ~s|str("#{entry.value}")|
    end
  end
end
