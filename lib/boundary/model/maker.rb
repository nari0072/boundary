# -*- coding: utf-8 -*-
include Math
#require 'pseudoVASP/poscar'
require 'pseudoVASP'

#粒界構造のPOSCARを作成する
#:n_ex :: 拡張するサイズ
#theta:: 角度
TINY = 1.0e-2

class BoundaryModelMaker < Poscar
  attr_reader :options

  def initialize(file_name, nx, ny, nz, rot_num, opts={})
    p @options = {output: :normal,rotate: :non_zero}.merge(opts)
    theta = (rot_num == 0 ) ? 0.0 :  atan(1.0/rot_num.to_f)
    @options[:rotate]=:zero if rot_num == 0
    p super(file_name)
    print ("Expanding vector and angle:")
    n_ex = [nx,ny,nz]
    p ["n_ex=",n_ex]
    p ["theta=",theta]
    p "# 初期の参照構造の表示"
    print display() 
    expanding(n_ex)
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

  def expanding(n_ex,odd_or_even=:zero)
    @lat_vec.each {|vec| 
      3.times{|i| vec[i] *= n_ex[i] }
    }
    @pos,old_pos=[],@pos
    case @options[:rotate]
    when :zero then
      n0,n1,n2=n_ex[0],n_ex[1],n_ex[2]
    when :non_zero then
      n0,n1,n2=n_ex[0]+1,n_ex[1]+1,n_ex[2]
      @lat_vec[1][1]-=0.5
    end
    n0.times{|i|
      n1.times{|j|
        n2.times{|k|
          old_pos.each do |p0|
            pos = []
            pos << (p0[0]+1.0*i)/@lat_vec[0][0]
            pos << (p0[1]+1.0*j)/@lat_vec[1][1]
            pos << (p0[2]+1.0*k)/@lat_vec[2][2]
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
    3.times{|i|
      tmp=[0.0,0.0,0.0]
      3.times{|j|
        3.times{|k|
          tmp[j]+=rot[j][k]*@lat_vec[i][k]
        }
      }
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
#      pos[1] -= 1.0 if r_pos[1] > 0.9999
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
    if @options[:rotate]==:zero then
      p x=-@lat_vec[1][0]/@lat_vec[0][0]
      p a=@lat_vec[1][0]+(1.0+x)*@lat_vec[0][0]
      p b=@lat_vec[1][1]+(1.0+x)*@lat_vec[0][1]
    else
#      @lat_vec[1][1]-=0.5
      p a=@lat_vec[1][0]+@lat_vec[0][0]
      p b=@lat_vec[1][1]+@lat_vec[0][1]-0.5
    end
    @lat_vec[0]=[a,0.0,0.0]
    @lat_vec[1]=[0.0,b,0.0]
    p @lat_vec
    p @pos.size
    @pos=[]
    pos1.each{|pos|
      if @options[:rotate]==:zero then
        @pos << [pos[0]/@lat_vec[0][0],pos[1]/@lat_vec[1][1],pos[2]/@lat_vec[2][2]]
      else
        if (pos[0]>=-a-TINY && pos[0]<a) &&
            (pos[1]>=0-TINY && pos[1]<b) then
          @pos << [pos[0]/@lat_vec[0][0],pos[1]/@lat_vec[1][1],pos[2]/@lat_vec[2][2]]
        end
      end
    }
    @pos_size = @pos.size
  end

  def poscar_format(a0=8.0827999115/2.0) #real POSCAR for Al lattice parameter(a0=4.04...)
    text=""
    text << sprintf("%s\n",@head)
    text << sprintf("%f\n",@whole_scale)

    @lat_vec.each {|vec| 
      text << sprintf("%15.10f %15.10f %15.10f\n",a0*2.0*vec[0],a0*vec[1],a0*vec[2])
    }
    text << sprintf("%d\n",@pos_size)
    text << sprintf("Selective dynamics\n")
    text << sprintf("Direct\n")
    @pos.each{|pos| text << sprintf("%15.10f %15.10f %15.10f T T T \n",(1.0+pos[0])/2.0,pos[1],pos[2])}
    return text
  end

end

if __FILE__ == $0 then
  if ARGV[0]==nil then
    print "Usage: ruby maker.rb 2 2 2 3\n"  
    exit
  end

  boundary=BoundaryModelMaker.new('POSCAR',ARGV[0].to_i,ARGV[1].to_i,ARGV[2].to_i,ARGV[3].to_i)
  p file_name='POSCAR_'+ARGV[0]+ARGV[1]+ARGV[2]+ARGV[3]

  file=File.open(file_name,'w')
  file.print boundary.display
  file.close
#  system "cp #{file_name} ../viewer/POSCARs/#{file_name}"
#  system "cp #{file_name} ../adjuster/"
end


