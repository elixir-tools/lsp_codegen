defmodule LSPCodegen.BaseType do
  @moduledoc """
  Represents a base type like `string` or `DocumentUri`.
  """

  use TypedStruct

  alias LSPCodegen.BaseTypes

  typedstruct do
    field :kind, :base, default: :base, enforce: true
    field :name, BaseTypes.t(), enforce: true
  end

  def new(type) do
    %__MODULE__{
      kind: :base,
      name: BaseTypes.new(type.name)
    }
  end

  defimpl LSPCodegen.Codegen do
    def to_string(type, _metamodel) do
      # dbg "base!"
      case type.name do
        :Uri ->
          "GenLSP.BaseTypes.uri()"

        :DocumentUri ->
          "GenLSP.BaseTypes.document_uri()"

        :integer ->
          "integer()"

        :uinteger ->
          "GenLSP.BaseTypes.uinteger()"

        :decimal ->
          "float()"

        :RegExp ->
          "Regex.t()"

        :string ->
          "String.t()"

        :boolean ->
          "boolean()"

        :null ->
          "nil"
      end
    end
  end
end
