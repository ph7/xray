$: << File.dirname(__FILE__) + '/../../ext/xray'
$: << File.dirname(__FILE__) + '/../../lib'
require 'xray/xray'

class Service
  include DTracer
  
  def process
    puts "Processing new request"
    fire "my-service-start", "a sql query"
    sleep 2
    fire "my-service-end", "a sql query"
  end
  
end

loop do
  Service.new.process
end
