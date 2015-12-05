defmodule CiVisuals.CiFetcher.Jenkins do
  import BlockTimer

  def start_link do
    HTTPoison.start
    start_fetching_projects

    pid = spawn_link fn -> receive do end end

    {:ok, pid}
  end

  def start_fetching_projects do
    apply_interval 5 |> seconds do
      IO.puts "fetching project data"
      check_maike_project
    end
  end

  def check_maike_project do
    url = "http://jenkins.kupferwerk.net:8080/job/hackathon-led-test/api/json"

    retrieve(url, Models.Project)
    |> retrieve_build_details
    |> IO.inspect
    |> report_status
  end

  def retrieve_build_details(%Models.Project{builds: builds}) do
    Enum.fetch!(builds, 0)["url"] <> "api/json"
    |> retrieve Models.BuildDetails
  end

  defp retrieve(url, model) do
    HTTPoison.get!(url).body
    |> Poison.decode! as: model
  end

  defp report_status(%Models.BuildDetails{result: result}) do
    color = case result do
      "FAILURE" -> Colors.RGB.red
      "SUCCESS" -> Colors.RGB.green
      _         -> Colors.RGB.yellow  # unknown status
    end

    Process.whereis(:color_service)
    |> send {:set_same_colors, color}
  end

end
