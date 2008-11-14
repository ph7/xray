#!/usr/bin/env ruby -w
#
# Simple Ruby script demonstrating use of Tracer to install custom
# (application specific) Dtrace probes.
# 
# Run the script, then watch your customn probes fire in another terminal with:
#
#     sudo dtrace -n'ruby-probe { printf("%s %s", copyinstr(arg0), copyinstr(arg1)); }'
#
require "rubygems"
require "xray/dtrace/tracer"

class BookingEngine
  include XRay::DTrace::Tracer
  
  def find_available_flights(destination)
    firing "find_available_flights", destination do  
      sleep 1  # Some business logic ;-)
      ["AF98", "JB24"]
    end
  end
  
  def book(flight_number)
    firing "book", flight_number do
      sleep 3  # Very slow business logic   
    end
  end
  
  def book_all_available_flights
    find_available_flights("SFO").collect do |flight_number| 
      book flight_number
    end
  end
  
end

class Application
  extend DTracer

  def self.boot  
    # Fire a custom DTrace probe without a block (no start/end concept)
    fire "boot", Process.pid.to_s
    
    booking_engine = BookingEngine.new
    loop do      
      booking_engine.book_all_available_flights
    end
  end
  
end

Application.boot
