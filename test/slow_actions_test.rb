require File.dirname(__FILE__) + '/test_helper'

class SlowActionsTest < Test::Unit::TestCase
  def setup
    @log_file = File.join(File.dirname(__FILE__), 'data', 'production.recent.log')
  end

  def teardown
    
  end

  should "be able to read actions from a file" do
    sap = SlowActionParser.new(@log_file)
    actions = sap.parse
    assert actions.size > 0, "No actions returned"
    assert_equal 16, actions.size, "Wrong number of actions"
    error_action = actions.detect{|a| a[:error_text] }
    assert_not_nil error_action, "There should be an error action"
  end
end
