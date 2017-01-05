# -*- coding: utf-8 -*-
require 'cairo'
require 'scanf'

def read_pos(lines, init_line=8)
  $lattice, atom, poscar = [],[],[]
  lines[2..4].each{|line| $lattice << line.scanf("%f %f %f\n")  }
  lines[init_line..lines.length+1].each{|line| atom << line.scanf("%f %f %f\n") }

  atom.each{|i_atom|
    pos=[0.0,0.0,0.0,0.0]
    i_atom.each_with_index{|atom_j,j|
      lx,ly,lz=$lattice[j]
      pos[0] += atom_j*lx
      pos[1] += atom_j*ly
      pos[2] += atom_j*lz
    }
    poscar << pos
  }
  return poscar
end

def draw_backcolor
  $context.set_source_rgb(0.8, 0.8, 0.8)
  $context.rectangle(0, 0, $width, $height)
  $context.fill
end

def draw_box(x0,y0,x1,y1)
  $context.set_source_rgb(0, 0, 0)
  $context.set_line_width(0.2)
  $context.move_to($mv+$adjust*x0,$mv+$adjust*y0)
  $context.line_to($mv+$adjust*x0,$mv+$adjust*y1)
  $context.line_to($mv+$adjust*x1,$mv+$adjust*y1)
  $context.line_to($mv+$adjust*x1,$mv+$adjust*y0)
  $context.line_to($mv+$adjust*x0,$mv+$adjust*y0)
  $context.stroke
end

def draw_atoms
  draw_plane   #xy_plane pos[0],pos[1], 0,   0
end

def draw_plane
  rr = 2
  [0,1,2].each{|xx|
    [0,1,2].each{|yy|
      [[$pos_after,[0,0,1],rr]].each{|atoms_color|
        x0=(xx)*$lattice[0][0]
        x1=(xx+1)*$lattice[0][0]
        y0=(yy)*$lattice[1][1]
        y1=(yy+1)*$lattice[1][1]
        draw_box(x0,y0,x1,y1)
        $context.set_source_rgb(atoms_color[1])
        radius = atoms_color[2]
        atoms_color[0].each{|pos|
          dy = $pos_max[1]-pos[1]+yy*$lattice[1][1]
          $context.circle($mv+$adjust*(pos[0]+xx*$lattice[0][0]),
                          $mv+$adjust*dy, radius)
          $context.fill
        }
      }
    }
  }
end

def main_draw(file1, model_scale = 10)
  lines1 = File.readlines(file1)
  $pos_after = read_pos(lines1,8)

  p $pos_max=[$lattice[0][0],$lattice[1][1],$lattice[2][2]]
  $width,$height = 300,200
  $cx,$cy = $width/2.0,$height/2.0
  $mv = 10
  $scale = 1000 # draw axes
  $adjust = $scale/($pos_max[0].ceil*model_scale)
  surface = Cairo::SVGSurface.new('view.svg', $width, $height)
  $context = Cairo::Context.new(surface)
  $context.set_line_width($line_width)

  draw_backcolor
  draw_atoms
  surface.finish
end

model_scale = 1.0/0.12
$line_width = 1
main_draw(ARGV[0], model_scale)

