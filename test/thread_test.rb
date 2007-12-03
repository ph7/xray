$: << File.dirname(__FILE__) + '/../ext/xray'
require 'test/unit'
require 'xray'

class ThreadTest < Test::Unit::TestCase

  def test_thread_backtrace
     p Thread.list
     p Thread.current
     p Thread.current.priority
     Thread.current.priority = 24
     p Thread.current.priority
     p Thread.current.xray_backtrace
  end

end

