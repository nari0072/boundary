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

    desc 'directory DIR', 'set target directory to DIR'
    def directory(dir)
      p  @target_dir = dir
    end

    desc 'make STRING', "make model with \'2 2 2 3\'"
    def make(string)
      make_model(string)
    end

    private 
    def make_model(str)
      Dir.chdir(@target_dir||'.')
      p Dir.pwd
      p str
      if str==nil then
        print "Usage: boundary -m \'2 2 2 3\'\n"
        exit
      end

      l,m,n,d=str.split(' ').map!{|ele| ele.to_i}
      ext=str.gsub(' ','')
      p file_name="POSCAR_#{ext}"

      boundary=BoundaryModelMaker.new('POSCAR',l,m,n,d)
      file=File.open(file_name,'w')
      file.print boundary.display
      file.close
    end

  end



end
