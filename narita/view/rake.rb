
task :hello do
 name = ENV["NAME"] || "RUBY"
 puts  "Hello, #{name}!"
end
