# encoding: utf-8
module Expression
  
  attr_accessor :next, :previous, :pi_calculus, :name, :args
  
  def initialize pi_calculus, name = nil, previous = nil, *args
    self.pi_calculus = pi_calculus
    self.name = name
    self.previous = previous
    self.args = args
    previous.next = self if previous
  end

  def method_missing name, *args, &block
    if pi_calculus.definition
      last = last.next while (last ||= self).next
      result = self
      case name
        when /^[A-Z].*$/ then last.next = Reference.new(pi_calculus, name, last, *args)
        when :[]=        then pi_calculus.processes.delete self
                              pi_calculus.processes.delete args.last
                              result = pi_calculus.instance_variable_get(:@meta).const_set last.name, PiProcess.new(pi_calculus, nil, nil, *args[0...-1])
                              result.next = args.last.next
                              args.last.next.previous = result
                              pi_calculus.processes << result
        when :call       then pi_calculus.processes.delete args.first
                              last.next = args.first.next
                              args.first.previous = last
        when :+, :|      then pi_calculus.processes.delete args.first
                              (name == :+ ? Alternative : Parallelity).new pi_calculus, self, self.next, *args.collect { |a| a.is_a?(PiProcess) ? a.next : a }
        when :nu, :ν     then root = root.previous while (root ||= args.last).previous 
                              pi_calculus.processes.delete root
                              last.next = Restriction.new pi_calculus, last, *args.collect { |a| a.is_a?(PiProcess) ? a.next : a }
                         else last.next = Causality.new pi_calculus, name, last, *args
      end
      result
    else
      #TODO
    end
  end
  
  def to_s text = nil
    "#{text}#{'.' if text && self.next}#{self.next}"
  end
  
end

module Expression2
  include Expression
  
  attr_accessor :left, :right
  
  def initialize pi_calculus, previous, left, right
    super pi_calculus, nil, previous
    (self.left = left).previous = self
    (self.right = right).previous = self
  end
  
  def to_s sign
    "(#{left}#{sign}#{right})#{".#{self.next}" if self.next}"   
  end
  
end