# encoding: utf-8
class Restriction
  include Expression
  
  def initialize pi_calculus, previous, *args
    super pi_calculus, previous
    @scoped = args.pop if args.last.is_a? Expression
    @scoped.instance_variable_set :@previous, self
    @args = args
  end
  
  def to_s
    super "nu(#{@args * ', '})(#{@scoped})"
  end
  
end