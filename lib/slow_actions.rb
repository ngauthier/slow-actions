require 'slow_actions_parser'

class SlowActions
  def initialize
    @actions = []
  end

  def parse_file(file_path)
    sap = SlowActionsParser.new(file_path)
    @actions += sap.parse
  end

  def actions
    return @actions
  end

  def process
    # store this in a way that we can tell time based on:
    # controller
    # controller + action
    # controller + action + params
    # user
    # user + controller
    # user + controller + action
    # user + controller + action + params
    #
    # and filter by date.
    @processed_actions = []
    @actions.each do |a|
      
    end
  end

  def print
    
  end

  def print_html
    raise "Not Implemented"
  end

end
