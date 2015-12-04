defmodule Colors.HSL do
  import HSLColor

  def black, do: new(0, 0, 0)
  def white, do: new(0, 0, 1)

  def red, do: new(0, 1, 0.5)
  def green, do: new(1/3, 1, 0.5)
  def blue, do: new(2/3, 1, 0.5)
end
