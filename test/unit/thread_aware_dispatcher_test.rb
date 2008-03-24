require 'rubygems'
require 'test/unit'
require 'mocha'
require File.expand_path(__FILE__ + '/../../../lib/xray/thread_aware_dispatcher')

class ThreadAwareDispatcherTest < Test::Unit::TestCase

  def test_thread_aware_dispatcher_returns_original_dispath_result
    dispatcher = Class.new
    dispatcher.expects(:dispatch).with(:the_args).returns(:the_result)
    dispatcher.send :include, XRay::ThreadAwareDispatcher
    dispatcher.dispatch(:the_args)
  end

  def test_thread_aware_dispatcher_adds_accessor_for_thread_in_dispatch
    dispatcher = Class.new
    dispatcher.stubs(:dispatch)
    dispatcher.send :include, XRay::ThreadAwareDispatcher
    dispatcher.thread_in_dispatch
  end

  def test_thread_in_dispatch_is_nil_when_not_in_dispatch
    dispatcher = Class.new
    dispatcher.stubs(:dispatch)
    dispatcher.send :include, XRay::ThreadAwareDispatcher
    assert_nil dispatcher.thread_in_dispatch
  end

  def test_thread_in_dispatch_is_nil_when_dispatch_raises
    dispatcher = Class.new
    dispatcher.expects(:dispatch).raises(StandardError.new("Fake Problem"))
    dispatcher.send :include, XRay::ThreadAwareDispatcher
    dispatcher.dispatch
    flunk "Should relay exception"
  rescue StandardError
    assert_nil dispatcher.thread_in_dispatch
  end

  def test_thread_in_dispatch_is_set_to_current_thread_when_in_dispatch
    dispatcher = Class.new do
      extend Test::Unit::Assertions

      def self.dispatch(*args)
        assert_equal Thread.current, thread_in_dispatch 
      end

      include XRay::ThreadAwareDispatcher
    end
    dispatcher.dispatch
  end

end