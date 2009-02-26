class SlowActions
  private
  class Parser

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
        @file.close    
      end
      return @actions
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
  end
end
