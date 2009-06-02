# encoding: utf-8
class Reference
  include Expression
  
  def to_s
    super previous.is_a?(PiProcess) ? pi_calculus[self.name] : "#{name}#{"(#{args * ', '})" unless args.empty?}"
  end

end