# Require this file to enable out the box DTrace tracing 
# for your Rails application
#
# You typically change your environment.rb to require it after config
# initialization:
#
#   Rails::Initializer.run do |config|
#
#     ...
#
#     config.after_initialize do
#       require "xray/dtrace/rails/enable_tracing"
#     end  
#   end

require 'xray/dtrace/tracer'
if Object.const_defined? :ActionController
  puts "Enabling controller tracing"
  require "xray/dtrace/rails/action_controller_tracing_extension"
end

if Object.const_defined? :ActiveRecord
  puts "Enabling DB tracing"
  require "xray/dtrace/rails/active_record_connection_tracing_extension"
end
