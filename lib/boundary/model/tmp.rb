a=[3,1,1,3,1]
a.each_with_index{|ele,i|
  if ele>2 then
    a.delete_at(i)
  end
}
p a
