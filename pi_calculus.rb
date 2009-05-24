# encoding: utf-8
%w{expression causality restriction alternative parallelity}.each { |l| require File.expand_path(File.dirname(__FILE__) + '/' + l) }

class PiCalculus

  def initialize wait_at_tau = false, &block
    @definition = true
    @root = nil
    @wait_at_tau = wait_at_tau
    self.instance_eval &block if block
    remove_instance_variable :@definition
    self.τ until @wait_at_tau || !self.transitions.include?(:τ)
  end

  def method_missing name, *args, &block
    name = [:tau, :τ].include?(name.to_s.gsub(/\?|!/, '').to_sym) ? :τ : name.to_s.gsub(/\?/, '').to_sym
    if @definition
      @root = case name
        when :nu, :ν then Restriction.new self, *args, &block
        else              Causality.new self, name, *args, &block
      end
    else
      @root ? @root = @root.send(name, *args, &block) : raise("Keine Transition #{name} möglich.")
      @root = nil if @root == self
      self.τ until @wait_at_tau || !self.transitions.include?(:τ)
      self
    end
  end

  def execute text = nil, &block
    self.instance_eval text if text
    self.instance_eval &block if block
    self
  end

  def to_s
    @root ? @root.to_s : '∅'
  end

  def transitions
    @root ? @root.transitions : []
  end

end