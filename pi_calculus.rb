# encoding: utf-8
%w{expression pi_process pi_instance variable_binding reference causality restriction alternative parallelity}.each { |l| require File.expand_path(File.dirname(__FILE__) + '/' + l) }

#TODO: VariableBindings bei Referenzen verwenden
#TODO: []= anders implementieren, damit es auch für Formalparameter in Ausdrücken wie x!(:z)|x?[:a].a! verwendet werden kann

class PiCalculus
  
  attr_reader :definition
  attr_accessor :processes
  
  def initialize &block
    @definition = true
    self.processes = []
    meta.instance_variable_set :@self, self
    def meta.const_missing name; @self.send name; end
    self.instance_eval &block if block
    remove_instance_variable :@definition
  end
  
  def meta
    class << self; self; end
  end
  
  def [] index
    meta.const_get index
  end
  
  def to_s
    processes.collect { |p| (match = meta.constants.find { |c| meta.const_get(c) == p }) ? "#{match}#{"[#{p.args.join ', '}]" unless p.args.empty?} = #{p}" : p } * "\n"
  end
  
  def method_missing name, *args, &block
    if definition
      (processes << PiProcess.new(self).send(name, *args, &block)).last
    else
      #TODO
    end
  end
  
end