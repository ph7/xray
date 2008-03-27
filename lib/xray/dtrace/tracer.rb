module XRay
  module DTrace
    
    module Tracer
      
      if Object.const_defined?(:DTracer)    ### Leopard tracer ###

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

     
      elsif Object.const_defined?(:Tracer) && Tracer.methods.include?(:fire)  ### Joyent Tracer ##

        raise "got here"

        def fire(name, data = nil)
          ::Tracer.fire(name, data)
        end

        def firing(name, data = nil)
          ::Tracer.fire(name, data)
        end
        def enabled?
          STDERR.puts "WARNING: XRay::DTrace.Tracer.enabled? does not work with Joyent Tracer"
          false
        end
        
      else                                ### No ruby-probe support ###
      
        def fire(name, data = nil)
        end

        def firing(name, data = nil)
          yield
        end

        def enabled?
          false
        end
        
      end
    
      end
    
  end
end