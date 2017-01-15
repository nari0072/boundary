# -*- coding: utf-8 -*-
require 'thor'

class MyCli < Thor
  desc "hello NAME", "say hello to NAME"
  def hello(name)
    puts "Hello #{name}"
  end
end

MyCLI.start(ARGV)
