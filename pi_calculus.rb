# encoding: utf-8
%w{expression pi_process causality restriction alternative parallelity}.each { |l| require File.expand_path(File.dirname(__FILE__) + '/' + l) }
class PiCalculus
  
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
    if @definition
      (@processes << PiProcess.new(self).send(name, *args, &block)).last
    else
      (match = @processes.sort_by { rand }.find { |p| p.transitions.include? name }) ? (match.send(name); self) : raise("Keine Transition '#{name}' möglich.")
    end
  end
  
  def[] index
    case index
      when Integer        then @processes[index] || raise("Kein Prozess mit Index '#{index}' vorhanden.")
      when String, Symbol then @meta.const_defined?(index) ? @meta.const_get(index) : raise("Kein Prozess mit Namen '#{index}' vorhanden.")
    end
  end
  
  def transitions
    @processes.collect { |p| p.transitions }.flatten
  end
  
  def to_s
    @processes.collect { |p| (match = @meta.constants.find { |c| @meta.const_get(c) == p }) ? "#{match} = #{p}" : "#{p}" }.join "\n"
  end
  
end