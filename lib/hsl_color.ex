defmodule HSLColor do
  defstruct h: 0.0, s: 0.0, l: 0.0

  @min_value 0.0
  @max_value 1.0

  def new(h, s, l), do: %HSLColor{h: limit(h), s: limit(s), l: limit(l)}

  defp limit(value) do
    (value / 1.0)  # make sure it's a float
    |> Float.round(5)
    |> min(@max_value)
    |> max(@min_value)
  end
end
