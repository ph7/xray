module XRay
  
  module ThreadAwareDispatcher

    # Intercept dispatch with our own method when the module is included.
    def self.included(target)
      class << target
        attr_reader :thread_in_dispatch

        alias actual_dispatch dispatch
  
        # Capture as an instance variable the current 
        # thread -- which is processing current Rails request --
        # and do the actual dispatch. 
        def dispatch(*args)
          @thread_in_dispatch = Thread.current
          actual_dispatch *args
        ensure
          @thread_in_dispatch = nil
        end
  
      end
    end
  
  end
  
end