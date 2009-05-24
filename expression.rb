# encoding: utf-8
module Expression

  def initialize previous, *args, &block
    @previous = previous
    @args = args
    @block = block
  end

  def to_s text
    "#{@previous.to_s + '.' unless @previous.is_a?(PiCalculus)}#{text}"
  end

  def execute name
    if @previous.is_a? PiCalculus
      raise "Keine Transition #{name} möglich." unless self.transitions.include? name
      # puts "Execute #{name}"
      :dummy.instance_eval &@block if @block
      @previous
    else
      @previous = @previous.execute name
      self
    end 
  end

  def method_missing name, *args, &block
    name = [:tau, :τ].include?(name.to_s.gsub(/\?|!/, '').to_sym) ? :τ : name.to_s.gsub(/\?/, '').to_sym
    process = process.instance_variable_get :@previous while (process ||= self).instance_variable_get :@previous
    if process.instance_variable_get :@definition
      @next = case name
        when :_, :call then c = c.instance_variable_get :@previous until (c ||= args.first).instance_variable_get(:@previous).is_a? PiCalculus
                            c.instance_variable_set :@previous, self
                            args.first
        when :nu, :ν   then Restriction.new self, *args, &block
        when :+        then Alternative.new process, self, *args, &block
        when :|        then Parallelity.new process, self, *args, &block
        else                Causality.new self, name, *args, &block
      end
      process.instance_variable_set :@root, @next
    else
      self.execute name
    end
  end

end

module Expression2
  include Expression

  def initialize previous, left, right
    super previous
    @left = left
    @right = right
  end

  def to_s sign
    super "(#{@left}#{sign}#{@right})"
  end

  def transitions
    @previous.is_a?(PiCalculus) ? @left.transitions + @right.transitions : @previous.transitions
  end

  def execute name
    return super unless @previous.is_a? PiCalculus
    it, other = [[:@left,:@right],[:@right,:@left]].sort_by { rand }.find do |x|
      self.instance_variable_get(x[0]).transitions.include? name
    end
    raise "Keine Transition #{name} möglich" unless it
    self.instance_variable_set it, res = self.instance_variable_get(it).execute(name)
    self.is_a?(Parallelity) ? res.is_a?(PiCalculus) ? self.instance_variable_get(other) : self : res
  end

end