module XRay
  module DTrace
    module Rails
      module RequestProbe
        
        def self.included(base)
          base.class_eval do
            
            alias_method :untraced_perform_action, :perform_action
      
            def traced_perform_action
              traced_action = self.class.to_s + '#' + action_name.to_s
              XRay::DTrace::Tracer.firing('request', traced_action) { untraced_perform_action }
            end
      
            alias_method :perform_action, :traced_perform_action
          end
          
        end
      end
      
    end    
  end
end
