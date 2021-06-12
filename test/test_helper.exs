current_parser = Application.get_env(:floki, :html_parser)

# fast_html uses a C-Node worker for parsing, so starting the application
# is necessary for it to work
if current_parser == Floki.HTMLParser.FastHtml do
  Application.ensure_all_started(:fast_html)
end

# Excluded tags can not be a list
# which is why we need `except_parser` for cases where we want to include 2 parser
ExUnit.configure(
  exclude: [:only_parser, except_parser: current_parser],
  include: [only_parser: nil, only_parser: current_parser]
)

Application.put_env(:ex_unit, :module_load_timeout, 120_000)
ExUnit.start()
