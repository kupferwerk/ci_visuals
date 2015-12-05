defmodule CiVisuals.ColorBroadcast.Animator do
  import BlockTimer

  def start_link do
    pid = spawn_link fn -> wait_for_animation_request end
    Process.register(pid, :animator)

    {:ok, pid}
  end

  def blend(start_color, end_color) do
    pid = Process.whereis(:animator)
    if pid != nil do
      send pid, {:animate_blend, start_color, end_color}
    else
      IO.puts "animator not found"
    end
  end

  defp wait_for_animation_request do
    receive do
      {:animate_blend, start_color, end_color} ->
        start_animate_blend start_color, end_color
      {:animate_rotate, color} ->
        start_animate_rotation color
      x -> IO.puts "received unknown msg " <> x
    end

    wait_for_animation_request
  end

  defp start_animate_blend(start_color, end_color) do
    IO.puts "start animate blend"
    initial_color = Conversions.rgb_to_hsl(start_color)
    target_color = Conversions.rgb_to_hsl(end_color)

    steps = ColorAnimation.blend(initial_color, target_color)

    pid = Process.whereis(:color_service)
    if pid != nil do
      spawn_link fn ->
        Enum.each(steps, fn color ->
          send pid, {:set_same_colors, Conversions.hsl_to_rgb color}
          :timer.sleep(100)
        end)
      end
    end
  end

  defp start_animate_rotation(color) do
    IO.puts "start animate rotate"
    rotating_color = Conversions.rgb_to_hsl(color)

    tick_stream = Stream.interval 100
    rotation_stream = ColorAnimation.rotation_stream rotating_color

    pid = Process.whereis(:color_service)
    if pid != nil do
      spawn_link fn ->
        Stream.interval(100)
        |> Stream.each(fn tick ->
          current_colors = rotation_stream
          |> Enum.drop(tick)
          |> Enum.take(60)

          send pid, {:set_colors, current_colors}
        end)
        |> Stream.run
      end
    end
  end
end
