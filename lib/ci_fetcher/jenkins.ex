defmodule CiVisuals.CiFetcher.Jenkins do
  alias CiVisuals.ColorBroadcast.Animator
  import BlockTimer

  def start_link do
    HTTPoison.start
    start_fetching_projects

    Agent.start_link(fn -> "" end, name: __MODULE__)
  end

  def start_fetching_projects do
    apply_interval 2 |> seconds do
      IO.puts "fetching project data"
      check_project
    end
  end

  def check_project do
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

  defp report_status(%Models.BuildDetails{result: new_state}) do
    {changed?, old_state} = has_state_changed new_state

    if changed? do
      IO.puts "status has changed"
      start_color = color_for_state old_state
      end_color = color_for_state new_state

      case new_state do
        "SUCCESS" -> Animator.blend(start_color, end_color)
        "FAILURE" -> Animator.blend(start_color, end_color)
        _         -> Animator.rotate(end_color)
      end

      Agent.update(__MODULE__, fn old -> new_state end)
    end
  end

  defp color_for_state("FAILURE"), do: Colors.RGB.red
  defp color_for_state("SUCCESS"), do: Colors.RGB.green
  defp color_for_state(_), do: Colors.RGB.yellow

  defp has_state_changed(new_state) do
    old_state = Agent.get(__MODULE__, fn old -> old end)
    {new_state != old_state, old_state}
  end
end
