require File.join(File.dirname(__FILE__), 'slow_actions_computation_module')
class SlowActions
  private
  # Class to hold and #LogEntry objects that are associated with this individual Session ID
  class Session
    include Computable
    # Create a new session
    #   name: the session_id
    def initialize(name)
      @name = name
      @log_entries = []
    end
    # The session_id
    attr_reader :name

    # Add a #LogEntry to this #Session
    def add_entry(la)
      @log_entries << la
      la.session = self
    end
    # All the #LogEntry objects this #Session holds
    attr_reader :log_entries

  end
end
