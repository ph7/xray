$: << File.dirname(__FILE__) + '/../ext/xray'
$: << File.dirname(__FILE__) + '/../lib'
require 'xray/xray'
require 'xray/dtrace/tracer'

require 'test/unit'
require 'rubygems'
require 'mocha'
require 'dust'

