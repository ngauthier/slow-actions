require 'slow_actions_parser'
require 'slow_actions_controller'

class SlowActions
  def initialize
    @log_entries = []
  end

  def parse_file(file_path)
    parser = Parser.new(file_path)
    @log_entries += parser.parse
    process
  end

  def log_entries
    return @log_entries
  end

  def print
    raise "Not Implemented"
  end

  def print_html
    raise "Not Implemented"
  end

  def controllers
    @controllers.values
  end

  private

  def process
    @controllers ||= {}
    @actions ||= {}
    @sessions ||= {}
    @log_entries.each do |la|
      next if la.processed
      c = @controllers[la.controller]
      if c.nil?
        c = Controller.new(la.controller)
        @controllers[la.controller] = c
      end
      c.add_entry(la)
    end
  end
end
