# encoding: utf-8
class Restriction
  include Expression
  
  def initialize pi_calculus, previous, *args
    @pi_calculus = pi_calculus
    @previous = previous
    @previous.instance_variable_set :@next, self
    @scoped = args.pop if args.last.is_a? Expression
    @scoped.instance_variable_set :@previous, self
    @args = args
  end
  
  def to_s
    "nu(#{@args * ', '})(#{@scoped})#{".#{@next}" if @next}"
  end
  
  def transitions
    @scoped.transitions - @args
  end
  
end