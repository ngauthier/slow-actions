class SlowActions
  private
  # Object representing a single entry in a rails application's log file
  class LogEntry
    # Create a new #LogEntry
    def initialize
      self.processed = false
    end
    # The #Controller
    attr_accessor :controller
    # The #Action
    attr_accessor :action
    # IP address of user
    attr_accessor :ip
    # date
    attr_accessor :date
    # time
    attr_accessor :time
    # HTTP Method
    attr_accessor :method
    # Session ID
    attr_accessor :session
    # Parameters to the action
    attr_accessor :parameters
    # Total duration to complete
    attr_accessor :duration
    # time spent rendering
    attr_accessor :rendering
    # time spent in the database
    attr_accessor :db
    # error text (if any)
    attr_accessor :error_text
    # whether or not is has already been processed by #SlowActions
    attr_accessor :processed

    # Whether or not this #LogEntry was an error
    def error?
      return false if error_text.nil? or error_text.empty?
      return true
    end
  end
end
