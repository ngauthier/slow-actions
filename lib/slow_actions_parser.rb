require File.join(File.dirname(__FILE__), 'slow_actions_log_entry')
class SlowActions
  private
  # Text parser for #SlowActions
  class Parser

    # Create a new #Parser
    #   file_path: path to log file to parse
    #   start_date: Date object. Entries before this date are skipped
    #   end_date: Date object. Entries after this date are skipped
    # Dates are inclusive
    def initialize(file_path, start_date, end_date)
      @file_path = file_path
      raise "File not found: #{file_path}" unless File.exists? file_path
      @file = File.new(file_path, 'r')
      @start_date = start_date
      @end_date = end_date
    end
 
    # Initiate the parsing
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

    # Parse an individual entry
    #   line: one line of text
    def parse_log_entry(line)
      la = LogEntry.new
      if line =~ /^Processing (\S+)#(\S+) \(for (\S+) at (\S+) (\S+)\) \[(\S+)\]$/
        la.controller = $1
        la.action = $2
        la.ip = $3
        la.date = $4
        la.time = $5
        la.method = $6
        if la.date < @start_date or la.date > @end_date
          return nil
        end
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
      while !(line =~ /^Completed/ and line != "\n")
        line = @file.readline
      end
      if line =~ /^Completed in (\S+)/
        la.duration = $1.to_f
      end
      if line =~ /Rendering: (\S+)/
        la.rendering = $1.to_f
      else
        la.rendering = 0.0
      end
      if line =~ /DB: (\S+)/
        la.db = $1.to_f
      else
        la.db = 0.0
      end
      return la
    end

    # parse an error
    def parse_error
      line = "\n"
      while line == "\n"
        line = @file.readline
      end
      error_txt = []
      while line != "\n"
        line = @file.readline
        error_txt.push line
      end
      return error_txt.join("")
    end
  end
end
