require 'slow_actions_parser'

class SlowActions
  def initialize
    @actions = []
  end

  def parse_file(file_path)
    parser = Parser.new(file_path)
    @actions += parser.parse
  end

  def actions
    return @actions
  end

  def process
    raise "Not Implemented"
  end

  def print
    raise "Not Implemented"
  end

  def print_html
    raise "Not Implemented"
  end

end
