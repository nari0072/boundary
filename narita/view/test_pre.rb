require 'cairo'
require 'scanf'

lines= File.readlines(ARGV[0])

lattice = []
lines[2..4].each{|line|
  lattice << line.scanf("%f %f %f\n")
}

atom = []
a_max=lines.length+1
lines[8..a_max].each{|line|
    atom << line.scanf("%f %f %f\n")
}

poscar=[]
atom.each{|i|
    pos=[0.0,0.0,0.0]
    i.each_with_index{|a,j|
        lx,ly,lz=lattice[j]
        pos[0] += a*lx
        pos[1] += a*ly
        pos[2] += a*lz
    }
    poscar << pos
}

width,height = 300,200
cx,cy = width/2.0,height/2.0
scale = 10000
adjust = scale/1000
r = 2
surface = Cairo::SVGSurface.new('hg2.svg', width, height)
context = Cairo::Context.new(surface)

context.set_source_rgb(0.9, 0.9, 0.9)
context.rectangle(0, 0, width, height)
context.fill

context.set_source_rgb(0, 0, 0)
[[0,1.0],[1.0,0]].each{|line|
  x,y=line[0],line[1]
  context.move_to(cx,cy)
  context.line_to(cx+x*scale,cy+y*scale)
  context.stroke
}

poscar.each{|pos|
    context.circle(cx+adjust*pos[0],cy+adjust*pos[1], r)
    context.set_source_rgb(1, 0, 0)
    context.fill
}
surface.finish
