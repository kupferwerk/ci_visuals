defmodule RGBColor do
  defstruct r: 0, g: 0, b: 0

  @min_value 0
  @max_value 255

  def new(r, g, b), do: %RGBColor{r: limit(r), g: limit(g), b: limit(b)}

  def from_list([r, g, b]), do: new(r, g, b)

  def to_binary(%RGBColor{r: r, g: g, b: b}) do
    <<r, g, b>>
  end

  def min(%RGBColor{r: r, g: g, b: b}) do
    Enum.min [r, g, b]
  end

  def max(%RGBColor{r: r, g: g, b: b}) do
    Enum.max [r, g, b]
  end

  def achromatic?(%RGBColor{r: r, g: g, b: b}) do
    r == g && g == b
  end

  defp limit(value), do: max(min(value, @max_value), @min_value)
end
