p number=ARGV[0]
p tmp=number.split('/')
numerator,divider=tmp[0].to_f,tmp[1].to_f
p numerator
p divider

max=6.0
min=0.0
p bound=(max-min)/(divider-1)
pos_z=[0.0, 2.0, 2.0, 0.0, 2.0, 4.0, 2.0, 6.0]
air,x=[],[]
d = 0.1
pos_z.each_with_index do |pos,i|
  if pos < bound+d and pos > bound-d
    air << i
  end
end
p pos_z
p air


