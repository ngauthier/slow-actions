module Computable
    attr_reader :render_avg, :db_avg, :total_avg
    attr_reader :render_max, :db_max, :total_max
    attr_reader :render_cost, :db_cost, :total_cost
    attr_reader :error_avg

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
      
      @render_avg /= @log_entries.size.to_f
      @db_avg     /= @log_entries.size.to_f
      @total_avg  /= @log_entries.size.to_f
      @error_avg  /= @log_entries.size.to_f

      # using math.log allows us to smooth out the score between
      # infrequent and very frequent actions. 0.1 is added for a
      # non-0 result
      @render_cost = @render_avg * Math.log(@log_entries.size+0.1)
      @db_cost     = @db_avg     * Math.log(@log_entries.size+0.1)
      @total_cost  = @total_avg  * Math.log(@log_entries.size+0.1)
    end
end
