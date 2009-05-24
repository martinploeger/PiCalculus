# encoding: utf-8
require 'pi_calculus'
# p PiCalculus.new { a.(b+c+d|e.tau) }.a.transitions






process = PiCalculus.new { a.b+x.y } #=> b|x.y
process.a
p process.transitions
#Hier Ausdrücke testen:

# p1 = PiCalculus.new { a.b }
# p2 = PiCalculus.new { x(:z).z[a] }
# p2.x[p1]
# beide Arten von Klammerung benutzen für Parameterübergabe und Aufruf. Evtl. auch für weiter Parameter an Blöcke???
# Methoden, die auf self (PiCalculus) aufgerufen werden spalten einen komplett neuen Prozess ab.
#Variablen von der Art eines PiCalculus können als Parameter in Ausdrücken übergeben werden.

#x!<> output => hier x![]
#x() input   => hier x() Achtung: Trennung Definition und Ausführung beachten

#Fragezeichen komplett integrieren und nicht gleich rausschmeissen
#Threading? Objektspace?

#Statt Konstanten lieber im Konstruktor einen Namen übergeben?

#Referenz-Objekte bauen und Original-Definition im Prozess hinterlegen

#Granularität von Aktivitäten (atomar = Lösung?!?)
#Sperr-Regeln oder Politiken

# p = PiCalculus.new("Prozess1") { a.b.c.Prozess1 }
# puts p
# 
# 
# x = Person.new
# a{x.name = "Plöger"; x.vorname = "Martin"}|b{x.name = "Schwägermann"; x.vorname = "Julia"}
# 
# 
# 
# 
# p = PiCalculus.new { a|b }
# p.semantify :a { x.name = "Plöger"; x.vorname = "Martin" }
# 
# 
# 
# 
# 1. Lösung (Erlang): Arbeiten IMMER auf Kopien (by-value) => zu besonderem Programmierstil
# 2. Lösung (Linda): Alle Objekte in einem Objectspace     => besonderer Programmierstil, da immer explizit (get, put, read)
# 
# 
# 
# 
# x = Person.new
# p = PiCalculus.new(:access => {:person => x} ) { a|b } #Hier wird ein Proxy um x erzeugt, der serialisiert
# p.semantify :a { person.name = "Plöger"; person.vorname = "Martin" }
# 
# 
# 
# x = Person.new "Willi"
# 
# transation do #Hier wird x kopiert
#   x.name = "Martin"
#   x.plz = 4711
#   raise Exception
# end #Hier wird x gemerged
# 
# 
# P(l, r) = (essen{l.nimm; r.nimm; sleep rand; l.gib; r.gib}+denken{sleep rand}).P
# Problem = P(g1, g2)|P(g2, g3)|P(g3, g4)|P(g4, g5)|P(g5, g1)
# 
# 
# 
# P(l, r) = (l_nimm{beginn(123);l.nimm}.r_nimm{r.nimm; commit(123)} + r_nimm{r.nimm}.l_nimm{l.nimm} + denken).P
# 
# 
# 
# 
# a{beginn}|b{commit}
# 
# x = Person.new
# Klaus = 123
# Process( {x => :Klaus})  { a{Klaus.name}.b.c}
# 
# 
# 
# 
# 
# concurrent(this.a(), this.b()).this.c();
# 
# 
# process = a{x.a; y.delete}|b{x.b}.c{self.c}
# 
# def process.a2
#   puts "hihi"
# end
# 
# def b
#   puts "hoho"
# end
# 
# def c
#   puts "hehe"
# end
# 
# (a|b).c
# 
# 
# a+b
# 
# 
# 
# 
# t1 = Thread.new {
#   this.wait();
#   ....
# }
# t2 = Thread.new {
#   this.
# }
# 
# 
# 
# x = Person.new
# 
# OS.put "x", x
# 
# 
# def put name, obj
#   self.hash.put name, obj.clone
# end
# 
# 
# 
# x2 = OS.get "x"
# 
# x.name = "Fehler"
# x = 1
# a{x = 2}.(b{ puts x}+c.rollback)#nebenläufig
# x = 5
# 
# a{begin; x = 2; b{commit}+c{rollback}}
# 
# 
# 
# (this.a()|x.b()).this.c
# 
# 
# concurrent(concurrent(a(), b(), coordinator), c(), coordinator2)
# 
# 
# 
# 
# x = Person.new
# a{x.name = "martin"}.b{x.alter = 27}|c{x.name = "julia"}.d{x.alter = 23}
# 
# with(x): a => b
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# Pid ! (self(), op)
# receive {Pic, answer, Result}
# 
# 
# x = [op1, op2].sort_by { rand }
# Result  = Pid ! (self(), x[0])
# Result2 = Pid2 . (self(), x[1])
# Loggingmeldung
# Result + Result2
# 
# 
# p = Person.new "Willi"
# result = self ! op1(p) #Rufen setter auf
# result2 = self ! op2(p) # ""
# 
# 
#   <liste name="CDs">
#     <eintrag interpret="Metallica" name="Black Album"/>
#     <eintrag interpret="AC/DC" name="Powerage"/>
#   </liste>


# 
# x = 123
# p = PiCalculus.new { a{puts "hallo"}.b{x += 1}.c{puts x}}
# q = p.a.b.c
# p q


# test = PiCalculus.new { nu(:a, (a!{puts "test"}|a?).b{puts "fertig"}){puts "Hihi"}.c}
# puts test
p = PiCalculus.new {
  P0 = P1.x.y #In PiCalculus einfach jede method_missing oder NameError abfangen und als self.send e.name aufrufen => neuer Prozess wird erzeugt, auf dem dann die anderen Methoden aufschlagen.
  P1 = a.b.c.P2
  P2 = x.y.z.P1
}
p[:P1].a! # oder nicht-deterministisch: p.a!

#p.[] oder p.processes oder p.__processes__ oder so liefert Liste oder Hash mit Prozessen
