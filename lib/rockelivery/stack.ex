defmodule Rockelivery.Stack do
  use GenServer

  def start_link(initial_stack) when is_list(initial_stack) do
    GenServer.start_link(__MODULE__, initial_stack)
  end

  @impl true
  def init(stack) do
    {:ok, stack}
  end

  def push(pid, element) do
    GenServer.cast(pid, {:push, element})
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  @impl true
  def handle_call({:push, element}, _from, stack) do
    new_stack = stack ++ [element]
    {:reply, new_stack, new_stack}
  end

  @impl true
  def handle_call(:pop, _from, [_head | _tail] = stack) do
    {popped_element, new_stack} = List.pop_at(stack, -1)

    {:reply, popped_element, new_stack}
  end

  @impl true
  def handle_call(:pop, _from, []) do
    {:reply, nil, []}
  end

  @impl true
  def handle_cast({:push, element}, stack) do
    new_stack = stack ++ [element]
    {:noreply, new_stack}
  end
end
