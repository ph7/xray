module XRay
  
  def self.dump_threads
    STDERR.puts "=============== XRay Inspector ==============="
    STDERR.puts "Current Thread\n    "
    STDERR.puts Thread.current.xray_backtrace.join("\n    \_ ")
    STDERR.puts "----------------------------------------------"
    STDERR.puts Thread.list.inspect
    STDERR.puts "=============================================="
    STDERR.flush
  end
  
end

trap "QUIT" do
  XRay.dump_threads
end
