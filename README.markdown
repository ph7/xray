XRay
====

Description
-----------

  XRay provides a lightweight yet powerful toolbox for troubleshooting Ruby
  applications when things stop making sense. XRay includes GDB and DTrace 
  tooling, as well as a Thread Dump utility that can dump the stack trace 
  of _all_ the threads in your Ruby VM when you send a +QUIT+ signal.


* Source: http://github.com/ph7/xray/tree/master
* Project: http://rubyforge.org/projects/xray
* API: http://xray.rubyforge.org

GDB Instrumentation
-------------------

  Copy the +gdb_macros+ file provided in the gem as your ~/.gdbinit file
  and you can access Ruby level and C level information at the same time!
  Invaluable to find tough problems on platforms where DTrace is not
  available. You can find more details on how to use the gdb macros, in the
  [Troubleshooting Ruby Processes][http://ph7spot.com/publications/troubleshooting_ruby_processes].
  
Thread Dump for All Threads
---------------------------

  On an [caller_for_all_threads](http://ph7spot.com/caller_for_all_threads)
  enabled Ruby interpreter, you can install the XRay signal handler
  to dumping the stack trace for _all_ the threads in your Ruby VM with:

    require "rubygems"
    require "xray/thread_dump_signal_handler"

  You can trigger a thread dump at any time with

    kill -QUIT <pid of your ruby process>

DTrace
------

### Collection of D scripts ###

  Installed under /usr/bin, they all start with `xray_`

  ### Out-of-the-box Rails DTrace Instrumentation ###

    You are one require away from triggering automatically DTrace events for 
    Rails requests, database access and template rendering. As simple as 

      # environment.rb
      Rails::Initializer.run do |config|

        ...

        config.after_initialize do
          require "rubygems"
          require "xray/dtrace/rails/enable_tracing"
        end  
      end

  If (like me) yo like gem plugins. Or

       # environment.rb
       Rails::Initializer.run do |config|

         ...

         config.after_initialize do
           require "rubygems"
           require "xray/dtrace/rails/enable_tracing"
         end  
       end

  if you prefer tighter control.

  You then get the  following DTrace probes

  See 
  * `lib/xray/dtrace/rails/enable_tracing.rb`
  * `lib/xray/dtrace/rails/action_controller_tracing_extension.rb`
  * `lib/xray/dtrace/rails/active_record_tracing_extension.rb`

### Fire Your Own Application-Specific DTrace Probes ###

  See [XRay::DTrace::Tracer](http://github.com/ph7/xray/tree/master/lib/xray/dtrace/tracer.rb)
  for more details or look at an [custom instrumentation example](http://github.com/ph7/xray/tree/master/examples/dtrace/simple_ruby_script_with_tracer_custom_dtrace_instrumentation.rb).
  

== Author

Philippe Hanrigou,
http://ph7spot.com

