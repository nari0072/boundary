# -*- coding: utf-8 -*-
#ex4_1
class Rubynovice
  def ex4_1
    a=[1,2,3]
    answer = ""
    #for i in 0..2 do
    #  tmp=a[i]
    a.each{|tmp|
      if tmp==1 then
        puts "One."
        answer << "One.\n"
      elsif tmp==2 then
        puts "Two."
        answer << "Two.\n"
      else
        puts "Three."
        answer << "Three.\n"
      end
    }
    return answer
  end
  #ex4_2
  def ex4_2(year)
#    a=[1868,1912,1926,1989]
#    wareki = ""
#    a.each{|year|
      if year < 1868 then
        p "江戸以前"
        return "江戸以前"
      elsif year < 1912 then
        print "明治#{year-1868+1}\n"
        return "明治#{year-1868+1}"
      elsif year < 1926 then
        print "大正#{year-1912+1}\n"
        return "大正#{year-1912+1}"
      elsif year < 1989 then
        print "昭和#{year-1926+1}\n"
        return "昭和#{year-1926+1}"
      else 
        print "平成#{year-1989+1}\n"
        return "平成#{year-1989+1}"
      end
#    }
#    return wareki
  end
  #ex4_3
  def ex4_3(a)
    for i in 2..a-1 do
      break if a%(i)==0
    end
    if i!=a-1 then 
      p "no prime"
      return false
    else
      p "prime"
      return true
    end
  end
  #ex4_4
  def ex4_4(year)
#    a = [1999,2004,1900,2000]
    if year%4==0 then
      if year%100==0 then
        if year%400==0
          p "leap year\n"
          return true
        else
          p "non leap year\n"
          return false
        end
      else
        p "leap year\n"
        return true
      end
    else
      p "non leap yaer\n"
      return false
    end
  end
end
