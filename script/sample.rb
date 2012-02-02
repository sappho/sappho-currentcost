require 'rubygems'
require 'serialport'
require 'rest_client'
require 'logger'

logger = Logger.new STDOUT
logger.level = Logger::INFO
logger.formatter = proc { |severity, datetime, progname, msg| "#{msg}\n" }

url = ARGV[2]
updatecode = ARGV[3]

SerialPort.open(ARGV[0], ARGV[1].to_i, 8, 1) do |port|
  port.read_timeout = 100
  port.flow_control = SerialPort::NONE
  buffer = ''
  loop do
    buffer += port.read
    if buffer =~ /<msg><src>(.+?)<\/src>.*?<time>0{0,1}(\d{1,2})\:0{0,1}(\d{1,2})\:0{0,1}(\d{1,2})<\/time><tmpr>0{0,1}(\d{1,2}\.\d)<\/tmpr>.*?<watts>0{0,4}(\d{1,5})<\/watts>.*?<\/msg>/im
      timestamp = Time.now
      buffer = ''
      logger.info "reading: #{$1}  #{timestamp}  temp(c) #{$5}  power(w) #{$6}"
      begin
        RestClient.post "#{url}/sample/create",
            'updatecode' => updatecode,
            'timestamp' => timestamp,
            'temperature' => Float($5),
            'power' => $6.to_i
      rescue Exception => ex
        logger.error ex
      end
    end
  end
end
