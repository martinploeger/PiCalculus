# encoding: utf-8
require 'rubygems'
require 'spec'
require File.expand_path(File.dirname(__FILE__) + '/../pi_calculus')

describe PiCalculus do

  it "should be empty" do
    PiCalculus.new.transitions.should be_empty
    PiCalculus.new.to_s.should == ''
  end

  it "should have one transition" do
    PiCalculus.new { a }.transitions.should == [:a]
  end

  it "should be causal" do
    PiCalculus.new { a.b.c.d }.a.b.c.transitions.should == [:d]
  end

  it "should raise an exception if a non-existent transition is called" do
    lambda {PiCalculus.new { a }.b}.should raise_error
  end

  it "should be an alternative (left test)" do
    p = PiCalculus.new { a+b }
    p.transitions.should include(:a, :b)
    p.transitions.should have(2).entries
    p.a.transitions.should be_empty
  end

  it "should be an alternative (right test)" do
    p = PiCalculus.new { a+b }
    p.transitions.should include(:a, :b)
    p.transitions.should have(2).entries
    p.b.transitions.should be_empty
  end

  it "should be commutative (alternative)" do
    p = PiCalculus.new { a+b+c }
    p.transitions.should include(:a, :b, :c)
    p.transitions.should have(3).entries
    p.b.transitions.should be_empty
  end

  it "should be a parallelity (left test)" do
    p = PiCalculus.new { a.b|c.d }
    p.transitions.should include(:a, :c)
    p.transitions.should have(2).entries
    p.a.transitions.should include(:b, :c)
    p.transitions.should have(2).entries
    p.b.transitions.should == [:c]
  end

  it "should be a parallelity (right test)" do
    p = PiCalculus.new { a.b|c.d }
    p.transitions.should include(:a, :c)
    p.transitions.should have(2).entries
    p.c.transitions.should include(:a, :d)
    p.transitions.should have(2).entries
    p.d.transitions.should == [:a]
    p.a.transitions.should == [:b]
    p.b.transitions.should be_empty
  end

  it "should be commutative (parallelity)" do
    p = PiCalculus.new { a.b|c.d|e.f }
    p.transitions.should include(:a, :c, :e)
    p.transitions.should have(3).entries
    p.a.transitions.should include(:b, :c, :e)
    p.transitions.should have(3).entries
    p.e.transitions.should include(:b, :c, :f)
    p.transitions.should have(3).entries
    p.f.transitions.should include(:b, :c)
    p.transitions.should have(2).entries
    p.b.transitions.should == [:c]
    p.c.transitions.should == [:d]
    p.d.transitions.should be_empty
  end

  it "should have a higher precedence for '+' than for '|'" do
    p = PiCalculus.new { a|b+c }
    p.transitions.should include(:a, :b, :c)
    p.transitions.should have(3).entries
    p.b.transitions.should == [:a]
    p.a.transitions.should be_empty
  end

  it "should execute taus directly" do
    p = PiCalculus.new { a.b.tau.tau.c }
    p.transitions.should == [:a]
    p.a.transitions.should == [:b]
    p.b.transitions.should == [:c]
    p.c.transitions.should be_empty
  end

  it "should execute communicating pairs in parallelity automatically" do
    p = PiCalculus.new { a!|a? }
    p.a!.to_s.should == ''
    p.transitions.should be_empty
  end

  it "should not execute taus directly when said so" do
    p = PiCalculus.new(:wait) { a.b.tau.tau.c }
    p.transitions.should == [:a]
    p.a.transitions.should == [:b]
    p.b.transitions.should == [:tau]
    p.tau.transitions.should == [:tau]
    p.tau.transitions.should == [:c]
    p.c.transitions.should be_empty
  end

  it "should be able to scope expressions" do
    p = PiCalculus.new { a.b+c }
    p.transitions.should include(:a, :c)
    p.transitions.should have(2).entries
    p.a.transitions.should == [:b]
    p.b.transitions.should be_empty
    q = PiCalculus.new { a._(b+c)}
    q.transitions.should == [:a]
    q.a.transitions.should include(:b, :c)
    q.transitions.should have(2).entries
    q.b.transitions.should be_empty
  end

  it "should be able to execute via the 'execute'-method alternatively" do
    p = PiCalculus.new { a.b.c.d.e }
    p.transitions.should == [:a]
    p.execute "a"
    p.transitions.should == [:b]
    p.execute { b }
    p.transitions.should == [:c]
    p.execute("c") { d }
    p.transitions.should == [:e]
    p.e.transitions.should be_empty
  end

  it "should be able to restrict access" do
    p = PiCalculus.new { a.nu(:b, b|c).d }
    p.transitions.should == [:a]
    p.a.transitions.should == [:c]
    p.c.transitions.should be_empty
  end

  it "should tau-switch 'communicatable' values" do
    p = PiCalculus.new { a.nu(:b, b!|b).c }
    p.transitions.should == [:a]
    p.a.transitions.should == [:c]
    p.c.transitions.should be_empty
  end

  it "should tau-switch restricted 'communicatable' values (ruby-style)" do
    p = PiCalculus.new { a.nu(:b, b!|b?).c }
    p.transitions.should == [:a]
    p.a.transitions.should == [:c]
    p.c.transitions.should be_empty
  end

  it "should make resticted 'communicatable' values tau-switchable when not executing taus directly" do
    p = PiCalculus.new(:wait) { a.nu(:b, :c, b!|b?|c!|c).d }
    p.transitions.should == [:a]
    p.a.transitions.should == [:tau, :tau]
    p.tau.tau.transitions.should == [:d]
    p.d.transitions.should be_empty
  end

  it "should be able to solve complex processes" do
    p = PiCalculus.new(:wait) { tau.tau.a._(b+c+d|e).f }
    p.transitions.should == [:tau]
    p.tau.transitions.should == [:tau]
    p.tau.transitions.should == [:a]
    p.a.transitions.should have(4).entries
    p.transitions.should include(:b, :c, :d, :e)
    p.d.transitions.should == [:e]
    p.e.transitions.should == [:f]
    p.f.transitions.should be_empty
  end

  it "should be non-deterministic in alternatives" do
    b_had = c_had = false
    b_marker = c_marker = true
    until b_had && c_had
      p = PiCalculus.new { a.b+a.c }
      p.transitions.should include(:a)
      p.transitions.uniq.should == [:a]
      p.a.transitions.should have(1).entry
      b_had ||= p.transitions.include?(:b)
      c_had ||= p.transitions.include?(:c)
      if b_had && b_marker
        p.b.transitions.should be_empty
        b_marker = false
      elsif c_had && c_marker
        p.c.transitions.should be_empty
        c_marker = false
      end
    end
  end

  it "should be non-deterministic in parallelity" do
    b_had = c_had = false
    b_marker = c_marker = true
    until b_had && c_had
      p = PiCalculus.new { a.b|a.c }
      p.transitions.should include(:a)
      p.transitions.should have(2).entries
      p.transitions.uniq.should == [:a]
      p.a.transitions.should have(2).entries
      b_had ||= p.transitions.include?(:b)
      c_had ||= p.transitions.include?(:c)
      if b_had && b_marker
        p.b.transitions.should have(1).entry
        p.transitions.should include(:a)
        p.a.c.transitions.should be_empty
        b_marker = false
      elsif c_had && c_marker
        p.c.transitions.should have(1).entries
        p.transitions.should include(:a)
        p.a.b.transitions.should be_empty
        c_marker = false
      end
    end
  end

  it "should be able to accept block-implementations" do
    p = PiCalculus.new { a{@var = 123}.b{raise "#{@var}"} }
    lambda {p.a.b}.should raise_error(RuntimeError, "123")
  end
  
  it "should scope local variables to an activity" do
    p = PiCalculus.new { a{var = 123}.b{var}}
    lambda {p.a.b}.should raise_error(NameError, "undefined local variable or method `var' for :dummy:Symbol")
  end

  # it "should accept keywords like class, raise, while, nil, self etc. as transition-names"
  # 
  # it "should have correct to_s-implementations"
  # 
  # it "should be able to hand over parameters from one process to another (PiCalculus)"

end