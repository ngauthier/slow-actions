require File.dirname(__FILE__) + '/test_helper'

class SlowActionsTest < Test::Unit::TestCase
  context "When parsing a file using the API and no configuration options" do
    setup do
      @log_file = File.join(File.dirname(__FILE__), 'data', 'production.recent.log')
      @sa = SlowActions.new
      @sa.parse_file(@log_file)
    end

    should "be able to read actions from a file" do
      assert @sa.log_entries.size > 0, "No actions returned"
      assert_equal 16, @sa.log_entries.size, "Wrong number of actions"
      error_action = @sa.log_entries.detect{|la| la.error? }
      assert_not_nil error_action, "There should be an error action"
    end

    should "have populated controllers" do
      @sa.controllers.each do |c|
        assert c.log_entries.size > 0
      end
      # Make sure each log entry belongs to a controller
      @sa.log_entries.each do |la|
        assert_not_nil @sa.controllers.detect{|c| c.log_entries.include?(la)}
        # and only one controller claims it
        assert_equal 1, @sa.controllers.select{|c| c.log_entries.include?(la)}.size
      end
    end

    should "have populated actions" do
      @sa.actions.each do |a|
        assert a.log_entries.size > 0
      end
      # Make sure each log entry belongs to an action
      @sa.log_entries.each do |la|
        assert_not_nil @sa.actions.detect{|a| a.log_entries.include?(la)}
        # and only one action claims it
        assert_equal 1, @sa.actions.select{|a| a.log_entries.include?(la)}.size
      end
    end

    should "have populated sessions" do
      @sa.sessions.each do |a|
        assert a.log_entries.size > 0
      end
      # Make sure each log entry belongs to a session
      @sa.log_entries.each do |la|
        assert_not_nil @sa.sessions.detect{|s| s.log_entries.include?(la)}
        # and only one session claims it
        assert_equal 1, @sa.sessions.select{|s| s.log_entries.include?(la)}.size
      end
    end

    should "compute times" do
      (@sa.controllers + @sa.actions + @sa.sessions).each do |obj|
        # don't count them as faulty if they are all errors
        next if obj.error_avg == 1
        %w(total_avg total_max total_cost).each do |var|
          assert obj.send(var) > 0, "#{obj.name} should have #{var} that is not 0"
        end
      end
    end

    should "render text without errors" do
      @sa.print_actions
      @sa.print_controller_tree
      @sa.print_sessions
    end
  end
  
  context "When parsing a file using the API and passing in a sessions configuration option" do
    setup do
      @log_file = File.join(File.dirname(__FILE__), 'data', 'production.recent.log')
      @sa = SlowActions.new
      @sa.parse_file(@log_file, :sessions => ["926fca1a3f54fdd0adc45c7406155306"])
    end
    
    should "proxy the options to the Parser" do
      # and ultimately only return 3 log entries instead of all 16
      assert_equal 3, @sa.log_entries.size
    end
  end
end
