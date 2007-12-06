$: << File.dirname(__FILE__) + '/../ext/xray'
require 'test/unit'
require 'xray'

class ThreadTest < Test::Unit::TestCase

#  def test_xray_dump_all_thread_does_not_coredump_with_one_thread
#    Thread.xray_dump_all_threads
#  end

#  def test_xray_dump_all_thread_does_not_coredump_with_multiple_threads
#    one = Thread.new { sleep 4 }
#    two = Thread.new { sleep 4 }
#    three = Thread.new { sleep 4 }
#    Thread.xray_dump_all_threads
#    one.join
#    two.join
#    three.join
#  end

 def test_xray_backtrace_is_empty_when_there_is_only_one_thread
   the_backtrace = Thread.current.xray_backtrace
   assert the_backtrace[0] =~ /#{__FILE__ + ":22"}/, the_backtrace[0]
   assert the_backtrace[0] =~ /xray_backtrace/, the_backtrace[0]
   assert the_backtrace[2] =~ %r{test/unit/testcase.rb}, the_backtrace[2]
 end

  def test_xray_backtrace_is_meaningful_for_current_thread_when_there_is_more_than_one_thread
    another_thread = Thread.new { sleep 1 }
    the_backtrace = Thread.current.xray_backtrace
    assert the_backtrace[0] =~ /#{__FILE__ + ":30"}/, the_backtrace[0]
    assert the_backtrace[0] =~ /xray_backtrace/, the_backtrace[0]
    assert the_backtrace[2] =~ %r{test/unit/testcase.rb}, the_backtrace[2]
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

