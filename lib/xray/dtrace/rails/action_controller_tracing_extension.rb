ActionController::Base.class_eval do
            
  def perform_action_with_tracing
    XRay::DTrace::Tracer.firing('request', "#{self.class.to_s}##{action_name.to_s}") do
       perform_action_without_tracing
    end
  end
      
  alias_method_chain :perform_action, :tracing
          
end
