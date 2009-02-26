# Main class for the slow actions plugin library
require File.join(File.dirname(__FILE__), 'slow_actions_parser')
require File.join(File.dirname(__FILE__), 'slow_actions_controller')
require File.join(File.dirname(__FILE__), 'slow_actions_action')
require File.join(File.dirname(__FILE__), 'slow_actions_session')
require 'date'

# SlowActions class that is the master controller for processing slow actions
class SlowActions
  # Takes an options hash where you can specify :start_date and :end_date as "YYYY-MM-DD" strings
  def initialize(opts = {})
    @log_entries = []
    if opts[:start_date]
      @start_date = Date.strptime(opts[:start_date])
    else
      @start_date = Date.strptime
    end
    if opts[:end_date]
      @end_date = Date.strptime(opts[:end_date])
    else
      @end_date = Date.today
    end
  end

  # Parse the file found at "file_path" and add the log entries to its collection of entries.
  def parse_file(file_path)
    parser = Parser.new(file_path, @start_date, @end_date)
    @log_entries += parser.parse
    process
  end

  # All the #LogEntry objects
  def log_entries
    return @log_entries
  end

  # Print out all the actions and their statistics
  #
  #  :mincost  Lower bound on the cost of this action. See Computable.
  #  :minavg   Lower bound on the average amount of time this action ever took
  #  :minmax   Lower bound on the maximum amount of time this action ever took
  def print_actions(opts = {})
    str = ""
    str += "           Cost    Average Max\n"
    actions.sort{|x,y| y.total_cost <=> x.total_cost}.each do |a|
      next if opts[:mincost] and a.total_cost < opts[:mincost]
      next if opts[:minavg] and a.total_avg < opts[:minavg]
      next if opts[:minmax] and a.total_max < opts[:minmax]
      str += "- #{a.controller.name} : #{a.name} (#{a.log_entries.size} entries)\n"
      str += "  Total:   #{ftos a.total_cost}#{ftos a.total_avg}#{ftos a.total_max}\n"
      str += "  Render:  #{ftos a.render_cost}#{ftos a.render_avg}#{ftos a.render_max}\n"
      str += "  DB:      #{ftos a.db_cost}#{ftos a.db_avg}#{ftos a.db_max}\n"
      str += "\n"
    end
    return str
  end

  # Print out all the controllers and their statistics, nesting actions as a tree. See #print_actions for options.
  def print_controller_tree(opts = {})
    str = ""
    str += "             Cost    Average Max\n"
    controllers.sort{|x,y| y.total_cost <=> x.total_cost}.each do |c|
      next if opts[:mincost] and c.total_cost < opts[:mincost]
      next if opts[:minavg] and c.total_avg < opts[:minavg]
      next if opts[:minmax] and c.total_max < opts[:minmax]
      str += "+ #{c.name} (#{c.log_entries.size} entries)\n"
      str += "| Total:     #{ftos c.total_cost}#{ftos c.total_avg}#{ftos c.total_max}\n"
      str += "| Render:    #{ftos c.render_cost}#{ftos c.render_avg}#{ftos c.render_max}\n"
      str += "| DB:        #{ftos c.db_cost}#{ftos c.db_avg}#{ftos c.db_max}\n"
      c.actions.sort{|x,y| y.total_cost <=> x.total_cost}.each do |a|
        next if opts[:mincost] and a.total_cost < opts[:mincost]
        next if opts[:minavg] and a.total_avg < opts[:minavg]
        next if opts[:minmax] and a.total_max < opts[:minmax]
        str += "|-+ #{a.name} (#{a.log_entries.size} entries)\n"
        str += "| | Total:   #{ftos a.total_cost}#{ftos a.total_avg}#{ftos a.total_max}\n"
        str += "| | Render:  #{ftos a.render_cost}#{ftos a.render_avg}#{ftos a.render_max}\n"
        str += "| | DB:      #{ftos a.db_cost}#{ftos a.db_avg}#{ftos a.db_max}\n"
      end
      str += "\n"
    end
    return str
  end

  # Print out all the session_ids and their statistics. See #print_actions for options.
  def print_sessions(opts = {})
    str = ""
    str += "           Cost    Average Max\n"
    sessions.sort{|x,y| y.total_cost <=> x.total_cost}.each do |s|
      next if opts[:mincost] and s.total_cost < opts[:mincost]
      next if opts[:minavg] and s.total_avg < opts[:minavg]
      next if opts[:minmax] and s.total_max < opts[:minmax]
      str += "+ #{s.name} (#{s.log_entries.size} entries)\n"
      str += "| Total:   #{ftos s.total_cost}#{ftos s.total_avg}#{ftos s.total_max}\n"
      str += "| Render:  #{ftos s.render_cost}#{ftos s.render_avg}#{ftos s.render_max}\n"
      str += "| DB:      #{ftos s.db_cost}#{ftos s.db_avg}#{ftos s.db_max}\n"
      str += "\n"
    end
    return str
  end

  # Print out the stats as html. Not implemented.
  def to_html
    raise "Not Implemented"
  end

  # All the #Controller objects.
  def controllers
    @controllers.values
  end

  # All the #Action objects
  def actions
    @actions.values
  end

  # All the #Session objects
  def sessions
    @sessions.values
  end

  private

  # The Date to start parsing from
  attr_accessor :start_date
  # The Date to stop parsing at
  attr_accessor :end_date

  # Process statistics for all #Actions #Controllers and #Sessions
  def process
    @controllers ||= {}
    @actions ||= {}
    @sessions ||= {}
    @log_entries.each do |la|
      next if la.nil? or la.processed
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
        c.add_action(a)
      end
      a.add_entry(la)

      s = @sessions[la.session]
      if s.nil?
        s = Session.new(la.session)
        @sessions[la.session] = s
      end
      s.add_entry(la)
      la.processed = true
    end

    # now compute the times for each
    @controllers.values.each{|c| c.compute_times}
    @actions.values.each{|a| a.compute_times}
    @sessions.values.each{|s| s.compute_times}
  end

  # Convert a float to 7 places padded with zeros then one space
  def ftos(float)
    str = ((float*1000).to_i.to_f/1000).to_s
    while str.size < 7
      str += "0"
    end
    str += " "
  end
end
