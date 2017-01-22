# -*- coding: utf-8 -*-
require 'cairo'
require 'scanf'

class BoundaryModel
  include Math
  attr_accessor :pos, :lat_vec, :log

  def initialize(file)
    @line_width = 1

    lines = File.readlines(file)
    @options={:odd=>true,:rotate=>:zero}
    read_pos(lines)
    @log = ["Source:#{file}"]
  end

  def read_pos(lines, i_l=8)
    @lat_vec, atom, poscar = [],[],[]
    lines[2..4].each{|line|
      @lat_vec << line.scanf("%f %f %f\n")
    }
    lines[i_l..lines.length+1].each{|line|
      atom << line.scanf("%f %f %f\n")
    }
    atom.each{|i_atom|
      poscar << pos_times_lattice(i_atom, @lat_vec)
    }
    @pos = poscar
    return @pos
  end
  def expand(n_ex)
    @lat_vec.each {|vec|
      3.times{|i| vec[i] *= n_ex[i] }
    }
    new_pos=[]
    @n0,@n1,@n2=n_ex[0],n_ex[1],n_ex[2]

    @n0.times{|i|
      @n1.times{|j|
        @n2.times{|k|
          @pos.each do |p0|
            pos = []
            pos << (p0[0]+1.0*i)/@lat_vec[0][0]
            pos << (p0[1]+1.0*j)/@lat_vec[1][1]
            pos << (p0[2]+1.0*k)/@lat_vec[2][2]
            new_pos << pos
          end
        }
      }
    }
    @pos = new_pos
    @log << "Expand:#{@n0},#{@n1},#{@n2}"
    return @pos
  end

  def rotating(theta)
    scale = @lat_vec[0][0]
    @lat_vec[0..1].map!{|lat_vec|
      lat_vec.map!{|i| i/scale}}

    mk_rotated_lat_vec(theta)
    shaping(1.0,1.0)
    atom_rotation()

    ratio = theta==0 ? 0.0 : 1.0/Math.tan(theta)
    degree = theta/2.0/Math::PI*360.0
    @log << sprintf("Rotate:1/%-d,%4.2f[degrees]",
                    ratio,2*degree)
    return @pos
  end

  def mk_rotated_lat_vec(theta)
    rot=[[cos(theta),-sin(theta),0.0],
         [sin(theta),cos(theta),0.0],
         [0.0,0.0,1.0]]
    @lat_vec.map!{|lat_vec|
      vector_times_matrix(lat_vec, rot)
    }
  end
  def vector_times_matrix(vec, matrix)
    vec0 = [0.0, 0.0, 0.0]
    3.times{|j|
      3.times{|k|
        vec0[j]+=matrix[j][k]*vec[k]
      }
    }
    return vec0
  end

  def pos_times_lattice(vec, matrix, n=3)
    vec0 = [0.0, 0.0, 0.0]
    n.times{|j|
      n.times{|k|
        vec0[k]+=vec[j]*matrix[j][k];
      }
    }
    return vec0
  end

  def shaping(s_x,s_y=1.0)
    @pos.each{|pos|
      r_pos = pos_times_lattice(pos, @lat_vec)
      pos[0] += s_x if r_pos[0] < 0
      pos[1] -= s_y if r_pos[1] > s_y
    }
    @log << "Shaped"
  end

  def shaping2(s_y)
    @pos.each{|pos|
      pos[1] -= s_y if pos[1] > s_y
    }
    @log << "Shaped2"
  end
  def atom_rotation
    @pos.map!{|pos| pos_times_lattice(pos, @lat_vec) }
  end

  def mirroring
    add = []
    @pos.each{|pos|
      add << [-pos[0],pos[1],pos[2]]
    }
    @pos += add
    @log << "Mirrorred"
    return @pos
  end

  TINY=0.000000000001
  def distance(pos_i,pos_j)
    dist=0.0
    3.times{|i|
      tmp = pos_i[i]-pos_j[i]
      dist += tmp*tmp
    }
    return Math.sqrt(dist)
  end

  def cutting(c_x,c_y)
    all_pos=[]
    @pos.each{|pos|
      all_pos << pos if ((pos[0]<c_x+TINY && pos[0]>=-c_x-TINY) &&
      (pos[1]<c_y+TINY and pos[1]>=0-TINY ))
    }
    @pos = all_pos
    @log << sprintf("Cut:%7.5f-%7.5f",c_x,c_y)
    return @pos
  end

  def pos_unique_check(c_x,c_y)
    pos_string=[]
    @pos.each{|v|
      pos_string << sprintf("%15.10f %15.10f %15.10f T T T\n",
             (v[0]/c_x+1.0)/2.0,v[1]/c_y,v[2]/@n2)
    }
    pos_string.uniq!
    return pos_string
  end

  def print_to_poscar(c_x,c_y)
    uniq_p=pos_unique_check(c_x,c_y)

    printf("(Al) %s\n   1.00000000000000\n",
           @log.join(";"))
    a0=4.0414
    printf("%15.10f %15.10f %15.10f\n",2*c_x*a0*@n0,0,0)
    printf("%15.10f %15.10f %15.10f\n",0,c_y*a0*@n1,0)
    printf("%15.10f %15.10f %15.10f\n",0,0,@n2*a0)
    printf("%4d\n",uniq_p.size)
    print("Selective dynamics\nDirect\n")
    uniq_p.each{|v| print(v) }
  end
