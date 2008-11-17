XRay
====

Description
-----------

  XRay provides a __lightweight yet powerful toolbox for troubleshooting Ruby
  applications__ when things stop making sense. XRay includes:

* DTrace tooling
* A thread dump utility that can dump the stack trace 
  of _all_ the threads in your Ruby VM when you send a `QUIT` signal.
* GDB intrumentation to inspect C-level and Ruby level at the same time

### Project Websites ###

* Source: [http://github.com/ph7/xray/tree/master](http://github.com/ph7/xray/tree/master)
* API: [http://xray.rubyforge.org](http://xray.rubyforge.org)
* Project: [http://rubyforge.org/projects/xray](http://rubyforge.org/projects/xray)

GDB Instrumentation
-------------------

  Copy the `gdb_macros` file provided in the gem as your `~/.gdbinit` file
  and you can access Ruby level and C level information at the same time!
  Invaluable to find tough problems on platforms where DTrace is not
  available. You can find more details on how to use the gdb macros, in the
  [Troubleshooting Ruby Processes](http://ph7spot.com/publications/troubleshooting_ruby_processes).
  
Thread Dump for _All_ Threads
-----------------------------

  On any [caller for all threads](http://ph7spot.com/articles/caller_for_all_threads)-enabled 
  Ruby interpreter, you can install the XRay signal handler
  to dumping the stack trace for _all_ the threads in your Ruby VM with:

    require "rubygems"
    require "xray/thread_dump_signal_handler"

  If your Ruby interperter does not support `caller_for_all_threads` then
  you only get the stack trace of the current thread.
  
  You can trigger a thread dump at any time with

    kill -QUIT <pid of your ruby process>

  For instance you were sending the `QUIT` signal to the following Ruby
  script:
  
    #!/usr/bin/env ruby

    require "rubygems"
    require "xray/thread_dump_signal_handler"

    a_thread =Thread.new do
      loop { sleep 1; puts "." }
    end

    a_thread.join
    
  You would get a thread dump like:

    =============== XRay - Thread Dump ===============

  	------------------------------------------------------------------------------
  	#<Thread:0x255c9c sleep> alive=true priority=0
  	------------------------------------------------------------------------------
  	    /tmp/sample.rb:7
  	      \_ /tmp/sample.rb:7:in `loop'
  	      \_ /tmp/sample.rb:7
  	      \_ /tmp/sample.rb:6:in `initialize'
  	      \_ /tmp/sample.rb:6:in `new'
  	      \_ /tmp/sample.rb:6

  	------------------------------------------------------------------------------
  	#<Thread:0x22c6a8 run> [main] [current] alive=true priority=0
  	------------------------------------------------------------------------------
  	    /tmp/foo/lib/ruby/gems/1.8/gems/XRay-1.0.3/lib/xray/thread_dump_signal_handler.rb:9
  	      \_ /tmp/sample.rb:10:in `call'
  	      \_ /tmp/sample.rb:10:in `join'
  	      \_ /tmp/sample.rb:10

  	=============== XRay - Done ===============
      
  Please refer to the [caller for all threads](http://ph7spot.com/articles/caller_for_all_threads)
  article for more details.
  
DTrace
------

### Collection of D scripts ###

  Installed under `/usr/bin`, they all start with `xray_`

### Out-of-the-box Rails DTrace Instrumentation ###

  You are one require away from triggering automatically DTrace events for 
  Rails requests, database access and template rendering. As simple as 

    # environment.rb
    Rails::Initializer.run do |config|
    
      config.gem "xray"
    
    end


  If (like me) you like gem plugins. Or
    
    # environment.rb
    Rails::Initializer.run do |config|
    
      ...
    
      config.after_initialize do
        require "rubygems"
        require "xray/dtrace/rails/enable_tracing"
      end  
    end


  if you prefer tighter control.

  You then get the  following DTrace probes:

    | Probe Name    | `arg0`         | `arg1`                | Semantics
    --------------- | -------------- | --------------------- | ------------------------------------------
    | `ruby-probe`  | request-start  | <controller>#<action> | Rails start processing a controller action
    | `ruby-probe`  | request-end    | <controller>#<action> | Rails done processing a controller action
    | `ruby-probe`  | render-start   | <render options>      | Rails rendering starts
    | `ruby-probe`  | render-end     | <controller>#<action> | Rails done rendering
    | `ruby-probe`  | db-start       | <sql query>           | Rails initiates a query to the database
    | `ruby-probe`  | db-end         | <sql query>           | Rails done executing a database query

  See [`lib/xray/dtrace/rails`](http://github.com/ph7/xray/tree/master/lib/xray/dtrace/rails)
  and the bundle [D scripts](http://github.com/ph7/xray/tree/master/bin) for more details.

### Fire Your Own Application-Specific DTrace Probes ###

  See [XRay::DTrace::Tracer](http://github.com/ph7/xray/tree/master/lib/xray/dtrace/tracer.rb)
  for more details or look at a
  [an example](http://github.com/ph7/xray/tree/master/examples/dtrace/simple_ruby_script_with_tracer_custom_dtrace_instrumentation.rb).
  

Author
======

  Philippe Hanrigou,
  [http://ph7spot.com](ph7spot.com)

