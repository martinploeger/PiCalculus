# encoding: utf-8
require 'pi_calculus'
# p PiCalculus.new { a.(b+c+d|e.tau) }.a.transitions

p = PiCalculus.new do
  a+b
end

p p.b.transitions