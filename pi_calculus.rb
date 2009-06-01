# encoding: utf-8
%w{expression pi_process reference causality restriction alternative parallelity}.each { |l| require File.expand_path(File.dirname(__FILE__) + '/' + l) }

#TODO: Prozessdefinitionen nach der Definition merken und nicht mehr verändern
#TODO: Prozessbeispiele PiCalculus als Vorlage nehmen

class PiCalculus
  
  attr_reader :definition, :processes
  
  def initialize &block
    @definition = true
    @processes = []
    @meta = class << self; self; end
    @meta.instance_variable_set :@self, self
    def @meta.const_missing name; @self.send name; end
    self.instance_eval &block if block
    remove_instance_variable :@definition
  end
  
  def method_missing name, *args, &block
    if definition
      (processes << PiProcess.new(self).send(name, *args, &block)).last
    else
      #TODO
    end
  end
  
  def to_s
    processes.collect { |p| (match = @meta.constants.find { |c| @meta.const_get(c) == p }) ? "#{match} = #{p}" : p }.join "\n"
  end
  
end