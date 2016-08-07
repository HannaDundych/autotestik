def maxDigitsInRow(str)
 digits = str.scan(/\d+/)
 digitsLength = digits.map{|digit| digit.length}
 digitsLength.max
end
