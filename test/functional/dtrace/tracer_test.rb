require File.expand_path(__FILE__ + '/../../../test_helper')

functional_tests do

  test "fire a probe with no data and no block" do
    aClass = Class.new do
      include XRay::DTrace::Tracer
    end

    aClass.new.fire "a name"
  end

  test "fire a probe with data and no block" do
    aClass = Class.new do
      include XRay::DTrace::Tracer
    end

    aClass.new.fire "a name", "some data"
  end

  test "Can check whether ruby-probe is enabled" do
    aClass = Class.new do
      include XRay::DTrace::Tracer
    end

    assert [true, false].include?(aClass.new.enabled?)
  end

  test "fire a probe with block and no data" do
    anObject = Class.new do
      include XRay::DTrace::Tracer
    end.new
  
    result = anObject.firing("a-name") do
      :expected_result
    end
  
    assert_equal :expected_result, result
  end
  
  test "fire a probe with block and data" do
    anObject = Class.new do
      include XRay::DTrace::Tracer
    end.new
  
    result = anObject.firing("a-name", "some data") do
      :expected_result
    end
  
    assert_equal :expected_result, result
  end
  
end

