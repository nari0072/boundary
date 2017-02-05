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
    return true if Math.sqrt(dist)<0.1
    return false
end

def nine_erasure(lines1,lines3,pos3325,pos3325_9)
    mark=[]
    i_max = pos3325.length
    j_max = pos3325_9.length
    pos3325[0..i_max].each_with_index{|i_atom,i|
        update_num=0
        pos3325_9[0..j_max].each_with_index{|j_atom,j|
            break if identical_atom(i_atom,j_atom)
            update_num = j
        }
        mark << pos3325[i] if update_num==(j_max-1)
    }
    #p mark
    return mark
end

def main_draw(lines1,lines2,lines3)
width,height = 450,300
cx,cy = width/2.0,height/2.0
scale = 1000
mv = 10
surface = Cairo::SVGSurface.new('view.svg', width, height)
context = Cairo::Context.new(surface)

draw_backcolor(context,width,height)
draw_axes(context,cx,cy,mv,scale)
draw_atoms(context,width,height,scale,cx,cy,mv,lines1,lines2,lines3)

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

def draw_atoms(context,width,height,scale,cx,cy,mv,lines1,lines2,lines3)
  adjust = scale/100
  r = 2
  axis1,axis2 = 0,2
  pos3325 = read_pos(lines1,8)
  pos3325_7 = read_pos(lines2,8)
  pos3325_9 = read_pos(lines3,8)
  pos3325.each{|pos|
    context.circle(mv+adjust*pos[axis1],mv+adjust*pos[axis2], r)
    context.set_source_rgb(1, 0, 0)
    context.fill
  }
  pos3325_7.each{|pos|
      context.circle(mv+adjust*pos[axis1],mv+cy+adjust*pos[axis2], r)
      context.set_source_rgb(0, 0, 1)
      context.fill
  }
  pos3325_9.each{|pos|
    context.circle(mv+cx+adjust*pos[axis1],mv+cy+adjust*pos[axis2], r)
    context.set_source_rgb(1, 0, 1)
    context.fill
  }
  nine_erasure(lines1,lines3,pos3325,pos3325_9).each{|pos|
      context.circle(mv+cx+adjust*pos[axis1],mv+adjust*pos[axis2], r)
      context.set_source_rgb(1, 1, 0)
      context.fill
  }

end

lines1= File.readlines(ARGV[0])
lines2= File.readlines(ARGV[1])
lines3= File.readlines(ARGV[2])

main_draw(lines1,lines2,lines3)