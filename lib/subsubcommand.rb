require 'thor'
require 'thor/group'

class Baz < Thor
  namespace 'bar baz'

  desc 'qux', 'qux!!!'
  def qux
    puts 'qux'
  end

  def self.banner(task, namespace = false, subcommand = true)
    super
  end
end

class Bar < Thor
  namespace :bar
  register(Baz, 'baz', 'baz [COMMAND]', 'subcommad for baz')

  def self.banner(task, namespace = false, subcommand = true)
    super
  end
end

class Foo < Thor
  register(Bar, 'bar', 'bar [COMMAND]', 'commands for bar')
end
Foo.start

# refer from http://qiita.com/nari3/items/73f1df68ad497fd0320a

=begin
bob% ruby subsubcommand.rb 
Commands:
  subsubcommand.rb bar [COMMAND]   # commands for bar
  subsubcommand.rb help [COMMAND]  # Describe available commands or one specific command

[bob:~/Github/boundary/lib] bob% ruby subsubcommand.rb --help
Commands:
  subsubcommand.rb bar [COMMAND]   # commands for bar
  subsubcommand.rb help [COMMAND]  # Describe available commands or one specific command

[bob:~/Github/boundary/lib] bob% ruby subsubcommand.rb bar --help 
Commands:
  subsubcommand.rb bar baz [COMMAND]   # subcommad for baz
  subsubcommand.rb bar help [COMMAND]  # Describe subcommands or one specific subcommand

[bob:~/Github/boundary/lib] bob% ruby subsubcommand.rb bar baz --help
Commands:
  subsubcommand.rb bar baz help [COMMAND]  # Describe subcommands or one specific subcommand
  subsubcommand.rb bar baz qux             # qux!!!

=end

#or in http://stackoverflow.com/questions/5663519/namespacing-thor-commands-in-a-standalone-ruby-executable
