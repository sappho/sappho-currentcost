require 'rubygems'
require 'serialport'

port = SerialPort.new ARGV[0], ARGV[1]
port.read_timeout = 1000

buffer = ''
loop do
  begin
    buffer += port.read(1)
    if buffer =~ /(<msg>(.+?)<.msg>)/im
      puts $1
      buffer = ''
    end
  rescue
    # at the moment we don't care when nothing comes into the port - keep on looking
  end
end
