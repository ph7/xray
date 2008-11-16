#
# Extend ruby-dtrace API with a more convenient one to fire custom USDT
# probes
#

require "rubygems"
require 'dtrace/provider'

class Dtrace

  class Provider
    
    alias :original_load :load
    def load
      provider_module = original_load
      
      xray_extension_module = Module.new do
        @@provider_module = provider_module
        
        def firing(function_prefix, *args)
          @@provider_module.send :"#{function_prefix}_start" do |probe|
            probe.fire(*args)
          end
          result = yield
          @@provider_module.send :"#{function_prefix}_end" do |probe|
            probe.fire(*args)
          end
          result
        end

        def fire(function_name, *args)
          @@provider_module.send function_name do |p|
            p.fire(*args)
          end
        end

      end
              
      provider_module.const_set :XRay, xray_extension_module
      provider_module     
    end
    
  end
  
end
