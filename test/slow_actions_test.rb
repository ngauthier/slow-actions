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

  should "have populated controllers" do
    sa = SlowActions.new
    sa.parse_file(@log_file)
    sa.controllers.each do |c|
      assert c.log_entries.size > 0
    end
    # Make sure each log entry belongs to a controller
    sa.log_entries.each do |la|
      assert_not_nil sa.controllers.detect{|c| c.log_entries.include?(la)}
      # and only one controller claims it
      assert_equal 1, sa.controllers.select{|c| c.log_entries.include?(la)}.size
    end
  end

  should "have populated actions" do
    sa = SlowActions.new
    sa.parse_file(@log_file)
    sa.actions.each do |a|
      assert a.log_entries.size > 0
    end
    # Make sure each log entry belongs to an action
    sa.log_entries.each do |la|
      assert_not_nil sa.actions.detect{|a| a.log_entries.include?(la)}
      # and only one action claims it
      assert_equal 1, sa.actions.select{|a| a.log_entries.include?(la)}.size
    end
  end

  should "have populated sessions" do
    sa = SlowActions.new
    sa.parse_file(@log_file)
    sa.sessions.each do |a|
      assert a.log_entries.size > 0
    end
    # Make sure each log entry belongs to a session
    sa.log_entries.each do |la|
      assert_not_nil sa.sessions.detect{|s| s.log_entries.include?(la)}
      # and only one session claims it
      assert_equal 1, sa.sessions.select{|s| s.log_entries.include?(la)}.size
    end
  end
end
