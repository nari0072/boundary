require 'cairo'
require 'scanf'

lines1 = File.readlines(ARGV[0])
lines2 = File.readlines(ARGV[1])

lattice1 = []
lines1[2..4].each{|line|
    lattice1 << line.scanf("%f %f %f\n")
}
=begin
 (0..2).each{|i|
 (0..2).each{|j|
 p lattice1[i][j].round(6)
 }
 }
 =end

lattice2 = []
lines2[2..4].each{|line|
    lattice2 << line.scanf("%f %f %f\n")
}

atom1 = []
a_max=lines1.length+1
lines1[7..a_max].each{|line|
    atom1 << line.scanf("%f %f %f\n")
}
=begin
 atom=[]
 (0..35).each{|i|
 (0..2).each{|j|
 atom << atom1[i][j].round(6)
 }
 }
 p atom
 =end

atom2 = []
a_max=lines2.length+1
lines2[8..a_max].each{|line|
    atom2 << line.scanf("%f %f %f\n")
}

pos_2223=[]
atom1.each{|i|
    pos1=[0.0,0.0,0.0]
    i.each_with_index{|a,j|
        lx,ly,lz=lattice1[j]
        pos1[0] += a*lx  #原子座標 x 格子座標
        pos1[1] += a*ly
        pos1[2] += a*lz
    }
    pos_2223 << pos1
}
#p pos_2223

pos_2223_4=[]
atom2.each{|i|
    pos2=[0.0,0.0,0.0]
    i.each_with_index{|a,j|
        lx,ly,lz=lattice2[j]
        pos2[0] += a*lx  #原子座標 x 格子座標
        pos2[1] += a*ly
        pos2[2] += a*lz
    }
    pos_2223_4 << pos2
}
# p pos_2223_4

width,height = 300,200
cx,cy = width/2.0,height/2.0
r = 2
adjust = 0.001
scale = 10000

surface = Cairo::SVGSurface.new('hoge.svg', width, height)
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

pos_2223.each{|pos|
context.circle(cx+adjust*scale*pos[0],cy+adjust*scale*pos[1], r)
context.set_source_rgb(1, 0, 0)
context.fill
}
context.show_page
surface.finish