$: << File.dirname(__FILE__) + '/../ext/xray'
require 'xray'

Thread.new do
  sleep 30
end

p Thread.current
p Thread.current.priority
p Thread.current.priority = 23
p Thread.current.priority
puts "##### Current backtrace"
p Thread.current.xray_backtrace
puts "##### All backtraces"
p Thread.list.collect {|t| t.xray_backtrace }

