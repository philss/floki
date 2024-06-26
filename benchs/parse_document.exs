tag =
  case System.cmd("git", ["describe", "--tags"]) do
    {reference, 0} ->
      String.trim_trailing(reference)

    {error, _other} ->
      IO.puts("cannot get human readable name from git: #{inspect(error)}")
      "unknown"
  end

IO.puts("tag in use for this benchmark is: #{tag}")

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
    "mochiweb" => fn input -> Floki.parse_document!(input) end,
    "html5ever" => fn input ->
      Floki.parse_document!(input, html_parser: Floki.HTMLParser.Html5ever)
    end,
    "fast_html" => fn input ->
      Floki.parse_document!(input, html_parser: Floki.HTMLParser.FastHtml)
    end
  },
  time: 10,
  inputs: inputs,
  save: [path: "benchs/results/parse-document-#{tag}.benchee", tag: tag],
  memory_time: 2
)

results = Path.wildcard("benchs/results/parse-document-*.benchee")

if Enum.count(results) > 1 and function_exported?(Benchee, :report, 1) do
  html_path = "benchs/results/parse-document.html"

  Benchee.report(
    load: results,
    formatters: [
      Benchee.Formatters.Console,
      {Benchee.Formatters.HTML, file: html_path, auto_open: true}
    ]
  )

  IO.puts("open the HTML version in: #{html_path}")
end
