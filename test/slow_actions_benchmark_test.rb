require File.dirname(__FILE__) + '/test_helper'
require 'rubygems'
require 'ruby-prof'

class SlowActionsBenchmarkTest < Test::Unit::TestCase
  if ENV['BENCH']
    include RubyProf::Test

    def setup
      @log_file = File.join(File.dirname(__FILE__), 'data', 'development.log')
    end

    def test_loading_fifty_meg_log_file
      @sa = SlowActions.new
      @sa.parse_file(@log_file)
    end
  else
    def test_nothing_because_were_not_benchmarking
      assert true
    end
  end
end
