#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), '..', 'lib', 'slow_actions.rb')


puts SlowActionParser.parse(ARGV[0])

