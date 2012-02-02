require 'rubygems'
require 'serialport'

SerialPort.open(ARGV[0], ARGV[1].to_i, 8, 1) do |port|
  port.read_timeout = 100
  port.flow_control = SerialPort::NONE
  buffer = ''
  loop do
    begin
      buffer += port.read
      if buffer =~ /<msg><src>(.+?)<\/src>.*?<time>0{0,1}(\d{1,2})\:0{0,1}(\d{1,2})\:0{0,1}(\d{1,2})<\/time><tmpr>0{0,1}(\d{1,2}\.\d)<\/tmpr>.*?<watts>0{0,4}(\d{1,5})<\/watts>.*?<\/msg>/im
        timestamp = Time.now
        devtime = Time.local(timestamp.year, timestamp.month, timestamp.day, $2.to_i, $3.to_i, $4.to_i)
        puts "reading = #{$1} #{timestamp} #{devtime} #{$5} #{$6}"
        buffer = ''
      end
    rescue
      # at the moment we don't care when nothing comes into the port - keep on looking
    end
  end
end
