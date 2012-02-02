require 'rubygems'
require 'serialport'
require 'rest_client'
require 'logger'

logger = Logger.new STDOUT
logger.level = Logger::INFO
logger.formatter = proc { |severity, datetime, progname, msg| "#{msg}\n" }

SerialPort.open(ARGV[0], ARGV[1].to_i, 8, 1) do |port|
  port.read_timeout = 100
  port.flow_control = SerialPort::NONE
  buffer = ''
  loop do
    begin
      buffer += port.read
      if buffer =~ /<msg><src>(.+?)<\/src>.*?<time>0{0,1}(\d{1,2})\:0{0,1}(\d{1,2})\:0{0,1}(\d{1,2})<\/time><tmpr>0{0,1}(\d{1,2}\.\d)<\/tmpr>.*?<watts>0{0,4}(\d{1,5})<\/watts>.*?<\/msg>/im
        buffer = ''
        timestamp = Time.now
        devtimestamp = Time.local(timestamp.year, timestamp.month, timestamp.day, $2.to_i, $3.to_i, $4.to_i)
        logger.info "reading: #{$1} #{timestamp}  temp(c) #{$5}  power(w) #{$6}"
        begin
          RestClient.post "#{ARGV[2]}/sample/create",
              'updatecode' => ARGV[3],
              'timestamp' => timestamp,
              'devtimestamp' => Time.local(timestamp.year, timestamp.month, timestamp.day, $2.to_i, $3.to_i, $4.to_i),
              'temperature' => Float($5),
              'power' => $6.to_i
        rescue Exception => ex
          logger.error ex
        end
      end
    rescue
      # at the moment we don't care when nothing comes into the port - keep on looking
    end
  end
end
