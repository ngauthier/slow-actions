require File.dirname(__FILE__) + '/test_helper'

class SlowActionsTest < Test::Unit::TestCase
  def setup
    @log_file = File.join(File.dirname(__FILE__), 'data', 'production.recent.log')
  end

  def teardown
    
  end

  should "be able to read actions from a file" do
    sa = SlowActions.new
    sa.parse_file(@log_file)
    assert sa.log_entries.size > 0, "No actions returned"
    assert_equal 16, sa.log_entries.size, "Wrong number of actions"
    error_action = sa.log_entries.detect{|la| la.error? }
    assert_not_nil error_action, "There should be an error action"
  end
end
