#!/usr/bin/env ruby -w
#
# Define how you can create custom DTrace probes on the fly from
# Ruby program using the ruby-dtrace gem (USDT provider).
#
# Trace all flight search probes with:
#
#     sudo dtrace -n 'find-available-flights { printf("%s", copyinstr(arg0)); }'
#
# Trace all the flight booking probes with:
#
#     sudo dtrace -n 'book { printf("%s %d", copyinstr(arg0), arg1); }'
#
require 'rubygems'
gem "ruby-dtrace"
require 'dtrace/provider'

#
# Define custom DTrace USDT probes on the fly using ruby-dtrace
# native extensions.
# 

Dtrace::Provider.create :booking_engine do |p|
  p.probe :boot
  p.probe :find_available_flights, :string
  p.probe :book, :string, :integer
end

#
# Use these custom probes in your application
#


class BookingEngine
  
  def find_available_flights(destination)
    Dtrace::Probe::BookingEngine.find_available_flights do |p|
      p.fire(destination)
    end
    sleep 1  # Some business logic ;-)
    ["AF98", "JB24"]
  end
  
  def book(flight_number, number_of_seats)
    Dtrace::Probe::BookingEngine.book do |p|
      p.fire(flight_number, number_of_seats)
    end
    sleep 3  # Very slow business logic   
  end
  
  def book_all_available_flights
    find_available_flights("SFO").collect do |flight_number| 
      book flight_number, rand(10)
    end
  end
  
end

class Application

  def self.boot  
    # Fire a custom DTrace probe without a block (no start/end concept)
    Dtrace::Probe::BookingEngine.boot do |p|
      p.fire
    end
    
    booking_engine = BookingEngine.new
    loop do      
      booking_engine.book_all_available_flights
    end
  end
  
end

Application.boot
