# encoding: utf-8
class Causality
  include Expression

  def initialize previous, name, *args, &block
    super previous, *args, &block
    @name = name
  end

  def to_s
    super @name
  end

  def transitions
    @previous.is_a?(PiCalculus) ? [@name] : @previous.transitions
  end

end