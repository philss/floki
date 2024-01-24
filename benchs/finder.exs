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
  |> Floki.parse_document!()
end

inputs = %{
  "big" => read_file.("big.html"),
  "medium" => read_file.("medium.html"),
  "small" => read_file.("small.html")
}

Benchee.run(
  %{
    "class" => fn doc -> Floki.find(doc, ".class-mw-redirect") end,
    "class multiple" => fn doc -> Floki.find(doc, ".class-mw-redirect, .reference") end,
    "tag name (type)" => fn doc -> Floki.find(doc, "a") end,
    "id" => fn doc -> Floki.find(doc, "#cite_note-15") end
  },
  time: 10,
  inputs: inputs,
  save: [path: "benchs/results/finder-#{tag}.benchee", tag: tag],
  memory_time: 2
)

results = Path.wildcard("benchs/results/finder-*.benchee")

if Enum.count(results) > 1 and function_exported?(Benchee, :report, 1) do
  html_path = "benchs/results/finder.html"

  Benchee.report(
    load: results,
    formatters: [
      Benchee.Formatters.Console,
      {Benchee.Formatters.HTML, file: html_path, auto_open: true}
    ]
  )

  IO.puts("open the HTML version in: #{html_path}")
end
