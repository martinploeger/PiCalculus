# encoding: utf-8
require 'pi_calculus'

p = PiCalculus.new do
  # Pk[:hallo] = eins.zwei
  Pk = eins.zwei
  Px = self.Pk.(a(1, 5)|b(2, 6))
  P0 = x(:P1).P1(1, 2, :name => "Ploeger")
  P1 = a.(b+c).d.e!|e?
  P2 = z.(x|self.P1).hallo.P2
  P3 = l.self.P1
end

puts p