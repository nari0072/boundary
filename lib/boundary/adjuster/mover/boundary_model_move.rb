# -*- coding: utf-8 -*-
class BoundaryMove < Poscar
  attr_accessor :adjust_list, :pos_size
  def initialize(poscar_name, format=:show_force)
    super(poscar_name)
    mk_adjust_list
  end

  def mk_adjust_list
    @adjust_list=[]
    @relax.each_with_index{|ele,i|
      3.times{|j|
        if ele[j]==1 then
          @adjust_list << [i,j]
        end
      }
    }
  end

  def delete(atoms)
    p atoms
    sorted_atoms=atoms.sort{|a,b| b <=> a}

    sorted_atoms.each{|i_atom|
      i=i_atom.to_i
      p ["in BoudnaryMove::delete ",i]
      if i>@pos_size-1 then
        p "atom number exceeds @pos_size"
        next
      end
      @pos.delete_at(i)
#    @element.delete(i_atom)
      @relax.delete_at(i)
      p @pos_size=@pos.size
    }
  end

  def inner_deviation(x)
    @adjust_list.each_with_index{|ele,ii|
      i_atom,xi=ele[0],ele[1]
      dev0=x[ii]+@pos[i_atom][xi]
      dev1= dev0%1.0
      @pos[i_atom][xi]=dev1
    }
  end

# x<>0.5でblockで動かす.
# * |---x-|d|-x---|dでblockが対称に動くようにしている．
  def block_deviation(da,db,dc) 
    a0=@lat_vec[0][0]
    ratio=a0/da
    @pos.each{|pos|
      x=pos[0]
      dev0 = ((x<0.5) ? x*ratio : x*ratio+0.5-ratio*0.5)%1.0
      pos[0] = dev0
      y=pos[1]
      dev0 = ((x<0.5) ? y : y+db)%1.0
      pos[1] = dev0
      z=pos[2]
      dev0 = ((x<0.5) ? z : z+dc)%1.0
      pos[2] = dev0
    }
    @lat_vec[0][0] = da
  end

# lat_vecを単純に伸縮．
  def outer_deviation(da,db,dc) 
    a0=@lat_vec[0][0]
    b0=@lat_vec[1][1]
    c0=@lat_vec[2][2]
    @lat_vec[0][0] = a0*(1.0+da)
    @lat_vec[1][1] = b0*(1.0+db)
    @lat_vec[2][2] = c0*(1.0+dc)
  end

  def new_poscar(title) # write new poscar
    file=File.open(title,'w')
    text=""
    text << sprintf("%s\n",@head)
    text << sprintf("%15.10f\n",@whole_scale)
    @lat_vec.each {|vec| text << sprintf("%15.10f %15.10f %15.10f\n",vec[0],vec[1],vec[2])}
    text << sprintf("%d\n",@pos_size)
    text << sprintf("Selective dynamics\n")
    text << sprintf("Direct\n")
    @pos_size.times{|i_atom| 
      3.times {|i| text << sprintf("%10.6f",@pos[i_atom][i]) }
      3.times {|i|
        t_or_f = @relax[i_atom][i]? 'T' : 'F'
        text << sprintf("%2s",t_or_f)
      }
      text << sprintf("\n") # write in relative coordination
    }
    file.print text
    file.close
    return 
  end
end


