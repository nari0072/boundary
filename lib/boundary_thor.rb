require "boundary/version"
require "boundary/command/options"
require "boundary/model/maker"
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
      make_model(string)
    end

    private
    def make_model(str)
      l,m,n,d=str.split(' ').map!{|ele| ele.to_i}
      p file_name="POSCAR_"+str.gsub(' ','')

      boundary=BoundaryModelMaker.new('POSCAR',l,m,n,d)
      File.open(file_name,'w'){|file| file.print boundary.display}
    end
  end



end
