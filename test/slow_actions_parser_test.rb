require File.dirname(__FILE__) + '/test_helper'

class SlowActionsParserTest < Test::Unit::TestCase

  context "When parsing production.recent.log" do
    setup do
      @log_file = File.join(File.dirname(__FILE__), 'data', 'production.recent.log')
      @sa = SlowActions::Parser.new(@log_file, '0000-00-00', "#{Date.today.year}-#{Date.today.month}-#{Date.today.day}")
    end
    
    context "and supplying no additional arguments" do
      setup do
        @entries = @sa.parse
      end
      
      should "return all 16 entries" do
        assert_equal 16, @entries.size
      end
    end
    
    context "and supplying a :sessions argument with a single session ID" do
      setup do
        @entries = @sa.parse(:sessions => ["926fca1a3f54fdd0adc45c7406155306"])
      end
      
      should "return only 3 entries" do
        assert_equal 3, @entries.size
      end
      
      should "return only entries with the session ID" do
        assert @entries.all?{|e| e.session == "926fca1a3f54fdd0adc45c7406155306"}
      end
    end
    
    context "and supplying an :only arugement with multiple session ID's" do
      setup do
        @entries = @sa.parse(:sessions => ["926fca1a3f54fdd0adc45c7406155306", "436d4f7cab8b7da618a96d28d79162af"])
      end

      should "return 4 entries" do
        assert_equal 4, @entries.size
      end

      should "return only entries with one of the session IDs" do
        assert @entries.all?{|e| ["436d4f7cab8b7da618a96d28d79162af", "926fca1a3f54fdd0adc45c7406155306"].include?(e.session)}
      end
    end
  end

end