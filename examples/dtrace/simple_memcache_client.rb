#!/usr/bin/env ruby -w

require "rubygems"
gem "memcache-client"
require "memcache"

CACHE = MemCache.new 'localhost:11211', :namespace => 'my_namespace'

CACHE.set "a_key", "a_valuexxxx"
# CACHE.set "a_key", "a_value"
# CACHE.set "a_key", "a_value"
# CACHE.set "a_key", "a_value"
# CACHE.set "a_key", "a_value"
# CACHE.add "a_key_that_expires", "another_value", 10
CACHE.get "a_key"
CACHE.get "a_key_that_expires"
CACHE.get "a_key"


