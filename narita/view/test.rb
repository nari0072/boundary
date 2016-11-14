# -*- coding: utf-8 -*-
require 'cairo'
require 'scanf'

lines = File.readlines(ARGV[0])
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
atom.each{|i|
 rpos=[0.0,0.0,0.0]
  i.each_with_index{|a,j|
  lx,ly,lz=lattice[j]
   rpos[0] += a*lx  #原子座標 x 格子座標
   rpos[1] += a*ly
   rpos[2] += a*lz
  }
  real_pos <<  rpos 
 }
# p real_pos

=begin
 real_pos=[]
 atom.each{|i|
 rpos=[0.0,0.0,0.0]
 i.each_with_index{|a,j|
 3.times{|k|
 rpos[k] += a*lattice[j]
  }
 }
 real_pos <<  rpos
}
 p real_pos
=end

width,height = 300,200
cx,cy = width/2.0,height/2.0
r = 2
adjust = 0.001
scale = 10000

surface = Cairo::SVGSurface.new('hg2.svg', width, height)
context = Cairo::Context.new(surface)

#backcolor
context.set_source_rgb(0.9, 0.9, 0.9)
context.rectangle(0, 0, width, height)
context.fill

#coordinate
context.set_source_rgb(0, 0, 0)
[[0,1.0],[1.0,0]].each{|line|
    x,y=line[0],line[1]
    context.move_to(cx,cy)
    context.line_to(cx+x*scale,cy+y*scale)
    context.stroke
}

#atomic
real_pos.each{|pos|
    
#   atomic_x = cx+adjust*scale*pos[0]
   atomic_y = cy+adjust*scale*pos[1]
   atomic_z = cx+adjust*scale*pos[2]
  p atomic_y, atomic_x
#  d = (atomic_x - atomic_x)
   context.circle(atomic_y,atomic_z, r)
#  if(d < r){
#      context.set_source_rgb(0, 0, 1)
#      context.fill
#  }
#  else {
      context.set_source_rgb(1, 0, 0)
      context.fill
#  }
}

context.show_page
surface.finish
