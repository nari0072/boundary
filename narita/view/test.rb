# -*- coding: utf-8 -*-
require 'cairo'
require 'scanf'

lines = File.readlines(ARGV[0])
m = 3.0

lattice = []
lines[2..4].each{|line|
  lattice << line.scanf("%f %f %f\n")
}

atom = []
a_max=lines.length+1
lines[7..a_max].each{|line|
  atom << line.scanf("%f %f %f\n")
}

real_pos=[]
atom.each{|pos|
  r_pos=[m,m,m]
  pos.each_with_index{|xx,i|
    lx,ly,lz=lattice[i]
    r_pos[0] += xx*lx 
    r_pos[1] += xx*ly 
    r_pos[2] += xx*lz 
  }
  real_pos <<  r_pos
}
# p real_pos  

width,height = 300,200
cx,cy = width*2.0/3.0,height/2.0
r = 2
adjust = 0.001
scale = 100

surface = Cairo::SVGSurface.new('hg2.svg', width, height)
context = Cairo::Context.new(surface)

#backcolor
context.set_source_rgb(0.9, 0.9, 0.9)
context.rectangle(0, 0, width, height)
context.fill

#atomic
context.set_source_rgb(1, 0, 0)
real_pos.each{|pos|
#  p pos
#  p width*scale*pos[0] , height*scale*pos[1]
  context.circle(cx*adjust*scale*pos[0], cy*adjust*scale*pos[1], r)
  context.fill}

#coordinate
context.set_source_rgb(0, 0, 0)
[[0,1.0],[1.0,0]].each{|line|
      x,y,z=line[0],line[1]
      context.move_to(x+m*10,y+m*10)
      context.line_to(cx*x*scale,cy*y*scale)
      context.stroke
}

context.show_page
surface.finish

#配列latticeで原子配置
=begin
p  screen_x = 700, screen_y = 500, radius = 3
cx,cy = screen_x/2.0,screen_y*2.0/3.0
@scale = 100
s1=0.1;
a,b=$lattice[0][0]*s1*scale,b=$lattice[1][1]*s1*scale;
p  a, b, cx, cy
context.set_source_rgb(0.5, 0.5, 0.5)
context.rectangle(cx-a/2.0,cy,cx-a/2.0, cy-b)
context.fill

context.set_source_rgb(1, 0, 0)
@atom_list.each{|pos|
x,y,z = pos[0],pos[1],pos[2]
context.arc(cx+x*s1*scale, cy+y*s1*scale, radius, 0, 2 * Math::PI)
context.fill
}
=end
