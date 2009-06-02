# encoding: utf-8
class Restriction
  include Expression
  
  attr_accessor :scoped
  
  def initialize pi_calculus, previous = nil, *args
    self.scoped = args.pop if args.last.is_a? Expression
    scoped.previous = self
    super pi_calculus, nil, previous
  end
  
  def to_s
    super "nu(#{args * ', '})(#{scoped})"
  end
  
end