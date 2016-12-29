defmodule Floki.HTMLTree.IDSeeder do
  @moduledoc false

  def seed([]), do: 1
  def seed([h | _]), do: h + 1
end