end

class Viewer
  def initialize(pos)
    @pos = pos
    @width,@height = 300,200
    set_center
    @surface = Cairo::SVGSurface.new('view.svg', @width, @height)
    @context = Cairo::Context.new(@surface)
    @context.set_line_width(1)
  end

  def draw
    draw_backcolor
    draw_center
    draw_axes
    draw_atoms
    draw_cell([[1,0],[1,1],[0,1],[0,0]])
  end

  def finish
    @surface.finish
  end
  def draw_backcolor
    @context.set_source_rgb(0.8, 0.8, 0.8)
    @context.rectangle(0, 0, @width, @height)
    @context.fill
  end
  def draw_cell(rect,color=[1,1,1])
    @context.set_source_rgb(*color)
    ini=[0,0]
    rect.each{|fin|
      @context.move_to(*calc_xy(*ini))
      @context.line_to(*calc_xy(*fin))
      @context.stroke
      ini = fin
    }
  end

  def set_center
    @cx,@cy = @width/2.0,@height*2/3
    @align = 10
    @scale = 100 # draw axes
    @adjust = @scale
  end
  def draw_center
    @context.set_source_rgb(0,0,0)
    @context.circle(*calc_xy(0,0),2)
    @context.fill
  end
  def calc_xy(x,y,z=0)
    return @align+@cx+@scale*x,@align+@cy-@scale*y
  end

  def draw_axes
    @context.set_source_rgb(0,0,0)
    [[[-1,0],[1,0]],[[0,-0.2],[0,1]]].each{|line|
      @context.move_to(*calc_xy(*line[0]))
      @context.line_to(*calc_xy(*line[1]))
      @context.stroke
    }
  end
  def draw_atoms
    @context.set_source_rgb(1,0,0)
    @pos.each{|pos|
      if pos[2]<0.1
        @context.circle(*calc_xy(*pos),2)
        @context.fill
      else
        @context.circle(*calc_xy(*pos),2*1.5)
        @context.stroke
      end
    }
  end

end


file = ARGV[0] || 'POSCAR'
model = BoundaryModel.new(file)

#初期値
e_num,a_num,x_num,y_num,z_num = 2,3,3,2,1
e_num,a_num,x_num,y_num,z_num = 3,5,5,4,1
e_num,a_num,x_num,y_num,z_num = 4,7,7,6,1
e_num,a_num,x_num,y_num,z_num = 5,9,9,8,1
e_num,a_num,x_num,y_num,z_num = 4,3,7,4,1

#model化部
position = model.expand([e_num,e_num,z_num])
theta = Math.atan(1.0/a_num)
position = model.rotating(theta)
c_x=Math.cos(theta)*x_num/e_num/2
c_y=Math.sin(theta)+Math.cos(theta)*y_num/(e_num*2)
position = model.mirroring
model.shaping2(c_y)
position = model.cutting(c_x,c_y)

#表示部
view=Viewer.new(position)
view.draw
rot_vec = model.lat_vec
unit_cell =[[1,0],[1,1],[0,1],[0,0]]
unit_cell.map!{|ele|
  model.pos_times_lattice(ele, rot_vec, 2)
}
view.draw_cell(unit_cell,[0.7,0.7,0.7])
view.draw_cell([[c_x,0],[c_x,c_y],[-c_x,c_y],[-c_x,0],[0,0]],[0.2,0.2,0.7])
view.finish
system("open -a safari view.svg")

#POSCARへの出力
model.print_to_poscar(c_x,c_y)

