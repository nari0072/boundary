=begin
real_pos=[]
    atom.each{|i|
    #atom_size.times{|i|
    rpos=[0.0,0.0,0.0]
    
    i.each_with_index{|a,j|
        #  lx,ly,lz=lattice[j]
        3.times{|k|
            rpos[k] += a*lattice[j]
            # rpos[0] += a*lx  #原子x格子
            # rpos[1] += a*ly
            # rpos[2] += a*lz
        }
    }
    real_pos <<  rpos 
}
p real_pos
=end
