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
# sudo dtrace -n 'book-start { printf("%s %d", copyinstr(arg0), arg1); } book-end { printf("%s %d", copyinstr(arg0), arg1); } find-available-flights-start { printf("%s", copyinstr(arg0)); } '

require 'rubygems'
gem "ruby-dtrace"
require 'dtrace/provider'
require File.dirname(__FILE__) + '/../../lib/xray/dtrace/usdt/provider_extensions'

#
# Define custom DTrace USDT probes on the fly using ruby-dtrace
# native extensions.
# 

Dtrace::Provider.create :booking_engine do |p|
  p.probe :boot
  p.probe :find_available_flights_start, :string
  p.probe :find_available_flights_end, :string
  p.probe :book_start, :string, :integer
  p.probe :book_end, :string, :integer
end

#
# Use these custom probes in your application
#

class BookingEngine
  include Dtrace::Probe::BookingEngine::XRay
  
  def find_available_flights(destination)
    firing :find_available_flights, destination do
      sleep 1  # Some business logic ;-)
      ["AF98", "JB24"]
    end
  end
  
  def book(flight_number, number_of_seats)
    firing :book, flight_number, number_of_seats do
      sleep 3  # Very slow business logic   
    end
  end
  
  def book_all_available_flights
    find_available_flights("SFO").collect do |flight_number| 
      book flight_number, rand(10)
    end
  end
  
end

class Application
  extend Dtrace::Probe::BookingEngine::XRay

  def self.boot  
      
    # Fire a custom DTrace probe without a block (no start/end concept)
    fire :boot
    
    booking_engine = BookingEngine.new
    loop do      
      booking_engine.book_all_available_flights
    end
  end
  
end

Application.boot
