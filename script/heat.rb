
require 'socket'
require 'timeout'

CrcHash = [
    0x0000, 0x1021, 0x2042, 0x3063,
    0x4084, 0x50A5, 0x60C6, 0x70E7,
    0x8108, 0x9129, 0xA14A, 0xB16B,
    0xC18C, 0xD1AD, 0xE1CE, 0xF1EF
]

def buildCrcNibble crc, nibble
  ((crc << 4) & 0xFFFF) ^ CrcHash[(crc >> 12) ^ nibble]
end

def buildCrc bytes
  crc = 0xFFFF
  bytes.each do |byte|
    crc = buildCrcNibble crc, byte >> 4
    crc = buildCrcNibble crc, byte & 0x0F
  end
  crc
end

def makeReadCommand slaveAddress = 0x01, masterAddress = 0x81
  command = [slaveAddress, 0x0A, masterAddress, 0x00, 0x00, 0x00, 0xFF, 0xFF]
  crc = buildCrc command
  command << (crc & 0xFF)
  command << (crc >> 8)
  command.pack 'c*'
end

cmd = makeReadCommand
socket = TCPSocket.open('192.168.2.61', 8068)
socket.puts cmd
begin
  timeout(5) do
    reply = socket.gets(3)
  end
  rescue
end
reply.unpack('c*').each { |byte| puts byte }
