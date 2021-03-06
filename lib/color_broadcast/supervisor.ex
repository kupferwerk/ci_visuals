defmodule CiVisuals.ColorBroadcast.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(CiVisuals.ColorBroadcast.Service, []),
      worker(CiVisuals.ColorBroadcast.Animator, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
