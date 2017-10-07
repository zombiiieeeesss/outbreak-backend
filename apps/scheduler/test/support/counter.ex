defmodule Scheduler.Counter do
  @moduledoc """
  A counter. Used for test purposes.
  """
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

  def get do
    GenServer.call(__MODULE__, :get)
  end

  def clear do
    GenServer.call(__MODULE__, :clear)
  end

  def delay_increment(delay, delta \\ 1, succeed \\ true)

  def delay_increment(delay, delta, true) do
    :timer.sleep(delay * 2)
    GenServer.call(__MODULE__, {:increment, delta})
  end

  def delay_increment(delay, _delta, false) do
    :timer.sleep(delay * 2)
    GenServer.call(__MODULE__, :fail)
  end

  def init(v) do
    {:ok, v}
  end

  def handle_call(:clear, _from, _v) do
    {:reply, :ok, 0}
  end

  def handle_call(:get, _from, v) do
    {:reply, v, v}
  end

  def handle_call({:increment, delta}, _from, v) do
    {:reply, :ok, delta + v}
  end

  def handle_call(:fail, _from, v) do
    {:reply, :error, v}
  end
end
