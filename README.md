## What's this?

This repo contains an experiment of building a Ruby extension with Zig programming language.
It implements a slightly altered version of [100 doors](https://rosettacode.org/wiki/100_doors) from Rosetta Code.

These are results of benchmarks on my machine (Thinkpad T14):

```
Warming up --------------------------------------
                Ruby   924.000  i/100ms
                 Zig    13.885k i/100ms
Calculating -------------------------------------
                Ruby     12.745k (±22.1%) i/s -     60.984k in   5.052486s
                 Zig    233.096k (± 0.1%) i/s -      1.166M in   5.003698s

Comparison:
                 Zig:   233095.9 i/s
                Ruby:    12744.7 i/s - 18.29x  (± 0.00) slower
```

However, if you edit `extconf.rb` to use `-Drelease-fast` flag, the difference is much bigger:

```
Warming up --------------------------------------
                Ruby     1.020k i/100ms
                 Zig   171.828k i/100ms
Calculating -------------------------------------
                Ruby     10.289k (± 2.2%) i/s -     52.020k in   5.058112s
                 Zig      2.833M (± 6.3%) i/s -     14.262M in   5.059011s

Comparison:
                 Zig:  2833045.1 i/s
                Ruby:    10289.0 i/s - 275.35x  (± 0.00) slower
```

Please note that this is only one benchmark, not much science behind it. It doesn't mean you will always get
270x speed boost on just rewriting in Zig.

## How to run it

1. You need fairly recent version of Zig, which at this time means a version built from git
2. Clone this repo
3. Run `rake benchmark`

Note that it likely only works on Linux, I'd gladly 
