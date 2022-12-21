require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem "benchmark-ips"
end

file = case RbConfig::CONFIG["host_os"]
when /linux/ then "libzig_rb.so"
when /darwin|mac os/ then "libzig_rb.dylib"
else
  raise "Unknown OS"
end

require File.join("./ext/zig_rb/zig-out/lib", file)

def hundred_doors(passes)
  doors = Array.new(101, false)
  passes.times do |i|
    i += 1
    (i..100).step(i) do |d|
      doors[d] = !doors[d]
    end
  end
  # dropping first one as it does not count
  doors.drop(1).count {|d| d}
end

puts "Ruby: #{hundred_doors(100)}, Zig: #{ZigRb.new.hundred_doors(100)}"

require "benchmark/ips"
zig = ZigRb.new

Benchmark.ips do |x|
  x.report("Ruby") { hundred_doors(100) }
  x.report("Zig") { zig.hundred_doors(100) }
  x.compare!
end
