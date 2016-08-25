defmodule Portal.Door do
  @doc """
  Starts a door with the given `color`.

  The door is given a name so we can identify
  the door by color name rather than by pid.

  The Door implements a stack-like data structure
  where the first item pushed in is the last
  item to be popped out.

  Portal.Door.push(:pink, 1)   => [1]\n
  Portal.Door.push(:pink, 2)   => [2,1]\n
  Portal.Door.push(:pink, 2)   => [2,1]\n
  Portal.Door.pop              => [1]\n
  Portal.Door.pop              => []\n
  Portal.Door.pop              => :error\n
  """
  def start_link(color) do
    Agent.start_link(fn() -> [] end, name: color)
  end

  @doc """
  Get the data currently in the `door`.
  """
  def get(door) do
    Agent.get(door, fn(list) -> list end)
  end

  @doc """
  Pushes `value` into the door at first position.
  """
  def push(door, value) do
    Agent.update(door, fn(list) -> [value|list] end)
  end

  @doc """
  Pops a `value` from the door.

  Returns `{:ok, value}` if there is a value
  or `:error` if the hole is currently empty.
  """
  def pop(door) do
    Agent.get_and_update(door, fn
      []    -> {:error, []}
      [h|t] -> {{:ok, h}, t}
    end)
  end
end
