require 'slow_actions_computation_module'
class SlowActions
  private
  class Session
    include Computable
    def initialize(name)
      @name = name
      @log_entries = []
    end
    attr_reader :name

    def add_entry(la)
      @log_entries << la
      la.session = self
    end
    attr_reader :log_entries

  end
end
