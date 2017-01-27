pos_z=[0.0, 2.0, 2.0, 0.0, 2.0, 4.0, 2.0, 6.0]
air,x=[],[]
pos_num = pos_z.length
pos_num.times do |i|
  x[0] = pos_z[0]
  if pos[i] > pos[i-1]
    for j in 1..3 do
      tem = pos_z[i]
      x[j] = tem
    end
  end
  p x
end
p x

# x=[0.0, 2.0, 2.0, 4.0, 6.0]
# air=[0.0,2.0,4.0,6.0]