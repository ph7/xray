#!/usr/bin/env ruby -w
#
# Simple Ruby script simulating a flight booking engine
# before we add any custon DTrace instrumentation
#
class BookingEngine
  
  def find_available_flights(destination)
      sleep 1  # Some business logic ;-)
      ["AF98", "JB24"]
  end
  
  def book(flight_number, number_of_seats)
      sleep 3  # Very slow business logic   
  end
  
  def book_all_available_flights
      book flight_number, rand(10)
  end
  
end

class Application

  def self.boot  
    booking_engine = BookingEngine.new
    loop do      
      booking_engine.book_all_available_flights
    end
  end
  
end

Application.boot
