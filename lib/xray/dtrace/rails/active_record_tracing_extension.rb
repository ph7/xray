ActiveRecord::Base.connection.class.class_eval do

  def execute_with_tracing(sql, name=nil)
    XRay::DTrace::Tracer.firing('query', sql) do
       execute_without_tracing
    end
  end
  
  alias_method_chain :execute, :tracing

end