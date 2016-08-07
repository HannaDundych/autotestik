def sumDigits(num)
    num.to_s.split(//).inject {|sum, n| sum + n.to_i}
end
