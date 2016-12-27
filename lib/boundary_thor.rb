require "boundary/version"
require "boundary/command/options"
require "boundary/model/maker"
require "boundary/adjuster/adjuster"
require "boundary/view/viewer"
require 'optparse'
require 'thor'

module Boundary
  # Your code goes here...
  class CLI < Thor
    desc 'version', 'version'
    def version
      puts Boundary::VERSION
    end

    desc 'make STRING', "make model with \'2 2 2 3\'"
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

  end
end
