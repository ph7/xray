#
# Decorate ActionController::Base with request tracing
#
ActionController::Base.class_eval do
  include XRay::DTrace::Tracer
  
  def perform_action_with_tracing
    firing('request', "#{self.class.to_s}##{action_name.to_s}") do
       perform_action_without_tracing
    end
  end
      
  def render_with_tracing(options = nil, deprecated_status = nil, &block)
    firing('render', options.to_s) do
       render_without_tracing options, deprecated_status
    end
  end

  alias_method_chain :perform_action, :tracing
  alias_method_chain :render, :tracing
          
end
