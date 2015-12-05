defmodule ColorAnimation do

  def blend(initial_color = %HSLColor{}, target_color = %HSLColor{}, total_ticks \\ 30) do
    delta = delta_per_tick(initial_color, target_color, total_ticks)
    Enum.scan(1..total_ticks, initial_color, fn _tick, current_color ->
      delta |> apply_delta(current_color)
    end)
  end

  def rotation_stream(color = %HSLColor{}, length \\ 60) do
    steps = blend(color, Colors.HSL.black, length)
    |> Stream.cycle
  end

  defp delta_per_tick(from = %HSLColor{}, to = %HSLColor{}, total_ticks) do
    hsl_delta = %{
      h: color_delta(from.h, to.h, total_ticks),
      s: color_delta(from.s, to.s, total_ticks),
      l: color_delta(from.l, to.l, total_ticks),
    }
  end

  defp apply_delta(hsl_delta, current_color = %HSLColor{}) do
    HSLColor.new(
      current_color.h + hsl_delta[:h],
      current_color.s + hsl_delta[:s],
      current_color.l + hsl_delta[:l]
    )
  end

  defp color_delta(from, to, total_ticks) do
    (to - from) / total_ticks
  end
end
