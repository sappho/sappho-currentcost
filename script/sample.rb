require 'rubygems'
require 'serialport'

SerialPort.open(ARGV[0], ARGV[1].to_i, 8, 1) do |port|
  port.read_timeout = 1000
  port.flow_control = SerialPort::NONE
  buffer = ''
  loop do
    begin
      buffer += port.read
      if buffer =~ /(<msg>(.+?)<\/msg>)/im
        if $1 =~ /<src>(.+?)<\/src>.*?<tmpr>(.+?)<\/tmpr>.*?<watts>(.+?)<\/watts>/i
          puts "reading = #{$1} #{$2.to_d} #{$3.to_i}"
        end
        buffer = ''
      end
    rescue
      # at the moment we don't care when nothing comes into the port - keep on looking
    end
  end
end
