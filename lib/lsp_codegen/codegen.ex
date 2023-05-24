defprotocol LSPCodegen.Codegen do
  @fallback_to_any true
  def to_string(type, metamodel)
end

defprotocol LSPCodegen.Schematic do
  def to_string(type, metamodel)
end

defprotocol LSPCodegen.Naming do
  def name(type)
end

defimpl LSPCodegen.Codegen, for: Atom do
  def to_string(nil, _metamodel) do
    "nil"
  end
end

defimpl LSPCodegen.Schematic, for: Atom do
  def to_string(nil, _metamodel) do
    "nil"
  end
end
