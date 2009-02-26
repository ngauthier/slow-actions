require 'slow_actions_parser'

class SlowActions
  def initialize
    @log_entries = []
  end

  def parse_file(file_path)
    parser = Parser.new(file_path)
    @log_entries += parser.parse
  end

  def log_entries
    return @log_entries
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
