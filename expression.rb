# encoding: utf-8
module Expression
  
  attr_accessor :next, :previous, :pi_calculus

  def method_missing name, *args, &block
    if pi_calculus.definition
      last = last.next while (last ||= self).next
      case name
        when /^[A-Z].*$/ then last.next = Reference.new(name, pi_calculus, last, args)
        when :call       then pi_calculus.processes.delete args.first
                              last.next = args.first.next
                              args.first.previous = last
        when :+, :|      then pi_calculus.processes.delete args.first
                              (name == :+ ? Alternative : Parallelity).new pi_calculus, self, self.next, *args.collect { |a| a.is_a?(PiProcess) ? a.next : a }
        when :nu, :ν     then root = root.previous while (root ||= args.last).previous 
                              pi_calculus.processes.delete root
                              last.next = Restriction.new pi_calculus, last, *args.collect { |a| a.is_a?(PiProcess) ? a.next : a }
                         else last.next = Causality.new name, pi_calculus, last, args
      end
      self
    else
      #TODO
    end
  end
  
end