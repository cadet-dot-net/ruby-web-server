require 'socket'

PORT = 8081
server = TCPServer.new('0.0.0.0', PORT)

def handle_connection(client)
  request = client.readpartial(2048)
  client.close
  puts request
end

def parse(request)
  method, path, version = request.lines[0].split
  
  {
    path: path,
    method: method,
    headers: parse_headers(request)
  }
end

def parse_headers(request)
  headers = {}

  request.lines[1..-1].each do |line|
    return headers if line == "\r\n"

    header, value = line.split
    header = normalise(header)

    headers[header] = value
  end
end

def normalise(header)
  header.gsub(":", "").downcase.to_sym
end

puts "Listening on #{PORT}. Press CTRL+C to cancel."

loop do
  client = server.accept

  Thread.new { handle_connection(client) }
end