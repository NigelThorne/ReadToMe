def roman_to_int(roman)
    total = 0

    numeral_magnitudes={
        'I' => 1,
        'V' => 5,
        'X' => 10,
        'L' => 50,
        'C' => 100,
        'D' => 500,
        'M' => 1000}

    values = roman.split('').
          map{|d| numeral_magnitudes[d] }

    while (values != [])
        v = values.shift
        v = -v if( values !=[] && values[0] > v)
        total += v
    end
    total
end



if __FILE__ == $0

def test(romain, expected)
    actual = roman_to_int(romain)
    if(actual != expected)
        print "F"
        puts "\n#{romain} converted to #{actual} not #{expected}"
    else
        print "."
    end
end


test("I", 1)
test("II", 2)
test("III", 3)
test("IV", 4)
test("V", 5)
test("IX", 9)
test("X", 10)
test("XI", 11)
test("XIX", 19)
test("CDXLIV", 444)
test("LXXX", 80)
test("MMXVIII", 2018)
test("MMXIX", 2019)

end