require 'rubygems'
require 'serialport'

SerialPort.open(ARGV[0], ARGV[1].to_i, 8, 1) do |port|
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
end
