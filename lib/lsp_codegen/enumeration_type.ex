defmodule LSPCodegen.EnumerationType do
  use TypedStruct

  typedstruct do
    field :kind, :base, default: :base, enforce: true
    field :name, :string | :integer | :uinteger, enforce: true
  end

  def new(type) do
    %__MODULE__{
      kind: :base,
      name: String.to_atom(type.name)
    }
  end

  defimpl LSPCodegen.Codegen do
    def to_string(type, _metamodel) do
      case type.name do
        :integer ->
          "integer()"

        :uinteger ->
          "GenLSP.BaseTypes.uinteger()"

        :string ->
          "String.t()"
      end
    end
  end
end
