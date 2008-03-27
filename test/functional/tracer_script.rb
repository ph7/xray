$: << File.dirname(__FILE__) + '/../../lib'
require 'xray/dtrace/tracer'

class Service
  include XRay::DTrace::Tracer
  
  def process
    puts "Processing new request"
    firing "my-service-start", "a sql query" do
      sleep 2
    end
  end
  
end

loop do
  Service.new.process
end
