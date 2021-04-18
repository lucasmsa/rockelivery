defmodule Rockelivery.Orders.ReportRunner do
  use GenServer
  require Logger

  alias Rockelivery.Orders.Report

  def start_link(_initial_state) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    schedule_report_generation()
    {:ok, state}
  end

  # Receives any kind of message,
  # it will just consume it, any process,
  # can send message that will be consumed by the
  # handle_info, it just needs to contain the pid of
  # the process the module is running on.
  # `Invoked to handle all other messages` is what the docs says
  @impl true
  def handle_info(:generate, state) do
    Logger.info("Generating report... 🐳")
    Report.create()

    schedule_report_generation()

    {:noreply, state}
  end

  def schedule_report_generation do
    Process.send_after(self(), :generate, 5000)
  end
end
