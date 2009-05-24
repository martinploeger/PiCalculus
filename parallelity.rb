# encoding: utf-8
class Parallelity
  include Expression2

  def to_s
    super '|'
  end

  def execute name
    x = super
    n = name.to_s.gsub(/!/, '').to_sym
    name.to_s =~ /.*!/ && x.transitions.include?(n) ? x.execute(n) : x
  end

end