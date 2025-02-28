require 'socket'
require './lib/response'

PORT = 8081
SERVER_ROOT = "/tmp/web-server/"

server = TCPServer.new('0.0.0.0', PORT)

def handle_connection(client)
  request = client.readpartial(2048)
  client.close
end

def prepare_response(request)
  if request.fetch(:path) == "/"
    respond_with(SERVER_ROOT + "index.html")
  else
    respond_with(SERVER_ROOT + request.fetch(:path))
  end
end

def respond_with(path)
  if File.exist?(path)
    send_ok_response(File.binread(path))
  else
    send_file_not_found
  end
end

def send_ok_response(data)
  Response.new(code: 200, data: data)
end

def send_file_not_found
  Response.new(code: 404)
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