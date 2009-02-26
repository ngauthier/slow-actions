class SlowActions
  private
  class Controller
    def initialize(name)
      @name = name
      @log_entries = []
    end
    attr_reader :name

    def add_entry(la)
      @log_entries << la
      la.controller = self
    end
    attr_reader :log_entries

  end
end
