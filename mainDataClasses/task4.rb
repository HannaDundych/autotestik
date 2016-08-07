def stringCompare(str1, str2)
 matchNum=0
 minStrLength = [str1.length, str2.length].min
 for i in 0..minStrLength
   if str1[i]==str2[i]
     matchNum=matchNum + 1
   else
     break
   end
 end
 
 matchNum
end
