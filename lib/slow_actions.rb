class SlowActionParser
  def initialize

  end

  def self.parse(file)
    f = File.new(file)
    lines = f.read.split("\n")
    last_action = ""
    actions = Hash.new()
    lines.each do |l|
      if l =~ /Processing (\S+)/
        last_action = $1.to_s
      end
      if l =~ /Completed in (\S+)/
        actions[last_action] ||= []
        actions[last_action].push($1.to_f)
      end
    end
    stats = []
    actions.each do |k,v|
      max = v.inject(0){|m,i| m > i ? m : i}
      avg = v.inject{|m,i| m = m + i}
      avg /= v.count
      cost = Math.log(avg*v.count)
      stats.push([k,cost,max,avg,v.count])
    end

    puts "ACTION\tCOST\tMAX\tAVG\tCOUNT\t"
    stats = stats.sort{|x,y| y[1] <=> x[1]}
    ret = ""
    stats.each do |v|
      ret += "#{v[0]}\t#{v[1]}\t#{v[2]}\t#{v[3]}\t#{v[4]}\n"
    end
    return ret
  end
end
