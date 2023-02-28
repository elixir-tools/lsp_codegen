defmodule LSPCodegen.Structure do
  @moduledoc """
  Defines the structure of an object literal.
  """

  alias LSPCodegen.{Type, Property}

  use TypedStruct

  typedstruct do
    field :documentation, String.t()
    field :extends, list(Type.t())
    field :mixins, list(Type.t())
    field :name, String.t(), enforce: true
    field :properties, list(Property.t()), enforce: true
    field :proposed, boolean()
    field :since, String.t()
  end

  def new(structure) do
    %__MODULE__{
      documentation: structure[:documentation],
      extends: for(e <- structure[:extends] || [], do: Type.new(e)),
      mixins: for(m <- structure[:mixins] || [], do: Type.new(m)),
      name: structure.name,
      properties: for(p <- structure.properties, do: Property.new(p)),
      proposed: structure[:proposed],
      since: structure[:since]
    }
  end

  defimpl LSPCodegen.Codegen do
    require EEx
    @path Path.join(:code.priv_dir(:lsp_codegen), "structure.ex.eex")

    def to_string(structure, metamodel) do
      # dbg "structure!"
      render(%{
        structure: Map.from_struct(structure),
        properties: properties(structure, metamodel.structures),
        metamodel: metamodel
      })
    end

    defp properties(structure, structures) do
      mixins =
        Enum.flat_map(structure.mixins, fn m ->
          Enum.find(structures, &(&1.name == m.name)).properties
        end)

      extends =
        Enum.flat_map(structure.extends, fn e ->
          Enum.find(structures, &(&1.name == e.name)).properties
        end)

      (structure.properties ++ mixins ++ extends) |> Enum.uniq()
    end

    def enforce(value) when value in [false, nil], do: ", enforce: true"
    def enforce(true), do: ""

    EEx.function_from_file(:defp, :render, @path, [:assigns])
  end
end
