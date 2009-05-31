# encoding: utf-8
module Expression
  
  def initialize pi_calculus, previous
    @pi_calculus = pi_calculus
    @previous = previous
    @previous.instance_variable_set :@next, self
  end
  
  def method_missing name, *args, &block
    if @pi_calculus.instance_variable_get :@definition
      last = last.instance_variable_get :@next while (last ||= self).instance_variable_get :@next
      case name
        when :_, :call then @pi_calculus.instance_variable_get(:@processes).delete args.first
                            arg = args.first.instance_variable_get(:@next)
                            last.instance_variable_set :@next, arg
                            arg.instance_variable_set :@previous, last
        when :+, :|    then @pi_calculus.instance_variable_get(:@processes).delete args.first
                            (name == :+ ? Alternative : Parallelity).new @pi_calculus, self, @next, *args.collect { |a| a.is_a?(PiProcess) ? a.instance_variable_get(:@next) : a}
        when :nu       then root = root.instance_variable_get :@previous while (root ||= args.last).instance_variable_get :@previous 
                            @pi_calculus.instance_variable_get(:@processes).delete root
                            last.instance_variable_set :@next, Restriction.new(@pi_calculus, last, *args.collect { |a| a.is_a?(PiProcess) ? a.instance_variable_get(:@next) : a})
                       else last.instance_variable_set :@next, Causality.new(name, @pi_calculus, last)
      end
      self
    else
      if self.transitions.include? name
        case self
          when PiProcess   then #TODO: ggf. Definition merken und Kopie verwenden
                                @next.send name, *args, &block
          when Causality   then #TODO: Referenzen auflösen
                                @previous.instance_variable_set :@next, @next
                                @next.instance_variable_set :@previous, @previous
          when Restriction then #TODO: implementieren
          when Alternative then #TODO: implementieren 
          when Parallelity then #TODO: implementieren
        end
      else
        raise "Keine Transition '#{name}' möglich."        
      end
    end
  end
  
  def transitions
    case self
      when PiProcess                then @next ? @next.transitions : []
      when Restriction              then @scoped.transitions - @args
      when Alternative, Parallelity then @left.transitions + @right.transitions
      when Causality                then [@name] #TODO: Referenzen auflösen und dann transitions aufrufen
    end
  end
  
  def to_s text = nil
    self.is_a?(PiProcess) ? "#{@next || ''}" : "#{text}#{".#{@next}" if @next}"    
  end
  
end

module Expression2
  include Expression
  
  def initialize pi_calculus, previous, left, right
    super pi_calculus, previous
    (@left = left).instance_variable_set :@previous, self
    (@right = right).instance_variable_set :@previous, self
  end
  
  def to_s sign
    super "(#{@left}#{sign}#{@right})"
  end  
end