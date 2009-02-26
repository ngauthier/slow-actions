require File.join(File.dirname(__FILE__), 'slow_actions_computation_module')
class SlowActions
  private
  # Class to hold all #LogEntry objects that are associated with this #Controller.
  class Controller
    include Computable
    # Create a new #Controller
    #   name: The name of the #Controller
    def initialize(name)
      @name = name
      @log_entries = []
      @actions = []
    end
    # Name of the #Controller
    attr_reader :name

    # Add a #LogEntry to this #Controller
    def add_entry(la)
      @log_entries << la
      la.controller = self
    end
    # All the #LogEntry objects associated with this #Controller
    attr_reader :log_entries

    # Add an #Action as a child of this #Controller
    def add_action(a)
      @actions << a
    end
    # All the #Actions under this #Controller
    attr_reader :actions

  end
end
