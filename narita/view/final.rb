# -*- coding: utf-8 -*-
require 'cairo'
require 'scanf'

def read_pos(lines, init_line)
  lattice = []
  lines[2..4].each{|line|
    lattice << line.scanf("%f %f %f\n")
  }

  atom = []
  a_max=lines.length+1
  lines[init_line..a_max].each{|line|
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
  return poscar
end

def identical_atom(i_atom,j_atom)
  dist=0.0
  3.times{|i|
    dd = i_atom[i]-j_atom[i]
    dist += dd*dd
  }
  return true if Math.sqrt(dist)<1
  return false
end

def erasure_atom(lines1,lines2)
  pos_2223 = read_pos(lines1,8)
  pos_2223_4 = read_pos(lines2,8)

  mark=[]
  i_max = pos_2223.length
  j_max = pos_2223_4.length
  pos_2223[0..i_max].each_with_index{|i_atom,i|
    update_num=0
    pos_2223_4[0..j_max].each_with_index{|j_atom,j|
      #print "#{i}-#{j}\n"
      break if identical_atom(i_atom,j_atom)
      update_num = j 
    }
    mark << pos_2223[i] if update_num==(j_max-1) 
  }
  return mark
end

def main_draw(lines1,lines2,opts)
  width,height = 300,200
  cx,cy = width/2.0,height/2.0
  mv = 10
  scale = 1000
  surface = Cairo::SVGSurface.new('view.svg', width, height)
  context = Cairo::Context.new(surface)

  draw_backcolor(context,width,height)
  draw_axes(context,cx,cy,mv,scale)
  draw_atoms(context,width,height,cx,cy,mv,scale,lines1,lines2,opts)
  surface.finish
end

def draw_backcolor(context,width,height)
  context.set_source_rgb(0.8, 0.8, 0.8)
  context.rectangle(0, 0, width, height)
  context.fill
end

def draw_axes(context,cx,cy,mv,scale)
  context.set_source_rgb(0, 0, 0)
  [[0,1.0],[1.0,0]].each{|line|
    x,y=line[0],line[1]
    context.move_to(mv,mv)
    context.line_to(mv+x*scale,mv+y*scale)
    context.stroke
    
    context.move_to(mv+cx,mv)
    context.line_to(mv+cx+x*scale,mv+y*scale)
    context.stroke
    
    context.move_to(mv,mv+cy)
    context.line_to(mv+x*scale,mv+cy+y*scale)
    context.stroke
  }
end

def draw_atoms(context,width,height,cx,cy,mv,scale,lines1,lines2,opts={})
  r = 2
  adjust = scale/100
  pos_before = read_pos(lines1,8)
  pos_after = read_pos(lines2,8)
  vector_max = pos_before.length-1
  
  #xy_atom
  pos_after.each{|pos|
    context.circle(mv+adjust*pos[0],mv+adjust*pos[1], r)
    context.set_source_rgb(0, 0, 1)
    context.fill
    erasure_atom(lines1,lines2).each{|d|
      context.circle(mv+adjust*d[0],mv+adjust*d[1], r)
      context.set_source_rgb(1, 0, 0)
      context.fill
    }
  }
  if opts[:same_size]
    (0..vector_max).each{|vector|
      context.set_source_rgb(1, 0.8, 0)
      context.move_to(mv+adjust*pos_before[vector][0],mv+adjust*pos_before[vector][1])
      context.line_to(mv+adjust*pos_after[vector][0],mv+adjust*pos_after[vector][1])
      context.set_line_width(2)
      context.stroke
    }
  end
  
  #xz_atom
  pos_after.each{|pos|
    context.circle(mv+adjust*pos[0],mv+cy+adjust*pos[2], r)
    context.set_source_rgb(0, 0, 1)
    context.fill
    erasure_atom(lines1,lines2).each{|d|
      context.circle(mv+adjust*d[0],mv+cy+adjust*d[2], r)
      context.set_source_rgb(1, 0, 0)
      context.fill
    }
  }
  if opts[:same_size]
    (0..vector_max).each{|vector|
      context.set_source_rgb(1, 0.8, 0)
      context.move_to(mv+adjust*pos_before[vector][0],mv+cy+adjust*pos_before[vector][2])
      context.line_to(mv+adjust*pos_after[vector][0],mv+cy+adjust*pos_after[vector][2])
      context.set_line_width(2)
      context.stroke
    }
  end
  
  #yz_atom
  pos_after.each{|pos|
    context.circle(mv+cx+adjust*pos[1],mv+cy+adjust*pos[2], r)
    context.set_source_rgb(0, 0, 1)
    context.fill
    erasure_atom(lines1,lines2).each{|d|
      context.circle(mv+cx+adjust*d[1],mv+cy+adjust*d[2], r)
      context.set_source_rgb(1, 0, 0)
      context.fill
    }
  }
  if opts[:same_size]
    (0..vector_max).each{|vector|
      context.set_source_rgb(1, 0.8, 0)
      context.move_to(mv+cx+adjust*pos_before[vector][1],mv+cy+adjust*pos_before[vector][2])
      context.line_to(mv+cx+adjust*pos_after[vector][1],mv+cy+adjust*pos_after[vector][2])
      context.set_line_width(2)
      context.stroke
    }
  end
end

lines1 = File.readlines(ARGV[0])
lines2 = File.readlines(ARGV[1])
opts={}
if lines1.size==lines2.size
  opts[:same_size]=true
else
  opts[:same_size]=false
end
main_draw(lines1,lines2,opts)
