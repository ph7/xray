module XRay
  module DTrace
    module Tracer
    
      # Wrapper around OS X DTracer exposing a custom API and namespace.
      module Joyent

        def fire(name, data = nil)    #:nodoc: all      
          ::Tracer.fire(name, data)
        end

        def firing(name, data = nil) #:nodoc: all      
          ::Tracer.fire(name, data)
        end
      
        def enabled?  #:nodoc: all      
          STDERR.puts "WARNING: XRay::DTrace.Tracer.enabled? does not work with Joyent Tracer"
          false
        end
            
      end
      
    end  
  end
end