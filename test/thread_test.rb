$: << File.dirname(__FILE__) + '/../ext/xray'
require 'test/unit'
require 'xray'

class ThreadTest < Test::Unit::TestCase

  def test_thread_backtrace
     p Thread.current.xray_backtrace
  end

end

