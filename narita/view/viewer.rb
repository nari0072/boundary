# -*- coding: utf-8 -*-
require 'cairo'
require 'pseudoVASP'//Users/nari/boundary/narita/view/viewer.rb
class BoundaryView < Poscar
  attr_reader :atom_list, :scale

  def initialize(poscar_name)
    super(poscar_name)
    3.times{|i|
      3.times{|j|
        $lattice[i][j]=@lat_vec[i][j]*@whole_scale
      }
    }
    @atom_list = mk_lattice
  end

  # @pos_size, @pos are attr_reader in Poscar
  def mk_lattice
    atom_list=[]
    @pos_size.times{|i|
      pos1=[0.0,0.0,0.0]
      3.times {|j|
        3.times {|k|
          pos1[k]+=@pos[i][j].to_f*$lattice[j][k]
        }
      }
      atom_list << pos1
    }
    return atom_list
  end

def display(file_name) #原子座標の描画
    p file_name　#画面表示の大きさ
    #format = Cairo::FORMAT_ARGB32
    p    screen_x = 700
    p    screen_y = 500
    cx,cy = screen_x/2.0,screen_y*2.0/3.0

p    radius = 3
    @scale = 100

    surface = Cairo::SVGSurface.new("#{file_name}.svg", screen_x, screen_y)
    #surface = Cairo::ImageSurface.new(format, screen_x, screen_y)
    context = Cairo::Context.new(surface)

    s1=0.1;
    a,b=$lattice[0][0]*s1*scale,b=$lattice[1][1]*s1*scale;
    p cx,cy
    p a,b
    context.set_source_rgb(0.5, 0.5, 0.5)
    context.rectangle(cx-a/2.0,cy,cx-a/2.0, cy-b)
    context.fill

    context.set_source_rgb(0, 0, 0)
    [[0,3],[3,0]].each{|line|
      x,y=line[0],line[1]
      context.move_to(cx,cy)
      context.line_to(cx+x*scale,cy+y*scale)
      context.stroke
    }
    context.set_source_rgb(1, 0, 0)
    @atom_list.each{|pos|
      x,y,z = pos[0],pos[1],pos[2]
      context.arc(cx+x*s1*scale, cy+y*s1*scale, radius, 0, 2 * Math::PI)
      context.fill
    }

    #surface.write_to_png("hinomaru.png")
  end

end
