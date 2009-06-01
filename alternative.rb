# encoding: utf-8
class Alternative
  include Expression
  
  attr_accessor :left, :right
  
  def initialize pi_calculus, previous, left, right
    self.pi_calculus = pi_calculus
    (self.previous = previous).next = self
    (self.left = left).previous = self
    (self.right = right).previous = self
  end
  
  def to_s
    "(#{left}+#{right})#{".#{self.next}" if self.next}"   
  end
  
end