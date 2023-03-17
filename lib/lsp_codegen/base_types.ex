defmodule LSPCodegen.BaseTypes do
  @type t ::
          :URI
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
      "URI" -> :URI
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
