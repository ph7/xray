$: << File.dirname(__FILE__) + '/../ext/xray'
$: << File.dirname(__FILE__) + '/../lib'
require 'xray'
require 'xray/thread_aware_dispatcher'

require 'test/unit'
require 'rubygems'
require 'mocha'
require 'dust'

