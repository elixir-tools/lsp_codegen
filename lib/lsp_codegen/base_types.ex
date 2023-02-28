defmodule LSPCodegen.BaseTypes do
  @type t ::
          :Uri
          | :DocumentUri
          | :integer
          | :uinteger
          | :decimal
          | :RegExp
          | :string
          | :boolean
          | :null

  @type uri :: String.t()
  @type document_uri :: String.t()
  @type uinteger :: integer()
  @type null :: nil

  def new(type) do
    case type do
      "Uri" -> :Uri
      "DocumentUri" -> :DocumentUri
      "integer" -> :integer
      "uinteger" -> :uinteger
      "decimal" -> :decimal
      "RegExp" -> :RegExp
      "string" -> :string
      "boolean" -> :boolean
      "null" -> :null
    end
  end
end
