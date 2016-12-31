require 'cairo'
require 'scanf'

def read_pos(lines, init_line=8)
  lattice = []
  lines[2..4].each{|line| lattice << line.scanf("%f %f %f\n")  }

  atom = []
  a_max=lines.length+1
  lines[init_line..a_max].each{|line| atom << line.scanf("%f %f %f\n") }

  poscar=[]
  atom.each{|i_atom|
    pos=[0.0,0.0,0.0,0.0]
    i_atom.each_with_index{|atom_j,j|
      lx,ly,lz=lattice[j]
      pos[0] += atom_j*lx
      pos[1] += atom_j*ly
      pos[2] += atom_j*lz
    }
    poscar << pos
  }
  return poscar
end

def main_draw(lines)
  width,height = 600,400
  cx,cy = width/2.0,height/2.0
  scale = 1000
  adjust = scale/100
  r = 2
  poscar = read_pos(lines,8)

  # setup Cairo
  surface = Cairo::SVGSurface.new('view.svg', width, height)
  context = Cairo::Context.new(surface)

  # back ground?
  context.set_source_rgb(0.8, 0.8, 0.8)
  context.rectangle(0, 0, width, height)
  context.fill

  # axis ?
  context.set_source_rgb(0, 0, 0)
  [[0,1.0],[1.0,0]].each{|line|
    x,y=line[0],line[1]
    context.move_to(cx,cy)
    context.line_to(cx+x*scale,cy-y*scale)
    context.stroke
  }

=begin
  pos_num = poscar.length
  pos_min = [0.0,0.0]
  pos_num.times do |i|
    if poscar[i][0] > poscar[i-1][0] then
      pos_min[0] = cx-adjust*poscar[i][0]
    end
    if poscar[i][1] > poscar[i-1][1] then
      pos_min[1] = cy-adjust*poscar[i][1]
    end
  end
  x_min,y_min=cx-pos_min[0],cy-pos_min[1]
=end
  # xy 
  poscar.each{|pos|
    #p cy-adjust*pos[1]
    context.circle(cx+adjust*pos[0],cy-adjust*pos[1], r)
    context.set_source_rgb(1, 0, 0)
    context.fill
  }
  surface.finish
end

main_draw(File.readlines(ARGV[0]))
