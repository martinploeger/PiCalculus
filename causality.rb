# encoding: utf-8
class Causality
  include Expression
  
  attr_reader :name
  
  def initialize name, pi_calculus, previous
    @name = name
    self.pi_calculus = pi_calculus
    self.previous = previous
    self.previous.next = self
  end
  
  def to_s
    "#{name}#{".#{self.next}" if self.next}"
  end
  
end