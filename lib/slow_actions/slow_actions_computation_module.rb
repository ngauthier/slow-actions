# Computable module provides the attributes and methods to compute statistics on log entries
#
# Cost is computed as
#   avg * Math.log(total + 0.1)
#
# So that it can take into account the frequency for which an action is called
module Computable
    # the average time for rendering
    attr_reader :render_avg
    # the average time for the database
    attr_reader :db_avg
    # the average time for the entire object
    attr_reader :total_avg
    # the maximum time an object ever took to render
    attr_reader :render_max
    # the maximum time an object ever took to query the database
    attr_reader :db_max
    # the maximum time an object ever took to complete the entire action
    attr_reader :total_max
    # cost for this action to render
    attr_reader :render_cost
    # cost for this action to query the db
    attr_reader :db_cost
    # cost for this action to complete
    attr_reader :total_cost
    # average error rate for this action
    attr_reader :error_avg

    # Perform all the computations in one loop
    def compute_times
      @render_avg = 0.0
      @db_avg = 0.0
      @total_avg = 0.0
      @render_max = 0.0
      @db_max = 0.0
      @total_max = 0.0
      @error_avg = 0.0
        
      @log_entries.each do |la|
        if la.error?
          @error_avg += 1.0
          next
        end
        @render_avg += la.rendering
        @db_avg     += la.db
        @total_avg  += la.duration
        @render_max = la.rendering    if la.rendering    > @render_max
        @db_max     = la.db           if la.db           > @db_max
        @total_max  = la.duration     if la.duration     > @total_max
      end
      
      @render_avg /= @log_entries.size.to_f - @error_avg + 0.0001
      @db_avg     /= @log_entries.size.to_f - @error_avg + 0.0001
      @total_avg  /= @log_entries.size.to_f - @error_avg + 0.0001
      @error_avg  /= @log_entries.size.to_f

      # using math.log allows us to smooth out the score between
      # infrequent and very frequent actions. 0.1 is added for a
      # non-0 result
      @render_cost = @render_avg * Math.log(@log_entries.size+0.1)
      @db_cost     = @db_avg     * Math.log(@log_entries.size+0.1)
      @total_cost  = @total_avg  * Math.log(@log_entries.size+0.1)
    end
end
