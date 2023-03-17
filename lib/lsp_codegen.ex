defmodule LSPCodegen do
  alias LSPCodegen.{
    Enumeration,
    Notification,
    Request,
    Structure,
    TypeAlias
  }

  def generate(argv) when is_list(argv) do
    {opts, _} = OptionParser.parse!(argv, strict: [path: :string])
    path = opts[:path]

    File.rm_rf!(path)

    %LSPCodegen.MetaModel{} =
      metamodel =
      File.read!(Path.join(:code.priv_dir(:lsp_codegen), "metaModel.json"))
      |> Jason.decode!(keys: :atoms)
      |> LSPCodegen.MetaModel.new()

    for mod <-
          metamodel.structures ++
            metamodel.requests ++
            metamodel.notifications ++ metamodel.enumerations ++ metamodel.type_aliases do
      source_code = LSPCodegen.Codegen.to_string(mod, metamodel)

      path =
        case mod do
          %Enumeration{} -> Path.join(path, "enumerations")
          %Notification{} -> Path.join(path, "notifications")
          %Request{} -> Path.join(path, "requests")
          %Structure{} -> Path.join(path, "structures")
          %TypeAlias{} -> Path.join(path, "type_aliases")
        end

      File.mkdir_p!(path)

      File.write!(
        Path.join(path, Macro.underscore(LSPCodegen.Naming.name(mod)) <> ".ex"),
        source_code
      )
    end
  end
end
