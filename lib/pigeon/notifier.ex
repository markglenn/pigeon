defmodule Pigeon.Notifier do
  def send_message(message) do
    do_send_message(message, 3)
  end

  defp do_send_message(_message, 0) do
    raise 'failed'
  end

  defp do_send_message(message, retries) do
    IO.puts "Sending message: #{message}"

    :timer.sleep(2000)

    do_send_message(message, retries - 1)
  end
end
