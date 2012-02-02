require 'rubygems'
require 'serialport'

port = SerialPort.new ARGV[0]
port.baud = ARGV[1].to_i
port.data_bits = 8
port.stop_bits = 1
port.parity = SerialPort::NONE
port.read_timeout = 1000
port.flow_control = SerialPort::NONE

buffer = ''
loop do
  begin
    buffer += port.read(1)
    puts buffer
    if buffer =~ /(<msg>(.+?)<.msg>)/im
      puts $1
      buffer = ''
    end
  rescue
    # at the moment we don't care when nothing comes into the port - keep on looking
  end
end
