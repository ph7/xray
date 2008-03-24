require File.expand_path(__FILE__ + '/../../test_helper')

unit_tests do

  test "thread aware dispatcher returns original dispath result" do
    dispatcher = Class.new
    dispatcher.expects(:dispatch).with(:the_args).returns(:the_result)
    dispatcher.send :include, XRay::ThreadAwareDispatcher
    dispatcher.dispatch(:the_args)
  end

  test "thread aware dispatcher adds accessor for thread in dispatch" do
    dispatcher = Class.new
    dispatcher.stubs(:dispatch)
    dispatcher.send :include, XRay::ThreadAwareDispatcher
    dispatcher.thread_in_dispatch
  end

  test "thread in dispatch is nil when not in dispatch" do
    dispatcher = Class.new
    dispatcher.stubs(:dispatch)
    dispatcher.send :include, XRay::ThreadAwareDispatcher
    assert_nil dispatcher.thread_in_dispatch
  end

  test "thread in dispatch is nil when dispatch raises" do
    begin
      dispatcher = Class.new
      dispatcher.expects(:dispatch).raises(StandardError.new("Fake Problem"))
      dispatcher.send :include, XRay::ThreadAwareDispatcher
      dispatcher.dispatch
      flunk "Should relay exception"
    rescue StandardError
      assert_nil dispatcher.thread_in_dispatch
    end
  end

  test "thread in dispatch is set to current thread when in dispatch" do
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