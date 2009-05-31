# encoding: utf-8
class PiProcess
  include Expression
  
  def initialize pi_calculus
    @pi_calculus = pi_calculus
  end
  
  def []
    @pi_calculus
  end
  
end