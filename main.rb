# encoding: utf-8
require 'pi_calculus'

p = PiCalculus.new do
  P1 = a.(b+c).d.e!|e?
  P2 = z.(x|self.P1).hallo.P2
  P3 = self.P1
end

puts p