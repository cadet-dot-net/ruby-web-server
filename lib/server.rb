require 'socket'

PORT = 8081
server = TCPServer.new('0.0.0.0', PORT)

def handle_connection(client)
  request = client.readpartial(2048)

  # client.write("Hello from server")
  client.close

  puts request
end

puts "Listening on #{PORT}. Press CTRL+C to cancel."

loop do
  client = server.accept

  Thread.new { handle_connection(client) }
end