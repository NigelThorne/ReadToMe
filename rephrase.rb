# encoding: utf-8
#!/usr/bin/env ruby

begin
SUBSTITUTIONS = {
	# TODO:  Read urls correctly... http://aumel-constash.vsl.com.au:7990/projects/BOND/repos/bddmanagement  as http aumel-constash dot vsl dot com dot au, port 7990, projects, BOND, repos, bdd Management
	'IMHO'										    => 'In my humble opinion;',
	'D u n g e o n s & D r a g o n s' => "Dungeons and Dragons",
	/\bDM\b/													=> 'Dungeon Master',
    /\b[IVXCDLM]{2,}\b/                             => lambda{|x| roman_to_int(x).to_s },
    /\bRAM\b/                                       => 'ram',
	'JIRA'										    => 'jeerer',
	'prepended'										=> 'pre-pen-ded',
	/UCASE([0-9]+)/									=> "yous case \\1",
	/\bAPiQ\b/i										=> ' AyPeeEyeQue ',
	/\b\.Net\b/										=> " dot net ",
	"/"												=> "-n-",
	/\bunix\b/i										=> "U-nix",
	/\bposix\b/i									=> "Posiks",
	/\bgit\b/i										=> " gitt ",
	/\bLBS\b/										=> " Leica Biosystems ",
	'no.'											=>  "no .",
    'XP'											=>  'ex-pea',
    'APIs'                      					=>  'A P eyes',
    'GOTO'                      					=>  'Go Too',
    ' AND '                      					=>  ' , and ',
    ' WHEN '                      					=>  ' , when ',
    ' THEN '                      					=>  ' , then ',
    /plugin/ 										=> "plug in",
#    'WIP'                      						=>  '"Work In Progress"',
    'IMO'                      						=>  '"In My Opinion"',
	/[A-Z][A-Z][A-Z][A-Z]+((?=[^A-Za-z])|(?!.))/	=> lambda{|x|x.downcase}, #All caps becomes word
	"\u0092"										=> "'",
	/n[^a-z0-9\s]t/									=> 'n\'t',
	/[®«]/											=> "", # don't read trademark sign
	/ A /											=> "Aey",
	/PMs/											=> "pee-emms",
	/RESTful/										=> "restful",
	/Actionee/i										=> "Action-e",
	/Leica/i										=> "Liker",
	/Axeda/i										=> "Exceedar",
	/\.exe(?=[^a-z])/i								=> " executable ",
	/\.txt(?=[^a-z])/i								=> " text file ",
	/rebranded/										=> "re-branded",
	/App(?=[\s\.])/									=> " application ",
	'GUI' 											=> " gooee ",
	/localhost/										=> "local host",
	/tear/											=> "tair",
	/(?<word>[A-Z][a-z]*)(?=[A-Z ,\.;:\t\/])/		=> "'\\k<word>' ", # CamelCaseWords should be split by spaces
	/((?<!.)|(?<=\n))(?<line>[\?\-]\t[^\n]*)\n/m	=> "\n\\k<line>.\n", # dot points becomes sentences.
	/\.dll/											=> " Deelle el",
	'\\'											=> ' slash ',
	'default'										=> 'deefault',
	'×'												=> 'times',
	'disconnect'									=> 'dis-connect',
	'btw'									      	=> 'by the way',
	'vagaries'                  					=>  'vaigeries',
	'verbalised'                  					=>  'verbaleyesed',
	'(s)'                  							=>  's',
	'BOND-III'                  					=>  'BOND3',
	' is.'                  						=>  ' is .',
	'Telerik'                  						=>  'Tellerrick',
	'Taipan'										=>  'Tie-Pan',
	'Fibonacci'										=>  'Fib-on-archy',
	'understood'									=>	'understhood', #fix
	'learned'										=>  'learnt',
	'déjà-vus'										=>  'day-jar-voo',
	'deja-vus'										=>  'day-jar-voo',
	'Einstein'										=>  'Ine-stine',
	/\$(?<amount>[\d,]+)[kK]/							=> lambda{|x,matches| "#{matches[:amount]},000 dollars"},
  /\$(?<amount>[\d,]+)/               => lambda{|x,matches| "#{matches[:amount]} dollars"}
}

require_relative 'roman_to_int'
# $14,400K
# gitt
#Hi, I'm Fred. The time is currently <say-as format="dmy" interpret-as="date">01/02/1960</say-as>

require 'cgi'

# def to_speakxml(text)
#  text.gsub!(/\r?\n/, " ")
# 	expression = Regexp.union(SUBSTITUTIONS.keys)
# 	begin
# 		<<-eos
# 		<?xml version="1.0" encoding="UTF-8"?>
# 		<speak xmlns="http://www.w3.org/2001/10/synthesis" version="1.0" xml:lang="en-UK">
# 		<phoneme alphabet="ipa" ph="t&#x259;mei&#x325;&#x27E;ou&#x325;"> potato </phoneme>
# 		<voice xml:lang="en-UK">
# 			#{SUBSTITUTIONS.reduce(text){ |o, (r,s)|
# 				s.is_a?(Proc) ? o.gsub(r, &s) : o.gsub(r, s)
# 				}
# 			}
# 		</voice>
# 		</speak>
# 		eos
# 	rescue => e
# 		e.to_s
# 	end
# end

def to_speakxml(text)
  text.gsub!(/\r?\n/, " ")
	expression = Regexp.union(SUBSTITUTIONS.keys)
	begin
		<<-eos
<?xml version="1.0" encoding="UTF-8"?>
<vxml version = "2.1">
<form id="F_1">
<block>
			#{SUBSTITUTIONS.reduce(text){ |o, (r,s)|
				s.is_a?(Proc) ? o.gsub(r) {|v| s.call(*([v,v.match(r)][0..s.arity-1]))} : o.gsub(r, s)
				}
			}
		</block>
		</form>
		</vxml>
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


