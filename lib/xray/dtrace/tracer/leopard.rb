module XRay
  module DTrace
    module Tracer

      # Wrapper around OS X DTracer exposing a custom API and namespace.
      module Leopard
      
        def fire(name, data = nil)
          DTracer.fire(name, data)
        end

        def firing(name, data = nil)
          fire(name + "-start", data)
          result = yield
          fire(name + "-end", data)
          result
        end

        def enabled?
          DTracer.enabled?
        end
      
      end
      
    end
    
  end
end