class SlowActions
  private
  class Action
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
