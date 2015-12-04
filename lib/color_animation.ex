defmodule ColorAnimation do

  def test(total_ticks \\ 100) do
    initial_color = Colors.HSL.black
    target_color = Colors.HSL.white
    delta = delta_per_tick(initial_color, target_color, total_ticks)

    Enum.scan(1..total_ticks, initial_color, fn _tick, current_color ->
      delta |> apply_delta(current_color)
    end)
    |> IO.inspect
  end

  defp delta_per_tick(from = %HSLColor{}, to = %HSLColor{}, total_ticks \\ 100) do
    hsl_delta = %{
      h: delta(from.h, to.h),
      s: delta(from.s, to.s),
      l: delta(from.l, to.l),
    }
  end

  defp apply_delta(hsl_delta, current_color = %HSLColor{}) do
    HSLColor.new(
      current_color.h + hsl_delta[:h],
      current_color.s + hsl_delta[:s],
      current_color.l + hsl_delta[:l]
    )
  end

  defp delta(from, to, total_ticks \\ 100) do
    (to - from) / 100
  end
end
