require "boundary/version"
require "boundary/command/options"
require "boundary/model/maker"
require "boundary/view/viewer"
require 'optparse'

module Boundary
  # Your code goes here...
  class Command

    def self.run(argv=[])
      print "boundary says 'Hello world'.\n"
      new(argv).execute
    end

    def initialize(argv=[])
      @argv = argv
    end

    def execute
      @argv << '--help' if @argv.size==0
      command_parser = OptionParser.new do |opt|
        opt.on('--version','show program Version.') { |v|
          opt.version = Boundary::VERSION
          puts opt.ver
        }
        opt.on('-d STRING', "--directory \'spec\'", String, 'select the target directory.') { |str|
          @target_dir = str
        }
        opt.on('-m STRING', "--make \'2 2 2 3\'", String, 'make a boundary model.') { |str|
          @run='make'
          @opts=str
        }
        opt.on('-v STRING', "--view \'2 2 2 3\'", String, 'view a boundary model.') { |str|
          @run='view'
          @opts=str
        }
      end
      command_parser.parse!(@argv)
      p @target_dir ||= './'

      FileUtils.cd(@target_dir){
        case @run
        when 'make'
          make(@opts)
        when 'view'
          view(@opts)
        end
      }
      exit
    end

    def make(str)
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

    def view(str)
      p str
      if str==nil then
        print "Usage: boundary -v \'2 2 2 3\'\n"
        exit
      end

      make(str)
      p ext=str.gsub(' ','')
      p file_name="POSCAR_#{ext}"
      viewer = BoundaryView.new(file_name)
      viewer.display(file_name)
    end
  end
end
