require File.join(File.dirname(__FILE__), 'slow_actions_computation_module')
class SlowActions
  private
  class Controller
    include Computable
    def initialize(name)
      @name = name
      @log_entries = []
      @actions = []
    end
    attr_reader :name

    def add_entry(la)
      @log_entries << la
      la.controller = self
    end
    attr_reader :log_entries

    def add_action(a)
      @actions << a
    end
    attr_reader :actions

  end
end
