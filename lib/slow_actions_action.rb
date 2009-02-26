require File.join(File.dirname(__FILE__), 'slow_actions_computation_module')
class SlowActions
  private
  class Action
    include Computable
    def initialize(name, controller)
      @name = name
      @controller = controller
      @log_entries = []
    end
    attr_reader :name
    attr_reader :controller

    def add_entry(la)
      @log_entries << la
      la.action = self
    end
    attr_reader :log_entries

  end
end
