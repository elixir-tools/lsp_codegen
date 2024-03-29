defmodule LSPCodegen.Enumeration do
  @moduledoc """
  Defines an enumeration.
  """

  use TypedStruct

  alias LSPCodegen.{
    EnumerationType,
    EnumerationEntry
  }

  typedstruct do
    field :documentation, String.t()
    field :name, String.t(), enforce: true
    field :proposed, boolean()
    field :since, String.t()
    field :supports_custom_values, boolean()
    field :type, EnumerationType.t(), enforce: true
    field :values, list(EnumerationEntry.t()), default: [], enforce: true
  end

  def new(enumeration) do
    %__MODULE__{
      documentation: enumeration[:documentation],
      name: enumeration.name,
      proposed: enumeration[:proposed],
      since: enumeration[:since],
      supports_custom_values: enumeration[:supportsCustomValues],
      type: EnumerationType.new(enumeration.type),
      values: for(e <- enumeration.values, do: EnumerationEntry.new(e))
    }
  end

  defimpl LSPCodegen.Codegen do
    require EEx
    @path Path.join(:code.priv_dir(:lsp_codegen), "enumeration.ex.eex")

    def to_string(enumeration, metamodel) do
      render(%{
        enumeration: enumeration,
        values: enumeration.values,
        type:
          if(enumeration.type.name == :string,
            do: "String.t()",
            else: Enum.map_join(enumeration.values, " | ", &inspect(&1.value))
          ),
        metamodel: metamodel
      })
    end

    EEx.function_from_file(:defp, :render, @path, [:assigns])
  end

  defimpl LSPCodegen.Naming do
    def name(%{name: name}), do: name
  end
end
