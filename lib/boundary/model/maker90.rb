include Math
require_relative '../../pseudoVASP/poscar/poscar'
require_relative '../../pseudoVASP/pseudoVASP/pseudoVASP.rb'

#粒界構造のPOSCARを作成する
#:n_ex :: 拡張するサイズ
#theta:: 角度
TINY = 1.0e-2

class BoundaryModelMaker < Poscar
  attr_reader :options

  def initialize(file_name, nx, ny, nz, rot_num, opts={})
    p @options = {output: :normal,rotate: :non_zero}.merge(opts)
                 
    @options[:rotate]=:zero if rot_num == 0
    p super(file_name)
    if rot_num == 0 then
      theta = 0.0 
    else
      p rot=1.0/(rot_num.to_f/2.0*@lat_vec[1][1]/@lat_vec[0][0])
      theta = atan(rot)
    end
    print ("Expanding vector and angle:")
    n_ex = [nx,ny,nz]
    p ["n_ex=",n_ex]
    p ["theta=",theta]
    p "# 初期の参照構造の表示"
    print display() 
    ninety_degree_expanding(n_ex)

    rotating(theta)    # 回転
    translating() # x<0の原子を反対側に付ける
    mirroring()   # 鏡映操作
  end

  def display
    case @options[:output]
      when :unit then poscar_format(1.0) #unit POSCAR
      when :normal then poscar_format #real POSCAR for Al 2times 
    end
  end

  def ninety_degree_expanding(n_ex)
    @lat_vec.each {|vec| 
      3.times{|i| vec[i] *= n_ex[i] }
    }
    @pos,old_pos=[],@pos
    n0,n1,n2=n_ex[0]+2,n_ex[1]+2,n_ex[2]
    n0.times{|i|
      n1.times{|j|
        n2.times{|k|
          old_pos.each do |p0|
            pos = []
            pos << (p0[0]+1.0*i)/n0
            pos << (p0[1]+1.0*j)/n1
            pos << (p0[2]+1.0*k)/n2
            @pos << pos
          end
        }
      }
    }
    @pos_size=@pos.size
  end

  def rotating(theta)
    rot=[[cos(theta),-sin(theta),0.0],
         [sin(theta),cos(theta),0.0],
         [0.0,0.0,1.0]]
    p @lat_vec
    3.times{|i|
      tmp=[0.0,0.0,0.0]
      3.times{|j|
        3.times{|k|
          tmp[j]+=rot[j][k]*@lat_vec[i][k]
        }
      }
      p tmp
      @lat_vec[i] = tmp
    }
  end

  def translating
    @pos.each{|pos|
      r_pos = [0.0, 0.0, 0.0]
      3.times{|j|
        3.times{|k|
          r_pos[k]+=pos[j]*@lat_vec[j][k];
        }
      }
      pos[0] += 1.0 if r_pos[0] < -0.00001
    }
    @pos_size = @pos.size
  end

  def mirroring
    pos1=[]
    lat_vec2=[]
    3.times{|j|
      lat_vec2[j] = [-@lat_vec[j][0],@lat_vec[j][1],@lat_vec[j][2]]
    }

    @pos.each{|pos|
      r_pos = [0.0, 0.0, 0.0]
      r_pos2 = [0.0, 0.0, 0.0]
      3.times{|j|
        3.times{|k|
          r_pos[k]+=pos[j]*@lat_vec[j][k];
          r_pos2[k]+=pos[j]*lat_vec2[j][k];
        }
      }
      pos1 << r_pos
      pos1 << r_pos2
    }
    pos1.uniq!
#      @lat_vec[1][1] -= 0.5*@lat_vec[1][1]
#      @lat_vec[0][0] -= 0.5*@lat_vec[0][0]
      p a=@lat_vec[1][0]+@lat_vec[0][0]
