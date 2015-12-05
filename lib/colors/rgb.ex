defmodule Colors.RGB do
  import RGBColor

  def black, do: new(0, 0, 0)
  def white, do: new(255, 255, 255)

  def red, do: new(255, 0, 0)
  def green, do: new(0, 255, 0)
  def blue, do: new(0, 0, 255)

  def cyan, do: new(0, 255, 255)
  def magenta, do: new(255, 0, 255)
  def yellow, do: new(255, 255, 0)

  def random, do: new(random_rgb_val, random_rgb_val, random_rgb_val)
  defp random_rgb_val, do: Enum.random(0..255)
end
