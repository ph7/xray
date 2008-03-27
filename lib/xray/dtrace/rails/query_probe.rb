module DTracer
  module QueryProbe
    
    def self.included(base)
      base.class_eval do
        
        alias_method :untraced_execute, :execute
        
        def traced_execute(sql, name=nil)
          XRay::DTrace::Tracer.firing('query-start', sql) { untraced_execute }
        end
        
        alias_method :execute, :traced_execute
      end
    end
    
  end
end
