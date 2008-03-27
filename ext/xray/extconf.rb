#!/usr/bin/env ruby
require 'mkmf'
if PLATFORM["darwin"]
  $INCFLAGS = "-I$(topdir)/../universal-darwin8.0 #{$INCFLAGS}" # To get rb_thread_t from node.h
end
create_makefile("xray_native")
