defmodule CiVisuals.PageControllerTest do
  use CiVisuals.ConnCase

  test "Socket" do
    color = Colors.HSL.white
    rgb_color = Conversions.hsl_to_rgb color

    s = Socket.TCP.connect! "localhost", 8888
    Enum.each 1..60, fn x ->
      Socket.Stream.send! s, <<x, rgb_color.r, rgb_color.g, rgb_color.b>>
    end

  end
end
