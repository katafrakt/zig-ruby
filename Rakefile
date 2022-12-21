task :compile_ext do
  cd "ext/zig_rb" do
    ruby "extconf.rb"
    sh "make"
  end
end

task :benchmark => :compile_ext do
  ruby "benchmark.rb"
end