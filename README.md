# LSPCodegen

Library to generate LSP protocol code for [gen_lsp](https://github.com/mhanberg/gen_lsp).

## Usage

```
elixir -e 'Mix.install([{:lsp_codegen, github: "mhanberg/lsp_codegen"}]); LSPCodegen.generate(System.argv())' -- --path ./path/for/files
```

## metaModel.json

To update the metaModel.json, you can run the following.

```bash
$ curl --location 'https://raw.githubusercontent.com/microsoft/language-server-protocol/gh-pages/_specifications/lsp/3.17/metaModel/metaModel.json' | jq . > priv/metaModel.json
```
