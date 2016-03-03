defmodule Pigeon.NotificationQueue do
  use GenServer

  @name Pigeon.NotificationQueue

  def start_link do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def push(message) do
    GenServer.call(@name, {:push, message})
  end

  def handle_call({:push, message}, _from, queue) do
    Process.flag(:trap_exit, true)
    pid = spawn_link(Pigeon.Notifier, :send_message, [message])
    { :reply, :ok, [pid | queue] }
  end

  def handle_info({:EXIT, from, :normal}, queue) do
    IO.puts "Successfully sent message"
    { :noreply, List.delete(queue, from) }
  end

  def handle_info({:EXIT, from, reason}, queue) do
    IO.puts "Failed to send message"
    IO.inspect(reason)
    { :noreply, List.delete(queue, from) }
  end

  def terminate(reason, state) do
    IO.inspect(reason)
    IO.puts("Terminate")
  end
end
