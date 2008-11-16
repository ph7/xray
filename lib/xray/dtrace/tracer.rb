require File.dirname(__FILE__) + '/tracer/leopard.rb'
require File.dirname(__FILE__) + '/tracer/joyent.rb'

module XRay
  module DTrace
    
    # Ruby module to fire application-level Dtrace events (using ruby-probe).
    # 
    # This module provide a convenient and unified API abstracting 
    # different tracing implementations in Leopard Ruby VM (by Apple) 
    # and in the one provided by Joyent (https://dev.joyent.com/projects/ruby-dtrace). 
    # This module also provides a NOOP implementation for Ruby VMs with 
    # no DTrace support: So you can use the exact same code while developing
    # on Linux and deploying on Solaris for instance.
    module Tracer

      # Fire an application-level probe using ruby-probe.
      #   
      # The first argument passed will be passed to the D script as arg0 for
      # the ruby-probe probe. This is conventionally a probe name.
      #   
      # The second argument is optional and can be used to pass additional
      # data into the D script as arg1.
      #
      # Example:
      #   
      # XRay::DTrace::Tracer.fire('service-start', "order processing")
      #
      # XRay::DTrace::Tracer.fire('service-stop')
      #
      def fire(name, data = nil)
      end

      # Use ruby-probe to fire 2 application-level probes before and after
      # evaling a block .
      #    
      # The first argument passed will be passed to the D script as arg0 for
      # the ruby-probe probe. The first argument is conventionally a 
      # probe base name. The probes which fire before and after the block 
      # runs will have "-start" and "-end" appended to the probe base name, 
      # respectively.
      #    
      # The second argument is optional and can be used to pass additional
      # data into the D script as arg1.
      #
      # Example:
      #    
      # XRay::DTrace::Tracer.firing('db-query', "select * from dual;") do
      #   ActiveRecord::Base.execute("select * from dual;")
      # 
      # end
      #
      # Will:
      # 1. Fire a probe with arg0 set to "db-query-start", and arg1 set
      #    to the sql query.
      # 
      # 2. Run the block and execute the SQL.
      #
      # 3. Fire a probe with arg0 set to "db-query-start".    
      def firing(name, data = nil)
        yield
      end

      # Returns true if ruby-probe probes are enabled.
      # (application-level probes for Ruby).
      def enabled?
        false
      end
    
    end

    if Object.const_defined?(:DTracer)
      actual_tracer = Tracer::Leopard
      send :remove_const, :Tracer
      Tracer = actual_tracer
    elsif Object.const_defined?(:Tracer) && Tracer.methods.include?(:fire)
      actual_tracer = Tracer::Joyent
      send :remove_const, :Tracer
      Tracer = actual_tracer
    else
      # No DTrace support, keep the NOOP implementation
    end
    
  end
end

