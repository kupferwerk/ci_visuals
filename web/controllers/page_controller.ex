defmodule CiVisuals.PageController do
  use CiVisuals.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
