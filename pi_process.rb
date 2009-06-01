# encoding: utf-8
class PiProcess
  include Expression
  
  def initialize pi_calculus
    self.pi_calculus = pi_calculus
  end
  
  def to_s
    self.next.to_s
  end
  
end