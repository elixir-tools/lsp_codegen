defprotocol LSPCodegen.Codegen do
  @fallback_to_any true
  def to_string(type, metamodel)
end

defimpl LSPCodegen.Codegen, for: Any do
  def to_string(type, _metamodel) do
    # IO.inspect(type, label: "any!")
    "any()"
  end
end
