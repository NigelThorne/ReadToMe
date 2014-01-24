#!/usr/bin/env ruby
substitutions = [
[/[A-Z][A-Z][A-Z][A-Z]+((?=[^A-Za-z])|(?!.))/, lambda{|x|x.downcase}],
[/Leica/i, "Likea"],
[/Axeda/i, "Exceedar"],
[/\.exe(?=[^a-z])/i, " executable "],
[/\.txt(?=[^a-z])/i, " text file "],
[/rebranded/, "re-branded"],
[/ A /, "'a'"], 
[/App(?=[\s\.])/, " application "],
['GUI' , " gooee "],
[/localhost/, "local host"],
[/tear/, "tair"],
[/(?<word>[A-Z][a-z]*)(?=[A-Z])/, '\k<word> '], # CamelCaseWords should be split by spaces
[/\.dll/, " Deelle el"],
['\\', ' slash '],
['default','deefault'],	
]
# press alt to hear unmodified version

puts substitutions.reduce(ARGF.read){|o, (r,s)| s.is_a?(Proc) ? o.gsub(r, &s) : o.gsub(r,s) }