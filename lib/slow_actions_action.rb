require File.join(File.dirname(__FILE__), 'slow_actions_computation_module')
class SlowActions
  private
  # Class to hold all #LogEntry objects that are associated with this individual #Action on a #Controller
  class Action
    include Computable
    # Create a new #Action object.
    #   name: the #name of the #Action. i.e. "new"
    #   controller: the #Controller this #Action is a part of
    def initialize(name, controller)
      @name = name
      @controller = controller
      @log_entries = []
    end

    # Name of this #Action
    attr_reader :name
    # #Controller of this #Action
    attr_reader :controller

    # Add a log entry to this #Action
    def add_entry(la)
      @log_entries << la
      la.action = self
    end
    # All the #LogEntry objects this #Action holds
    attr_reader :log_entries

  end
end
