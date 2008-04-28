#
# Install a signal handler to dump backtraces for all threads
#
# Trigger it with: kill -QUIT <pid>
#  
trap "QUIT" do
  STDERR.puts "=============== XRay - Thread Dump ==============="
  if Kernel.respond_to? :caller_for_all_threads
    caller_for_all_threads.each_pair do |thread, stack|
      thread_description = thread.inspect
      thread_description << " [main]" if thread == Thread.main
      thread_description << " [current]" if thread == Thread.current
      thread_description << " alive=#{thread.alive?}"
      thread_description << " priority=#{thread.priority}"
      STDERR.puts "\n#{thread_description}\n    #{stack.join("\n      \\_ ")}\n"
    end
  else
    STDERR.puts "Current thread : #{Thread.inspect}"
    STDERR.puts caller.join("\n    \\_ ")
  end
  STDERR.puts "=============== XRay - Done ==============="
end
