#!/usr/bin/ruby
# <thomas.mccauley@cern.ch>

#fin  = File.open("Events/Run_142558/Event_191719231", "r")
#fout = File.open("cms-event.rb", "w")

fin  = File.open("./Geometry/Run_1/Event_1", "r")
fout = File.open("cms-geometry.v4.rb", "w")

require 'rubygems'
require 'json'

igStr = fin.read()
igStr.gsub!(/\s+/, "")
igStr.gsub!(":", "=>")
igStr.gsub!("\'", "\"")
igStr.gsub!("(", "[")
igStr.gsub!(")", "]")
igStr.gsub!("nan", "0")
#puts igStr

#ig = JSON.parse(igStr)
puts "evaling geometry"
ig = eval(igStr)
fout << ig.inspect

fin.close
fout.close


