# -*- coding: utf-8 -*-
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
#距離で削除された原子を判定
dist=[],dis_x=[0.0],dis_y=[0.0],dis_z=[0.0]
a_max=atom2.length-1
(0..a_max).each{|i|
     dis_x[i] = pos_2223[i][0] - pos_2223_4[i][0]
     dis_y[i] = pos_2223[i][1] - pos_2223_4[i][1]
     dis_z[i] = pos_2223[i][2] - pos_2223_4[i][2]
     dist[i] =  Math.sqrt((dis_x[i] *dis_x[i]) + (dis_y[i]*dis_y[i]) + (dis_z[i]*dis_z[i]))
}
p dist
(0..a_max).each{|i|
    if dist[i] > 10 then
    context.circle(cx+adjust*scale*pos_2223[i][0],cy+adjust*scale*pos_2223[i][1], r)
    context.set_source_rgb(1, 0, 0)
    context.fill
    
=begin
    else
    context.circle(cx+adjust*scale*pos_2223[i][0],cy+adjust*scale*pos_2223[i][1], r)
    context.set_source_rgb(1, 0, 0)
    context.fill
=end
    end
}

=begin
#各座標の値一致を判定
deli_atom=[]
a_max1=atom1.length-1
a_max2=atom2.length-1
(0..a_max1).each{|i|
    (0..a_max2).each{|j|
        if pos_2223[i][0] != pos_2223_4[j][0] then 
            if pos_2223[i][1] != pos_2223_4[j][1] then
                if pos_2223[i][2] != pos_2223_4[j][2] then
                    deli_atom << pos_2223
                end
            end
        end
    }
}
# p deli_atom
deli_atom.each{|pos|
    context.circle(cx+adjust*scale*pos[0],cy+adjust*scale*pos[1], r)
    context.set_source_rgb(1, 0, 0)
    context.fill
}
=end

context.show_page
surface.finish
