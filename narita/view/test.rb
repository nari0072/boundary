# -*- coding: utf-8 -*-
require 'cairo'
#p filename = ARGV[0]
print File.read(ARGV[0])
exit
#file.close

width,height = 300,200
r = 3

surface = Cairo::SVGSurface.new('hg2.svg', width, height)
context = Cairo::Context.new(surface)

#backcolor
context.set_source_rgb(0.8, 0.8, 0.8)
context.rectangle(0, 0, width, height)
context.fill

#atomics
context.set_source_rgb(1, 0, 0)
 for i in 2..5 do
  for j in 1..3 do
   context.circle( width*1/7*i , height*1/4*j, r)
   context.fill
  end
 end  

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

context.show_page
surface.finish
