require 'slow_actions_log_entry'
class SlowActions
  private
  class Parser

    def initialize(file_path)
      @file_path = file_path
      raise "File not found: #{file_path}" unless File.exists? file_path
      @file = File.new(file_path, 'r')
    end

    def parse
      @log_entries = []
      begin
        while true
          line = @file.readline
          if line =~ /^Processing/
            @log_entries << parse_log_entry(line)
          end
        end
      rescue EOFError => ex
        @file.close    
      end
      return @log_entries
    end

    private

    def parse_log_entry(line)
      la = LogEntry.new
      if line =~ /^Processing (\S+)#(\S+) \(for (\S+) at (\S+) (\S+)\) \[(\S+)\]$/
        la.controller = $1
        la.action = $2
        la.ip = $3
        la.date = $4
        la.time = $5
        la.method = $6
      end
      line = @file.readline
      if line =~ /^\s+Session ID: (\S+)$/
        la.session = $1
      end
      line = @file.readline
      if line =~ /^\s+Parameters: (.*)$/
        la.parameters = $1
      end
      line = @file.readline
      if line == "\n"
        error_text = parse_error
        la.error_text = error_text
        return la
      end
      @file.readline
      line = @file.readline
      if line =~ /^Completed in (\S+)/
        la.duration = $1
      end
      if line =~ /Rendering: (\S+)/
        la.rendering = $1
      end
      if line =~ /DB: (\S+)/
        la.db = $1
      end
      return la
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
      return error_txt
    end
  end
end
