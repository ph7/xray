module XRay
  
  def self.dump_threads
    STDERR.puts "=============== XRay Inspector ==============="
    STDERR.puts "Current Thread\n    "
    STDERR.puts Thread.current.xray_backtrace.join("\n    \_ ")
    STDERR.puts "----------------------------------------------"
    Thread.list.each_with_index do |t,i| 
      STDERR.puts "Dumping Thread #{i}\n    "
      t.xray_backtrace.join("\n    \_ ")
    end
    STDERR.puts "=============================================="
    STDERR.flush
  end
  
end

trap "QUIT" do
  XRay.dump_threads
end
