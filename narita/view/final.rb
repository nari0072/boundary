require 'cairo'
require 'scanf'

def read_pos(lines, init_line=8)
  lattice, atom, poscar = [],[],[]
  lines[2..4].each{|line| lattice << line.scanf("%f %f %f\n")  }

  lines[init_line..lines.length+1].each{|line| atom << line.scanf("%f %f %f\n") }

  atom.each{|i_atom|
    pos=[0.0,0.0,0.0]
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

def identical_atom(i_atom,j_atom)
  dist=0.0
  3.times{|i| dist += (i_atom[i]-j_atom[i])**2  }
  return true if Math.sqrt(dist)<0.5
  return false
end

def mk_deleted_atom
  mark=[]
  j_max = $pos_after.length
  $pos_before.each_with_index{|i_atom,i|
    update_num=0
    $pos_after.each_with_index{|j_atom,j|
      break if identical_atom(i_atom,j_atom)
      update_num = j
    }
    mark << $pos_before[i] if update_num==(j_max-1)
  }
  return mark
end

def draw_backcolor
  $context.set_source_rgb(0.8, 0.8, 0.8)
  $context.rectangle(0, 0, $width, $height)
  $context.fill
end

def draw_axes
  $context.set_source_rgb(0, 0, 0)
  [[0,1],[1,0]].each{|line|
    x,y=line[0],line[1]
    [[0,0],[$cx,0],[0,$cy]].each{|c_x,c_y|
      $context.move_to($mv+c_x,$mv+c_y)
      $context.line_to($mv+c_x+x*$scale,$mv+c_y+y*$scale)
      $context.stroke
    }
  }
end

def draw_atoms
  draw_each_plane(0,1,0,0)
  draw_each_plane(0,2,0,$cy)
  draw_each_plane(1,2,$cx,$cy)
end

def pos_y(pos, c_y, index, select)
  dy = select == 0 ? pos[index] : $pos_max[index]-pos[index]
  return $mv+c_y+$adjust*dy
end

def open_circle
  z_layer=[]
  layer_max, layer_min = $pos_max[2], 0.0
  bound=(layer_max - layer_min )/($denominator-1)
  num,j = layer_min, 0
  $diff = 0.15
  while num <= layer_max do
    z_layer[j] = num
    num += bound
    j += 1
  end
  return z_layer
end

def draw_each_plane(ind_1,ind_2,c_x,c_y)
  rr = 2
  sel = (ind_1==0 and ind_2==1)? 1 : 0
  [[$deleted_atoms,[1,0,0],rr*1.3],[$pos_after,[0,0,1],rr]].each{|atoms_color|
    $context.set_source_rgb(atoms_color[1])
    radius = atoms_color[2]
    atoms_color[0].each{|pos|
      if $numerator == 0 then
        $context.circle($mv+c_x+$adjust*pos[ind_1],pos_y(pos,c_y,ind_2,sel), radius)
        $context.fill
      else
        if pos[2] < open_circle[$numerator-1]+$diff and open_circle[$numerator-1] - $diff < pos[2] then
          $context.circle($mv+c_x+$adjust*pos[ind_1],pos_y(pos,c_y,ind_2,sel), radius*1.7)
          $context.stroke
          $context.set_line_width(0.5)
        else
          $context.circle($mv+c_x+$adjust*pos[ind_1],pos_y(pos,c_y,ind_2,sel), radius)
          $context.fill
        end
      end
    }
  }

  if $pos_before.size==$pos_after.size
    $context.set_source_rgb(0, 0.8, 0)
    (0..$pos_before.length-1).each{|i|
      $context.move_to($mv+c_x+$adjust*$pos_before[i][ind_1],pos_y($pos_before[i],c_y,ind_2,sel))
      $context.line_to($mv+c_x+$adjust*$pos_after[i][ind_1],pos_y($pos_after[i],c_y,ind_2,sel))
      $context.stroke
    }
  end
end

def find_max(pos)
  max = [0,0,0]
  [0,1,2].each{|ind|
    pos.length.times {|i| max[ind] = pos[i][ind] if max[ind] < pos[i][ind] }
  }
  return max
end

def main_draw(file1,file2, layer, model_scale = 10)
  lines1 = File.readlines(file1)
  lines2 = File.readlines(file2)
  if layer != nil then
    tmp=layer.split('/')
    $numerator, $denominator = tmp[0].to_f,tmp[1].to_f
  else
    $numerator = 0
  end
  
  $pos_before, $pos_after = read_pos(lines1,8), read_pos(lines2,8)
  $deleted_atoms = mk_deleted_atom
  
  $pos_max=find_max($pos_before)
  $pos_max[0].ceil*10
  $width,$height = 300,200
  $cx,$cy = $width/2.0,$height/2.0
  $mv = 10
  $scale = 1000
  $adjust = $scale/($pos_max[0].ceil*model_scale)
  surface = Cairo::SVGSurface.new('view.svg', $width, $height)
  $context = Cairo::Context.new(surface)
  $context.set_line_width($line_width)
  draw_backcolor
  draw_axes
  draw_atoms
  surface.finish
end

model_scale = 1.0/0.12
$line_width = 1
main_draw(ARGV[0],ARGV[1], ARGV[2],model_scale)

