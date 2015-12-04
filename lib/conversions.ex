defmodule Conversions do

  @spec rgb_to_hsl(RGBColor) :: HSLColor
  def rgb_to_hsl(rgb = %RGBColor{r: r, g: g, b: b}) when r == g and g == b do
    # only when achromatic
    HSLColor.new(0, 0, lightness_from_rgb rgb)
  end
  def rgb_to_hsl(rgb = %RGBColor{}) do
    [r, g, b] = normalized_values_from_rgb rgb
    max = RGBColor.max(rgb) / 255
    min = RGBColor.min(rgb) / 255
    d = max - min
    l = lightness_from_rgb rgb
    s = if l > 0.5, do: d / (2 - max - min), else: d / (max + min)
    h = cond do
      max == r ->
        (g - b) / d + (if g < b, do: 6, else: 0)
      max == g ->
        (b - r) / d + 2
      max == b ->
        (r - g) / d + 4
    end / 6

    HSLColor.new(h, s, l)
  end

  def hsl_to_rgb(hsl = %HSLColor{s: 0, l: l}) do
    # only when achromatic
    [l, l, l] |> rgb_from_normalized_values
  end
  def hsl_to_rgb(%HSLColor{h: h, s: s, l: l}) do
    q = if l < 0.5, do: l * (1 + s), else: l + s - l * s
    p = 2 * l - q

    r = hue_to_rgb(p, q, h + 1/3)
    g = hue_to_rgb(p, q, h)
    b = hue_to_rgb(p, q, h - 1/3)

    [r, g, b] |> rgb_from_normalized_values
  end

  defp lightness_from_rgb(rgb = %RGBColor{}) do
    (RGBColor.max(rgb) / 255 + RGBColor.min(rgb) / 255) / 2
  end

  defp normalized_values_from_rgb(%RGBColor{r: r, g: g, b: b}) do
    Enum.map [r, g, b], &(&1 / 255)
  end

  defp rgb_from_normalized_values(values = [_r, _g, _b]) do
    values
    |> Enum.map(&(&1 * 255))
    |> Enum.map(&Kernel.round/1)
    |> RGBColor.from_list
  end

  defp hue_to_rgb(p, q, t) do
    t = cond do
      t < 0 ->
        t + 1
      t > 1 ->
        t - 1
      true ->
        t
    end

    cond do
      t < 1/6 ->
        p + (q - p) * 6 * t
      t < 1/2 ->
        q
      t < 2/3 ->
        p + (q - p) * (2/3 - t) * 6
      true ->
        p
    end
  end
end
