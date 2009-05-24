# encoding: utf-8
class Restriction
  include Expression

  def initialize previous, *args, &block
    @scoped = args.pop if args.last.is_a? Expression
    args = args.collect { |a| a.to_s.gsub(/!|\?/, '').to_sym }
    super
  end

  def to_s
    super "ν(#{@args * ', '})(#{@scoped})"
  end

  def transitions
    unless @previous.is_a? PiCalculus
      @previous.transitions
    else
      res = @scoped ? @scoped.transitions : []
      @args.each { |x| res << :τ unless res.delete(x).nil? | res.delete("#{x}!".to_sym).nil? }
      res
    end
  end

  def execute name
    return super unless @previous.is_a?(PiCalculus) && self.transitions.include?(name)
    :dummy.instance_eval &@block if @block
    tauable =  @scoped.transitions.find_all do |t|
      n = t.to_s.gsub(/!/, '').to_sym
      t.to_s =~ /.*!/ && @scoped.transitions.include?(n) && @args.include?(n)
    end.sort_by { rand }.first
    @scoped = @scoped.execute(name == :τ && tauable ? tauable : name)
    @scoped.is_a?(PiCalculus) ? @scoped : self
  end

end