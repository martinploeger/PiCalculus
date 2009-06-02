# encoding: utf-8
class Causality
  include Expression
  
  attr_reader :name, :args
  
  def initialize name, pi_calculus, previous, args
    @name = name
    self.pi_calculus = pi_calculus
    self.previous = previous
    self.previous.next = self
    @args = args
  end
  
  def to_s
    "#{name}#{"(#{args.join ', '})" unless self.args.empty?}#{".#{self.next}" if self.next}"
  end
  
end