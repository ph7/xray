require File.expand_path(__FILE__ + '/../../test_helper')

unit_tests do

  test "fire a probe with no data and no block" do
    aClass = Class.new do
      include DTracer
    end

    assert_nil aClass.new.send(:fire, "probe-name")
  end

  test "fire a probe with data and no block" do
    aClass = Class.new do
      include DTracer
    end

    assert_nil aClass.new.send(:fire, "probe-name", "some data")
  end

  # test "fire a probe with block but no data" do
  #   aClass = Class.new do
  #     include DTracer
  #   end
  # 
  #   result = aClass.new.send(:fire, "probe-name") do
  #     :expected_result
  #   end
  # 
  #   assert_equal :expected_result, result
  # end
  # 
  # test "fire a probe with block and data" do
  #   aClass = Class.new do
  #     include DTracer
  #   end
  # 
  #   result = aClass.new.send(:fire, "probe-name", "some data") do
  #     :expected_result
  #   end
  # 
  #   assert_equal :expected_result, result
  # end
  
end

