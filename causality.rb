# encoding: utf-8
class Causality
  include Expression
  
  def initialize name, pi_calculus, previous
    super pi_calculus, previous
    @name = name
  end
  
  def to_s
    super "#{@name}"
  end
  
end