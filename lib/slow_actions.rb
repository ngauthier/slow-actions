require 'slow_actions_parser'
require 'slow_actions_controller'
require 'slow_actions_action'
require 'slow_actions_session'

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

  def actions
    @actions.values
  end

  def sessions
    @sessions.values
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

      a = @actions[la.action]
      if a.nil?
        a = Action.new(la.action, c)
        @actions[la.action] = a
      end
      a.add_entry(la)

      s = @sessions[la.session]
      if s.nil?
        s = Session.new(la.session)
        @sessions[la.session] = s
      end
      s.add_entry(la)
    end
  end
end
