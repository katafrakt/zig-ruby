## What's this?

This repo contains an experiment of building a Ruby extension with Zig programming language.
It implements a slightly altered version of [100 doors](https://rosettacode.org/wiki/100_doors) from Rosetta Code.

These are results of benchmarks on my machine (Thinkpad T14, Ruby 3.4.1 vs Zig 0.15.2):

```
Warming up --------------------------------------
                Ruby   752.000 i/100ms
                 Zig     3.655k i/100ms
Calculating -------------------------------------
                Ruby      9.244k (±23.6%) i/s  (108.18 μs/i) -     44.368k in   5.048012s
                 Zig     61.502k (± 0.2%) i/s   (16.26 μs/i) -    310.675k in   5.051463s

Comparison:
                 Zig:    61502.1 i/s
                Ruby:     9243.7 i/s - 6.65x  slower
```

However, if you edit `extconf.rb` to use `-Drelease-fast` flag, the difference is much bigger:

```
Warming up --------------------------------------
                Ruby   750.000 i/100ms
                 Zig   142.363k i/100ms
Calculating -------------------------------------
                Ruby      7.519k (± 1.4%) i/s  (132.99 μs/i) -     38.250k in   5.087937s
                 Zig      2.427M (± 7.7%) i/s  (411.95 ns/i) -     12.101M in   5.020047s

Comparison:
                 Zig:  2427474.2 i/s
                Ruby:     7519.3 i/s - 322.83x  slower
```

Please note that this is only one benchmark, not much science behind it. It doesn't mean you will always get
320x speed boost on just rewriting in Zig.

## How to run it

1. Have Zig version 0.15.2 available on your system
2. Clone this repo
3. Run `rake compile_ext`
3. Run `rake benchmark`
