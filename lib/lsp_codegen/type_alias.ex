defmodule LSPCodegen.TypeAlias do
  @moduledoc """
  Defines a type alias. (e.g. `type Definition = Location | LocationLink`)
  """

  alias LSPCodegen.Type

  use TypedStruct

  typedstruct do
    field :documentation, String.t()
    field :name, String.t(), enforce: true
    field :proposed, boolean()
    field :since, String.t()
    field :type, Type.t(), enforce: true
  end

  def new(type_alias) do
    %__MODULE__{
      documentation: type_alias[:documentation],
      name: type_alias.name,
      proposed: type_alias[:proposed],
      since: type_alias[:since],
      type: Type.new(type_alias.type)
    }
  end

  defimpl LSPCodegen.Schematic do
    def to_string(type_alias, _metamodel) do
      "GenLSP.TypeAlias.#{type_alias.name}.schema()"
    end
  end

  defimpl LSPCodegen.Codegen do
    require EEx
    @path Path.join(:code.priv_dir(:lsp_codegen), "type_alias.ex.eex")

    def to_string(type_alias, metamodel) do
      render(%{type_alias: type_alias, metamodel: metamodel})
    end

    EEx.function_from_file(:defp, :render, @path, [:assigns])
  end

  defimpl LSPCodegen.Naming do
    def name(%{name: name}), do: name
  end
end
