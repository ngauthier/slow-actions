class SlowActions
  private
  class LogEntry
    def initialize
      self.processed = false
    end
    attr_accessor :controller
    attr_accessor :action
    attr_accessor :ip
    attr_accessor :date
    attr_accessor :time
    attr_accessor :method
    attr_accessor :session
    attr_accessor :parameters
    attr_accessor :duration
    attr_accessor :rendering
    attr_accessor :db
    attr_accessor :error_text
    attr_accessor :processed

    def error?
      return false if error_text.nil?
      return false if error_text.empty?
      return true
    end
  end
end
