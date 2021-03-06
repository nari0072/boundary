# -*- coding: utf-8 -*-
require 'cairo'
require 'scanf'

class ViewCompare
  def initialize(file1,file2, model_scale = 10)
    @line_width = 1
    p file1, file2
    lines1 = File.readlines(file1)
    lines2 = File.readlines(file2)
    @pos_before = read_pos(lines1,8)
    @pos_after = read_pos(lines2,8)
    @deleted_atoms = mk_deleted_atom

    p @pos_max=[@lattice[0][0],@lattice[1][1],@lattice[2][2]]
    p @pos_max[0].ceil*10
    @width,@height = 300,200
    @cx,@cy = @width/2.0,@height/2.0
    @align = 10
    @scale = 1000 # draw axes
    @adjust = @scale/(@pos_max[0].ceil*model_scale)
    @surface = Cairo::SVGSurface.new('view.svg', @width, @height)
    @context = Cairo::Context.new(@surface)
    @context.set_line_width(@line_width)

  end

  def three_view
    draw_backcolor
    draw_axes
    draw_atoms
    @surface.finish
  end

  def read_pos(lines, init_line=8)
    @lattice, atom, poscar = [],[],[]
    lines[2..4].each{|line| @lattice << line.scanf("%f %f %f\n")  }
    lines[init_line..lines.length+1].each{|line| atom << line.scanf("%f %f %f\n") }

    atom.each{|i_atom|
      pos=[0.0,0.0,0.0,0.0]
      i_atom.each_with_index{|atom_j,j|
        lx,ly,lz=@lattice[j]
        pos[0] += atom_j*lx
        pos[1] += atom_j*ly
        pos[2] += atom_j*lz
      }
      poscar << pos
    }
    return poscar
  end

  def identical_atom(i_atom,j_atom)
    dist=0.0
    3.times{|i| dist += (i_atom[i]-j_atom[i])**2  }
    #  return true if Math.sqrt(dist)<0.1
    return true if Math.sqrt(dist)<0.4
    return false
  end

  def mk_deleted_atom
    mark=[]
    j_max = @pos_after.length
    @pos_before.each_with_index{|i_atom,i|
      update_num=0
      @pos_after.each_with_index{|j_atom,j|
        break if identical_atom(i_atom,j_atom)
        update_num = j
      }
      mark << @pos_before[i] if update_num==(j_max-1)
    }
    p mark
    return mark
  end

  def draw_backcolor
    @context.set_source_rgb(0.8, 0.8, 0.8)
    @context.rectangle(0, 0, @width, @height)
    @context.fill
  end

  def top_view
    draw_backcolor
    draw_top_view_axes
    draw_top_view
    @surface.finish
  end

  def draw_top_view_axes
    @context.set_source_rgb(0, 0, 0)
    [[0.5,0]].each{|line|
      x,y=line[0],line[1]
      p x,y
      [[0,0]].each{|c_x,c_y|
        @context.move_to(@align+c_x,pos_y([0,0,0],c_y,1,1))
        @context.line_to(@align+c_x+x*@scale,pos_y([0,0,0],c_y,1,1))
#        @context.line_to(@align+c_x+x*@scale,@align+c_y+y*@scale)
        @context.stroke
      }
    }
  end

  def draw_axes
    @context.set_source_rgb(0, 0, 0)
    [[0,1],[1,0]].each{|line|
      x,y=line[0],line[1]
      [[0,0],[@cx,0],[0,@cy]].each{|c_x,c_y|
        @context.move_to(@align+c_x,@align+c_y)
        @context.line_to(@align+c_x+x*@scale,@align+c_y+y*@scale)
        @context.stroke
      }
    }
  end

  def draw_top_view
    draw_each_plane(0,1,0,  0  )   #xy_plane pos[0],pos[1], 0,   0
  end

  def draw_atoms
    draw_each_plane(0,1,0,  0  )   #xy_plane pos[0],pos[1], 0,   0
    draw_each_plane(0,2,0,  @cy)   #xz_plane pos[0],pos[2], 0,   @cy
    draw_each_plane(1,2,@cx,@cy)   #yz_plane pos[1],pos[2], @cx, @cy
  end

  def pos_y(pos, c_y, index, select)
    dy = @pos_max[index]-pos[index]
    return @align+c_y+@adjust*dy
  end

  def draw_each_plane(ind_1,ind_2,c_x,c_y)
    rr = 2
    sel = (ind_1==0 and ind_2==1)? 1 : 0

    [[@deleted_atoms,[1,0,0],rr*1.2],[@pos_after,[0,0,1],rr]].each{|atoms_color|
      @context.set_source_rgb(atoms_color[1])
      radius = atoms_color[2]
      atoms_color[0].each{|pos|
        if (pos[2]<0.5) then
          @context.circle(@align+c_x+@adjust*pos[ind_1],pos_y(pos,c_y,ind_2,sel), radius*1.5)
          @context.stroke
        else
          @context.circle(@align+c_x+@adjust*pos[ind_1],pos_y(pos,c_y,ind_2,sel), radius)
          @context.fill
        end
      }
    }

    if @pos_before.size==@pos_after.size
      @context.set_source_rgb(1, 0.8, 0)
      (0..@pos_before.length-1).each{|i|
        @context.move_to(@align+c_x+@adjust*@pos_before[i][ind_1],pos_y(@pos_before[i],c_y,ind_2,sel))
        @context.line_to(@align+c_x+@adjust*@pos_after[i][ind_1],pos_y(@pos_after[i],c_y,ind_2,sel))
        @context.stroke
      }
    end
  end

end

if __FILE__ == $0 then
  ARGV[1]=ARGV[0] if ARGV[1]==nil
  model_scale = 1.0/0.12
  ViewCompare.new(ARGV[0],ARGV[1], model_scale)
end
