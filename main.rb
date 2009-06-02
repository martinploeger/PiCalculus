# encoding: utf-8
require 'pi_calculus'

p = PiCalculus.new do
  Pk[:hallo] = eins.zwei.x!(:hallo)|x?(:a).a! #TODO |x?[:a].a!
  Pl[:x] = eins(:x, 2).zwei.Pk(:x)
  Px[:a] = self.Pl(:a).(a(1, 5)|b(2, 6))
  P0 = x(:P1).P1(1, 2, :name => "Ploeger")
  P1 = a.x.(b+c).d.e!|e?
  P2 = z.(x|self.P1).hallo.P2
  P3 = l.self.P1
end

puts p