#
# Decorate ActiveRecord connection with DB tracing
#
ActiveRecord::Base.connection.class.class_eval do
  include XRay::DTrace::Tracer

  def execute_with_tracing(sql, name=nil)
    firing('db', sql) do
       execute_without_tracing sql, name
    end
  end
  
  alias_method_chain :execute, :tracing

end