#      p b=@lat_vec[1][1]+@lat_vec[0][1]-0.5
      p b=@lat_vec[1][1]+@lat_vec[0][1]
    @lat_vec[0]=[a,0.0,0.0]
    @lat_vec[1]=[0.0,b,0.0]
    p @lat_vec
    p @pos.size
    @pos=[]
    pos1.each{|pos|
#        if (pos[0]>=-a-TINY && pos[0]<=a) &&
#            (pos[1]>=0-TINY && pos[1]<=b) then
          @pos << [pos[0]/@lat_vec[0][0],pos[1]/@lat_vec[1][1],pos[2]/@lat_vec[2][2]]
#        end
    }
 p   @pos_size = @pos.size
  end

  def shaping()
    y_cut2 = 3.90 #3.6014702879926976  #5.48795472536200
    x_cut = 3.498571136907192 
    y_cut = x_cut
    pos1=[]
    x_max=y_max=0.0
    @pos.each_with_index{|pos0,i_atom|
      pos=[pos0[0]*@lat_vec[0][0],pos0[1]*@lat_vec[1][1],pos0[2]*@lat_vec[2][2]]
      if (pos[0]>=-x_cut-TINY && pos[0]<x_cut) &&
          (pos[1]>=0-TINY && pos[1]<y_cut) then
        pos1 << pos
        x_max = pos[0] if x_max< pos[0]
        y_max = pos[1] if y_max< pos[1]
      end
      if (pos[0]<=-1.5 || pos[0]>=1.5) &&
          (pos[1]>=y_cut && pos[1]<=y_cut2) then
        p pos
        pos[1]-= 3.498571136907192 #0.3777777777777777
        pos1 << pos
      end
    }
    @pos =[]
    pos1.each{|pos|
      pos[0] = pos[0]/3.498571136907192 
      pos[1] = pos[1]/3.498571136907192 
      pos[2] = pos[2]/2.0
      @pos << pos
    }
    @lat_vec[0][0]=3.498571136907192 
    @lat_vec[1][1]=3.498571136907192 
    @pos_size = @pos.size
    p [@pos_size,x_max,y_max]
  end
    
  def previewer_format(a0=8.0827999115/2.0) #real POSCAR for Al lattice parameter(a0=4.04...)
    text=""
    text << sprintf("%s\n",@head)
    text << sprintf("%f\n",@whole_scale)
    p "BOB"
    p @lat_vec
    p "BOB"
    @lat_vec.each {|vec| 
#      text << sprintf("%15.10f %15.10f %15.10f\n",a0*2.0*vec[0],a0*vec[1],a0*vec[2]) 
      text << sprintf("%15.10f %15.10f %15.10f\n",a0*vec[0],a0*vec[1],a0*vec[2]) 
# vec[0] is set to be 2.0 times for the viewer.
    }
    text << sprintf("%d\n",@pos_size)
    text << sprintf("Direct\n")
#    @pos.each{|pos| text << sprintf("%15.10f %15.10f %15.10f T T T \n",(1.0+pos[0])/2.0,pos[1],pos[2])}
    @pos.each{|pos| text << sprintf("%15.10f %15.10f %15.10f T T T \n",pos[0],pos[1],pos[2])}
# same reason of vec[0] to be 2.0 times for the viewer.
    return text
  end

  def poscar_format(a0=8.0827999115/2.0) #real POSCAR for Al lattice parameter(a0=4.04...)
    text=""
    text << sprintf("%s\n",@head)
    text << sprintf("%f\n",@whole_scale)
    @lat_vec.each {|vec| 
      text << sprintf("%15.10f %15.10f %15.10f\n",a0*2.0*vec[0],a0*vec[1],a0*vec[2]) 
#      text << sprintf("%15.10f %15.10f %15.10f\n",a0*vec[0],a0*vec[1],a0*vec[2]) 
# vec[0] is set to be 2.0 times for the viewer.
    }
    text << sprintf("%d\n",@pos_size)
    text << sprintf("Direct\n")
    @pos.each{|pos| text << sprintf("%15.10f %15.10f %15.10f T T T \n",(1.0+pos[0])/2.0,pos[1],pos[2])}
#    @pos.each{|pos| text << sprintf("%15.10f %15.10f %15.10f T T T \n",pos[0],pos[1],pos[2])}
# same reason of vec[0] to be 2.0 times for the viewer.
    return text
  end

end

if __FILE__ == $0 then
  if ARGV[0]==nil then
    print "Usage: ruby maker90.rb 2 2 2 3\n"  
    exit
  end
  
  boundary=BoundaryModelMaker.new('POSCAR_90',ARGV[0].to_i,ARGV[1].to_i,ARGV[2].to_i,ARGV[3],model: :ninety)
  p file_name='POSCAR_90_'+ARGV[0]+ARGV[1]+ARGV[2]+ARGV[3]
  file=File.open(file_name,'w')
  boundary.shaping
#  file.print boundary.previewer_format
  file.print boundary.poscar_format
  file.close
  system "cp #{file_name} ../viewer/POSCARs/#{file_name}"
  system "cp #{file_name} ../adjuster/"
end


