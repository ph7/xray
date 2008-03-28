ActionView::Base.class_eval do
  include XRay::DTrace::Tracer
           
  def render_with_tracing(options = {}, old_local_assigns = {}, &block)
    firing('render', options.to_s) do
      raise "got here"
       render_without_tracing
    end
  end
      
  alias_method_chain :render, :tracing
          
end

