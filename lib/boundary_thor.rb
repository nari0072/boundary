require "boundary/version"
require "boundary/command/options"
require "boundary/model/maker"
require "boundary/adjuster/adjuster"
require "boundary/view/viewer"
require "boundary/view/compare"
require "boundary/view/expand"
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

    desc 'diff FILE1 [FILE2]', "show diff FILE1 and FILE2 model, FILE2 is optional"
    def diff(file1, file2=nil)
      file2=file1 unless file2
      model_scale = 1.0/0.12
      ViewCompare.new(file1,file2, model_scale).three_view
      system("open -a safari view.svg")
    end

    desc 'expand FILE1', "show periodically expanded FILE1"
    def expand(file1)
      file2=file1 unless file2
      model_scale = 1.0/0.12
      ViewExpand.new(file1, model_scale)
      system("open -a safari view.svg")
    end

    desc 'top_view FILE', "top_view FILE1"
    def top_view(file)
      file1 = file2 = file
      model_scale = 1.0/0.12
      ViewCompare.new(file1,file2, model_scale).top_view
    end

  end
end
