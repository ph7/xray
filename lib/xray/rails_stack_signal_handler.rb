#
# Install a signal handler dumping Rails stack by raising an exception
#
# Trigger it with: kill -QUIT <pid>
#  

trap "QUIT" do
  STDERR.puts "=============== XRay - Raising exception in Rails thread ==============="
  if Dispatcher.thread_in_dispatch
    Dispatcher.thread_in_dispatch.raise "XRay - Forced exception to Rails stack trace"
  else
    STDERR.puts "No Rails thread in dispatch"
  end
  STDERR.puts "=============== XRay - Done ==============="
end
