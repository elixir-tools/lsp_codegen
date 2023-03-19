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
      "map()"
    end
  end

  defimpl LSPCodegen.Schematic do
    require EEx
    @path Path.join(:code.priv_dir(:lsp_codegen), "structure_literal.ex.eex")

    def to_string(structure, metamodel) do
      render(%{
        structure: structure.value,
        metamodel: metamodel
      })
      |> String.trim()
    end

    def maybe_wrap_in_optional(true, schematic), do: "oneof([null(), #{schematic}])"
    def maybe_wrap_in_optional(_, schematic), do: schematic

    EEx.function_from_file(:defp, :render, @path, [:assigns])
  end
end
