read_file = fn name ->
  __ENV__.file
  |> Path.dirname()
  |> Path.join(name)
  |> File.read!()
end

inputs = %{
  "big" => read_file.("big.html"),
  "medium" => read_file.("medium.html"),
  "small" => read_file.("small.html")
}

Application.ensure_all_started(:fast_html)

Benchee.run(
  %{
    "mochiweb" => fn input -> Floki.parse_document(input) end,
    "html5ever" => fn input ->
      Floki.parse_document(input, html_parser: Floki.HTMLParser.Html5ever)
    end,
    "fast_html" => fn input ->
      Floki.parse_document(input, html_parser: Floki.HTMLParser.FastHtml)
    end
  },
  time: 10,
  inputs: inputs,
  memory_time: 2
)
