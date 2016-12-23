# -*- coding: utf-8 -*-
require 'fileutils'
require 'pseudovasp'
require_relative './mover/boundary_model_move'

def vasp_calc(file_name, opts={output: :show_energy, potential: :eam})
  target=PseudoVASP.new(file_name, opts)
  return target.display,target
end


class BoundaryModelAdjuster
  I_MAX = 100
  COMMAND_QUERY="Input [l]og, [q]uit or indexes of deleting atoms(87,12,...)] : "
  attr_reader :ini_file, :log

  def initialize(file=nil)
    @log=[]
    unless file.nil?
      @ini_file = file 
      @log << @ini_file
    else
      gets_file_name(file)
    end
    adjust
  end

  def gets_file_name(file=nil)
    default='POSCAR_2223'||file
    print "input initial file_name[default #{default}]: "
    p f_name=STDIN.gets.chomp
    ini_file = (f_name =='') ?  default : f_name
    @ini_file=ini_file
    @log << @ini_file
  end

  def get_boundary_energy(text, pos_size, yy, zz)
    tmp=text.match(/([+-]?\d+\.\d+) eV/)
    return sprintf("energy NaN\n") if tmp==nil
    total_energy=tmp[1].to_f
    d_energy= (total_energy - pos_size*(-3.735117))

    return sprintf("%10.5f eV, %10.5f J/m^2 (area:%10.5f A^2)\n",
                   d_energy, d_energy/(yy*zz)*1.60218*10/2, yy*zz)
    　　　　　　　　　　　　　　　　　　　　# E/2は面が２つあるため．
  end

  def pseudo_calc(file_name)
    text,target=vasp_calc(file_name)
    print text
    out = File.open("tmp.res",'w')
    out.print text
    out.close
    lines=text.split(/\n/)[7..-1]
    sorted_line=lines.sort_by!{|line|
      line.split(/\s+/)[7].to_f
    }
    print "-------------Higher energy atoms------------\n"
    sorted_line[-10..-1].each{|line| print line+"\n" }
    print text=get_boundary_energy(text,target.pos_size,
                                   target.lat_vec[1][1],target.lat_vec[2][2])
    @log << text
  end

  def adjust
    p file_name=@ini_file
    pseudo_calc(file_name)
    I_MAX.times{|i_times|
      print COMMAND_QUERY
      p command= STDIN.gets.chomp
      p numbers = command.match(/[\d(,|)]*/)
      @log << command
      if numbers[0]!="" then
        p atoms=numbers[0].split(/,/)
        boundary = BoundaryMove.new(file_name)
        boundary.delete(atoms)
        p file_name="#{@ini_file}_#{i_times}"
        boundary.new_poscar(file_name)
      elsif command[0] == 'l' then
        print_log
        next
      elsif command[0] == 'q' then
        break
      else
        p "no match"
      end
      pseudo_calc(file_name)
    }
    p "quitting..."
    print_log
    r_dir='rev_POSCARs'
    Dir.mkdir(r_dir) unless File.exists?(r_dir)
    system "mv #{@ini_file}_* #{r_dir}"
    system "rm tmp.res"
  end

  def print_log
    print ":"
    @log.each{|line| print line+":"}
    print "\n"
  end
end

if __FILE__ == $0 then
  boundary_model=BoundaryModelAdjuster.new()
end
