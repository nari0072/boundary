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

  #x=[1,2,3,4]
  poscar=[]
  atom.each{|i|
    pos=[0.0,0.0,0.0,1]
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

def cavity_atoms(lines,atoms)
  x=1,mark=[]
  max_number=atoms.length
  max_number.times{|i|
    if atoms[i][2] < atoms[i-1][2] then
      x += 1
      atoms[i][3]=x
    end
  }
  return mark
end

def main_draw(lines)
  width,height = 600,400
  cx,cy = width/2.0,height/2.0
  scale = 1000
  adjust = scale/100
  r = 2
  atoms = read_pos(lines,8)
  surface = Cairo::SVGSurface.new('view.svg', width, height)
  context = Cairo::Context.new(surface)

  context.set_source_rgb(0.8, 0.8, 0.8)
  context.rectangle(0, 0, width, height)
  context.fill

  context.set_source_rgb(0, 0, 0)
  [[0,1.0],[1.0,0]].each{|line|
    x,y=line[0],line[1]
    context.move_to(cx,cy)
    context.line_to(cx+x*scale,cy+y*scale)
    context.stroke
  }

  atoms.each{|pos|
    context.set_source_rgb(1, 0, 0)
    context.circle(cx+adjust*pos[0],cy+adjust*pos[2], r)
    if pos[1]>0.4 then
      context.fill
    else
      context.stroke
    end
  }

surface.finish
end

lines= File.readlines(ARGV[0])
main_draw(lines)
