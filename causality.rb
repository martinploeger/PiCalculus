# encoding: utf-8
class Causality
  include Expression
  
  def to_s
    super "#{name}#{"(#{args * ', '})" unless args.empty?}"
  end
  
end