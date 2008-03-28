ActionController::Base.class_eval do

  include XRay::DTrace::Tracer
  
  def perform_action_with_tracing
    firing('request', "#{self.class.to_s}##{action_name.to_s}") do
       perform_action_without_tracing
    end
  end
      
  alias_method_chain :perform_action, :tracing
          
end
