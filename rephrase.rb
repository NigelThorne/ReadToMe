# encoding: utf-8
#!/usr/bin/env ruby

begin
SUBSTITUTIONS = {
	/[A-Z][A-Z][A-Z][A-Z]+((?=[^A-Za-z])|(?!.))/	=> lambda{|x|x.downcase}, #All caps becomes word
	"\u0092"										=> "'",	
	/n[^a-z0-9\s]t/									=> 'n\'t',	
	/[®«]/											=> "", # don't read trademark sign
	/ A /											=> "'a'", 
	/PMs/											=> "pee-emms", 
	/RESTful/										=> "restful", 
	/Actionee/i										=> "Action-e",
	/Leica/i										=> "Likea",
	/Axeda/i										=> "Exceedar",
	/\.exe(?=[^a-z])/i								=> " executable ",
	/\.txt(?=[^a-z])/i								=> " text file ",
	/rebranded/										=> "re-branded",
	/App(?=[\s\.])/									=> " application ",
	'GUI' 											=> " gooee ",
	/localhost/										=> "local host",
	/tear/											=> "tair",
	/(?<word>[A-Z][a-z]*)(?=[A-Z ,\.;:\t\/])/		=> "'\\k<word>' ", # CamelCaseWords should be split by spaces
	/((?<!.)|(?<=\n))(?<line>[\?\-]\t[^\n]*)\n/m	=> "\n\\k<line>.\n", # dot points becomes sentances.
	/\.dll/											=> " Deelle el",
	'\\'											=> ' slash ',
	'default'										=> 'deefault',	
	'×'												=> 'times',	
	'disconnect'									=> 'dis-connect',	
}

#Hi, I'm Fred. The time is currently <say-as format="dmy" interpret-as="date">01/02/1960</say-as>

require 'cgi'

  
def to_speakxml(text)
	expression = Regexp.new(SUBSTITUTIONS.keys.join("|"))
	begin
		<<-eos
		<?xml version="1.0" encoding="UTF-8"?>
		<speak xmlns="http://www.w3.org/2001/10/synthesis" version="1.0" xml:lang="en-UK">
		<voice xml:lang="en-UK">
			#{SUBSTITUTIONS.reduce(text){ |o, (r,s)| 
				s.is_a?(Proc) ? o.gsub(r, &s) : o.gsub(r,s) }
			}
		</voice>
		</speak>
		eos
	rescue => e
		e.to_s
	end
end

if(__FILE__ == $0)
	ARGF.set_encoding(Encoding::UTF_8)

	puts to_speakxml(ARGF.read)
end

rescue => e
	puts e.to_s
end


