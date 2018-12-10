defmodule Day04.Guard do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def new(pid, id) do
    GenServer.cast(pid, {:new, id})
  end

  def sleep(pid, datetime) do
    GenServer.cast(pid, {:sleep, datetime})
  end

  def wake_up(pid, datetime) do
    GenServer.cast(pid, {:wake_up, datetime})
  end

  def sleeptimes(pid) do
    GenServer.call(pid, :sleeptimes)
  end

  @impl true
  def init([]) do
    {:ok, { nil, nil, Map.new }}
  end

  @impl true
  def handle_cast({:new, id}, {_current_id, _sleep_at, sleep_times}) do
    {:noreply, {id, nil, sleep_times}}
  end

  @impl true
  def handle_cast({:sleep, datetime}, {current_id, _sleep_at, sleep_times }) do
    {:noreply, {current_id, datetime, sleep_times}}
  end

  @impl true
  def handle_cast({:wake_up, datetime}, {current_id, sleep_at, sleep_times }) do
    current_times = Map.get(sleep_times, current_id) || []

    sleep = NaiveDateTime.to_erl(sleep_at)
    wake = NaiveDateTime.to_erl(datetime)

    {{{_, _, _}, {_, min_start, _}}, {{_, _, _}, {_, min_end, _}}} = {sleep, wake}
    sleep_times = Map.put(sleep_times, current_id, current_times ++ Enum.to_list(min_start..min_end-1))

    {:noreply, {current_id, nil, sleep_times}}
  end

  @impl true
  def handle_call(:sleeptimes, _from, {_, _, sleeptimes} = state) do
    {:reply, sleeptimes, state}
  end
end
