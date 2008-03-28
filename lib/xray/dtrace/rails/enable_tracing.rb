require 'xray/dtrace/tracer'
if Object.const_defined? :ActionController
  puts "Enabling controller tracing"
  require "xray/dtrace/rails/action_controller_tracing_extension"
end

if Object.const_defined? :ActiveRecord
  puts "Enabling DB tracing"
  require "xray/dtrace/rails/active_record_connection_tracing_extension"
end

if Object.const_defined? :ActionView
  puts "Enabling rendering tracing"
  require "xray/dtrace/rails/action_view_tracing_extension"
end