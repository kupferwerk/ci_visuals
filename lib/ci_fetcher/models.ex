defmodule Models.Project do
  defstruct displayName: "", builds: []
end

defmodule Models.Build do
  defstruct number: 0, url: ""
end

defmodule Models.BuildDetails do
  defstruct result: "", timestamp: 0
end
