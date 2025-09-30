#!/usr/bin/env elixir

defmodule ImageServer do
  @port 8888

  def start do
    Process.flag(:trap_exit, true)

    case :gen_tcp.listen(@port, [:binary, active: false, reuseaddr: true]) do
      {:ok, socket} ->
        IO.puts("Servidor HTTP iniciado na porta #{@port}")

        # Inicia storage
        {:ok, _pid} = Agent.start_link(fn -> %{} end, name: :image_storage)

        # Loop principal
        accept_connections(socket)

      {:error, reason} ->
        IO.puts("Erro ao iniciar servidor: #{reason}")
        System.halt(1)
    end
  end

  defp accept_connections(socket) do
    case :gen_tcp.accept(socket) do
      {:ok, client_socket} ->
        spawn(fn -> handle_request(client_socket) end)
        accept_connections(socket)
      {:error, _reason} ->
        :gen_tcp.close(socket)
    end
  end

  defp handle_request(socket) do
    case :gen_tcp.recv(socket, 0, 5000) do
      {:ok, data} ->
        response = process_request(data)
        :gen_tcp.send(socket, response)
        :gen_tcp.close(socket)
      {:error, _} ->
        :gen_tcp.close(socket)
    end
  end

  defp process_request(request) do
    [request_line | _] = String.split(request, "\r\n")
    [method, path | _] = String.split(request_line, " ")

    case {method, path} do
      {"GET", "/status"} ->
        http_response(200, "text/plain", "OK")

      {"GET", "/image/" <> id} ->
        serve_image(id)

      {"POST", "/add/" <> id} ->
        store_image(id, request)

      {"GET", "/stop"} ->
        spawn(fn ->
          Process.sleep(200)
          System.stop(0)
        end)
        http_response(200, "text/plain", "Stopping")

      _ ->
        http_response(404, "text/plain", "Not Found")
    end
  end

  defp serve_image(id) do
    case Agent.get(:image_storage, &Map.get(&1, id)) do
      nil ->
        http_response(404, "text/plain", "Image not found")
      image_data ->
        http_response(200, "image/jpeg", image_data)
    end
  end

  defp store_image(id, request) do
    case extract_body(request) do
      nil ->
        http_response(400, "text/plain", "Bad Request")
      body when byte_size(body) > 0 ->
        Agent.update(:image_storage, &Map.put(&1, id, body))
        IO.puts("Stored image #{id} (#{byte_size(body)} bytes)")
        http_response(200, "text/plain", "OK")
      _ ->
        http_response(400, "text/plain", "Empty body")
    end
  end

  defp extract_body(request) do
    case :binary.split(request, "\r\n\r\n") do
      [_headers, body] -> body
      _ -> nil
    end
  end

  defp http_response(status, content_type, body) do
    status_text = case status do
      200 -> "OK"
      400 -> "Bad Request"
      404 -> "Not Found"
      _ -> "Unknown"
    end

    headers = [
      "HTTP/1.1 #{status} #{status_text}",
      "Content-Type: #{content_type}",
      "Content-Length: #{byte_size(body)}",
      "Access-Control-Allow-Origin: *",
      "Connection: close",
      ""
    ]

    Enum.join(headers, "\r\n") <> "\r\n" <> body
  end
end

# Inicia o servidor
ImageServer.start()
