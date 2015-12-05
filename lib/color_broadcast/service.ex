defmodule CiVisuals.ColorBroadcast.Service do
  use GenServer

  import BlockTimer

  def start_link do
    socket = Socket.TCP.connect!("localhost", 8888)

    pid = spawn_link fn ->
      listen(socket)
    end
    Process.register pid, :color_service

    # spawn_scheduler(pid)

    {:ok, pid}
  end

  defp spawn_scheduler(pid) do
    apply_interval 2 |> seconds do
      send pid, {:set_same_colors_random}
    end
  end

  defp listen(socket) do
    receive do
      {:set_same_colors_random} ->
        send self, {:set_same_colors, Colors.RGB.random}

      {:set_same_colors, color = %RGBColor{}} ->
        # IO.inspect(color)
        send_colors socket, Enum.map(1..60, fn _ -> color end)

      {:set_colors, colors = []} ->
        send_colors socket, colors
    end

    listen(socket)
  end

  defp send_colors(socket, colors) do
    Enum.each colors, fn c ->
      Socket.Stream.send! socket, <<c.r, c.g, c.b>>
    end
  end
end
