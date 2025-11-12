require "mkmf"

makefile_path = File.join("Makefile")
config = RbConfig::CONFIG
File.open(makefile_path, "w") do |f|
  f.puts <<~MFILE
all:
\tRUBY_LIBDIR=#{config["libdir"]} RUBY_HDRDIR=#{config["rubyhdrdir"]} RUBY_ARCHHDRDIR=#{config["rubyarchhdrdir"]} zig build
MFILE
end
