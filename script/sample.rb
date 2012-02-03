require 'rubygems'
require 'serialport'
require 'rest_client'
require 'logger'

logger = Logger.new STDOUT
logger.level = Logger::INFO
logger.formatter = proc { |severity, datetime, progname, msg| "#{msg}\n" }

url = ARGV[2]
upload_code = ARGV[3]

SerialPort.open(ARGV[0], ARGV[1].to_i, 8, 1) do |port|
  port.read_timeout = 100
  port.flow_control = SerialPort::NONE
  buffer = ''
  loop do
    buffer += port.read
    if buffer =~ /<msg>.*?<tmpr>0{0,1}(\d{1,2}\.\d)<\/tmpr>.*?<watts>0{0,4}(\d{1,5})<\/watts>.*?<\/msg>/im
      sample_time = Time.now
      buffer = ''
      logger.info "reading: #{sample_time}  temp(c) #{$1}  power(w) #{$2}"
      begin
        RestClient.post "#{url}/samples", {:sample => {
            :upload_code => upload_code,
            :sample_time => sample_time,
            :temperature => Float($1),
            :power => Integer($2) }}, {:content_type => :json, :accept => :json}
      rescue Exception => ex
        logger.error ex
      end
    end
  end
end
