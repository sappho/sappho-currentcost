require 'rubygems'
require 'rest_client'
require 'logger'

logger = Logger.new STDOUT
logger.level = Logger::INFO
logger.formatter = proc { |severity, datetime, progname, msg| "#{msg}\n" }

begin
  logger.info RestClient.post "http://localhost:3000/samples", {:sample => {
      :upload_code => 'testing testing 123',
      :sample_time => Time.now,
      :temperature => Float('26.4'),
      :power => Integer('600') }}, {:content_type => :json, :accept => :json}
rescue Exception => ex
  logger.error ex
end
