class SlowActions
  private
  class LogEntry
    attr_accessor :controller
    attr_accessor :action
    attr_accessor :ip
    attr_accessor :date
    attr_accessor :time
    attr_accessor :method
    attr_accessor :session_id
    attr_accessor :parameters
    attr_accessor :duration
    attr_accessor :rendering
    attr_accessor :db
    attr_accessor :error_text

    def error?
      error_text.nil? || !error_text.empty?
    end
  end
end
