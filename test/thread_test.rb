$: << File.dirname(__FILE__) + '/../ext/xray'
require 'test/unit'
require 'xray'

class ThreadTest < Test::Unit::TestCase

  def test_xray_dump_all_thread_does_not_coredump_with_one_thread
    Thread.xray_dump_all_threads
  end

  def test_xray_dump_all_thread_does_not_coredump_with_multiple_threads
    one = Thread.new { sleep 4 }
    two = Thread.new { sleep 4 }
    three = Thread.new { sleep 4 }
    Thread.xray_dump_all_threads
    one.join
    two.join
    three.join
  end

  # def test_xray_backtrace_is_empty_when_there_is_only_one_thread
  #    assert_equal [[]], Thread.list.collect {|t| t.xray_backtrace}
  # end

  def test_xray_backtrace_is_meaningful_for_current_thread_when_there_is_more_than_one_thread
    another_thread = Thread.new { sleep 4 }
    the_backtrace = Thread.current.xray_backtrace[0]
    assert_equal __FILE__ + ":27", the_backtrace
    another_thread.join
  end

#  def test_xray_backtrace_is_meaningful_when_there_is_more_than_one_thread
#     another_thread = Thread.new { sleep 0 }
#     backtraces = Thread.list.collect {|t| t.xray_backtrace }
#     assert_equal 2, backtraces.size
#     p backtraces
#     assert backtraces[0][0] =~ /#{__FILE__ + ":34"}/
#     another_thread.join
#  end

end

