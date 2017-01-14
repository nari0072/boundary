require "boundary/version"
require "boundary/command/options"
require "boundary/model/maker"
require "boundary/adjuster/adjuster"
require "boundary/view/viewer"
require "boundary/view/compare"
require 'optparse'
require 'thor'

module Boundary
  # Your code goes here...
  class CLI < Thor
    desc 'version', 'version'
    def version
      puts Boundary::VERSION
    end

    desc 'make STRING', "make model with STRING \'2 2 2 3\'"
    def make(string)
      l,m,n,d=string.split(' ').map!{|ele| ele.to_i}
      p file_name="POSCAR_"+string.gsub(' ','')

      boundary=BoundaryModelMaker.new('POSCAR',l,m,n,d)
      File.open(file_name,'w'){|file| file.print boundary.display}
    end

    desc 'adjust [FILE]', "adjust FILE model"
    def adjust(file=nil)
      boundary_model=BoundaryModelAdjuster.new(file)
    end

    desc 'compare [FILE1] [FILE2]', "compare FILE1 and FILE2 model"
    def compare(file1, file2=nil)
      p file1, file2
      file1=file2 if file2==nil
      model_scale = 1.0/0.12
      ViewCompare.new(ARGV[0],ARGV[1], model_scale)
    end

  end
end
