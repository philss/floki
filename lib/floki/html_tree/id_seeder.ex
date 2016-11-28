defmodule Floki.HTMLTree.IDSeeder do
  def seed([]), do: 1
  def seed([h | _]), do: h + 1
end
