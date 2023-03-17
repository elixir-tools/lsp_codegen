defmodule LSPCodegen.ReferenceType do
  @moduledoc """
  Represents a reference to another type (e.g. `TextDocument`). This is either a `Structure`, a `Enumeration` or a `TypeAlias` in the same meta model.
  """

  use TypedStruct

  typedstruct do
    field :kind, :reference, default: :reference, enforce: true
    field :name, String.t(), enforce: true
  end

  def new(type) do
    %__MODULE__{
      kind: :reference,
      name: type.name
    }
  end

  defimpl LSPCodegen.Codegen do
    def to_string(%{name: name}, metamodel) do
      cond do
        Enum.any?(metamodel.structures, &(&1.name == name)) ->
          "GenLSP.Structures.#{name}.t()"

        Enum.any?(metamodel.type_aliases, &(&1.name == name)) ->
          "GenLSP.TypeAlias.#{name}.t()"

        Enum.any?(metamodel.enumerations, &(&1.name == name)) ->
          "GenLSP.Enumerations.#{name}.t()"

        true ->
          raise "Unknown reference type: #{name}"
      end
    end
  end

  defimpl LSPCodegen.Schematic do
    def to_string(%{name: name}, metamodel) do
      cond do
        Enum.any?(metamodel.structures, &(&1.name == name)) ->
          "GenLSP.Structures.#{name}.schematic()"

        Enum.any?(metamodel.type_aliases, &(&1.name == name)) ->
          "GenLSP.TypeAlias.#{name}.schematic()"

        Enum.any?(metamodel.enumerations, &(&1.name == name)) ->
          "GenLSP.Enumerations.#{name}.schematic()"

        true ->
          raise "Unknown reference type: #{name}"
      end
    end
  end
end
