# -*- coding: utf-8 -*-
require 'cairo'
require 'scanf'

def read_pos(lines, init_line)
  lattice1 = []
  lines[2..4].each{|line|
    lattice1 << line.scanf("%f %f %f\n")
  }

  atom1 = []
  a_max=lines.length+1
  lines[init_line..a_max].each{|line|
    atom1 << line.scanf("%f %f %f\n")
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
  return pos_2223
end

def identical_atom(i_atom,j_atom)
  dist=0.0
  3.times{|i|
    dd = i_atom[i]-j_atom[i]
    dist += dd*dd
  }
  return true if Math.sqrt(dist)<0.0001
  return false
end

lines1 = File.readlines(ARGV[0])
lines2 = File.readlines(ARGV[1])

pos_2223 = read_pos(lines1,7)
pos_2223_4 = read_pos(lines2,8)

 i_max = pos_2223.length
 j_max = pos_2223_4.length

mark_atom=[]
pos_2223[0..i_max].each_with_index{|i_atom,i|
  jj=0
  pos_2223_4[0..j_max].each_with_index{|j_atom,j|
    #print "#{i}-#{j}\n"
    break if identical_atom(i_atom,j_atom)
     jj = j
  }
  mark_atom << pos_2223[i] if jj==(j_max-1)
}
# p mark_atom

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
pos_2223.each{|pos|
context.circle(cx+adjust*scale*pos[0],cy+adjust*scale*pos[1], r)
context.set_source_rgb(1, 0, 0)
context.fill
    mark_atom.each{|d|
        # if mark_atom == pos then
        context.circle(cx+adjust*scale*d[0],cy+adjust*scale*d[1], r*1.5)
        context.set_source_rgb(0, 0, 1)
        context.fill
        #end
    }
}

context.show_page
surface.finish
