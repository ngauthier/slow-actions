class SlowActionParser
  def initialize(file_path)
    @file_path = file_path
    raise "File not found: #{file_path}" unless File.exists? file_path
    @file = File.new(file_path, 'r')
  end

  def parse
    @actions = []
    begin
      while true
        line = @file.readline
        if line =~ /^Processing/
          @actions << parse_action(line)
        end
      end
    rescue EOFError => ex
      
    end
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

  private

  def parse_action(line)
    action = {}
    if line =~ /^Processing (\S+)#(\S+) \(for (\S+) at (\S+) (\S+)\) \[(\S+)\]$/
      action[:controller] = $1
      action[:action] = $2
      action[:ip] = $3
      action[:date] = $4
      action[:time] = $5
      action[:method] = $6
    end
    line = @file.readline
    if line =~ /^\s+Session ID: (\S+)$/
      action[:session_id] = $1
    end
    line = @file.readline
    if line =~ /^\s+Parameters: (.*)$/
      action[:parameters] = $1
    end
    line = @file.readline
    if line == "\n"
      return action.merge(parse_error)
    end
    @file.readline
    line = @file.readline
    if line =~ /^Completed in (\S+)/
      action[:duration] = $1
    end
    if line =~ /Rendering: (\S+)/
      action[:rendering] = $1
    end
    if line =~ /DB: (\S+)/
      action[:db] = $1
    end
    return action
  end

  def parse_error
    line = "\n"
    while line == "\n"
      line = @file.readline
    end
    error_txt = ""
    while line != "\n"
      line = @file.readline
      error_txt += line
    end
    {:error_text => error_txt}
  end


  def self.parse(file)
    f = File.new(file)
    lines = f.read.split("\n")
    last_action = ""
    actions = Hash.new()
    lines.each do |l|
      if l =~ /Processing (\S+)/
        last_action = $1.to_s
      end
      if l =~ /Completed in (\S+)/
        actions[last_action] ||= []
        actions[last_action].push($1.to_f)
      end
    end
    stats = []
    actions.each do |k,v|
      max = v.inject(0){|m,i| m > i ? m : i}
      avg = v.inject{|m,i| m = m + i}
      avg /= v.count
      cost = Math.log(avg*v.count)
      stats.push([k,cost,max,avg,v.count])
    end

    puts "ACTION\tCOST\tMAX\tAVG\tCOUNT\t"
    stats = stats.sort{|x,y| y[1] <=> x[1]}
    ret = ""
    stats.each do |v|
      ret += "#{v[0]}\t#{v[1]}\t#{v[2]}\t#{v[3]}\t#{v[4]}\n"
    end
    return ret
  end

end
