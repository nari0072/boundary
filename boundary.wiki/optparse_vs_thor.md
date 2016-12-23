以下は，boundaryでoptparseとthorを比較した例です．

```ruby
[bob:~/Github/boundary] bob% cat exe/boundary
#!/usr/bin/env ruby

require "boundary"

Boundary::Command.run(ARGV)
[bob:~/Github/boundary] bob% cat exe/boundary_thor
#!/usr/bin/env ruby

#require "boundary"
require "boundary_thor"

#Boundary::Command.run(ARGV)
Boundary::CLI.start(ARGV)

```

```ruby
bob% cat boundary.rb
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
     command_parser.parse!(@argv)
     p @target_dir ||= './'

     FileUtils.cd(@target_dir){
       case @run
       when 'make'
         make(@opts)
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

 end
end

```

```ruby
bob% cat boundary_thor.rb
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
```

1. thorでは，optparseの-d spec -m ‘2 2 2 3’みたいに二つ以上の引数をするやり方がわからない．
  1. よく考えると，directory指定は，そこへcdしてからcommandを打てばいいので，削除．
1. thorでは，optparseで必要なif str == nil blockが自動で対応
1. thorでは，optparseで必要な，run, execが省略できる．
1. ThorはRakefileを書く場合とおなじ書式が使われているので，覚えるのに便利．
1. Thorのほうがいまのところcodeが短くて読みやすい．refactoringによって変わるかも．
