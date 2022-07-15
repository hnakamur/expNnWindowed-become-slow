expNnWindowed-become-slow
=========================

# Fixed with the following patch.

```
diff -ruN ./zig-0.10.0-dev.3004+397e6547a/lib.orig/std/math/big/int.zig ./zig-0.10.0-dev.3004+397e6547a/lib/std/math/big/int.zig
--- ./zig-0.10.0-dev.3004+397e6547a/lib.orig/std/math/big/int.zig	2022-07-15 16:16:45.000000000 +0900
+++ ./zig-0.10.0-dev.3004+397e6547a/lib/std/math/big/int.zig	2022-07-15 23:20:00.858757649 +0900
@@ -2780,7 +2780,7 @@
         if (alias_count == 0) {
             m.mulNoAlias(a.toConst(), b.toConst(), rma.allocator);
         } else {
-            const limb_count = calcMulLimbsBufferLen(a.limbs.len, b.limbs.len, alias_count);
+            const limb_count = calcMulLimbsBufferLen(a.toConst().limbs.len, b.toConst().limbs.len, alias_count);
             const limbs_buffer = try rma.allocator.alloc(Limb, limb_count);
             defer rma.allocator.free(limbs_buffer);
             m.mul(a.toConst(), b.toConst(), limbs_buffer, rma.allocator);
@@ -2960,7 +2960,7 @@
 
     /// r = a * a
     pub fn sqr(rma: *Managed, a: *const Managed) !void {
-        const needed_limbs = 2 * a.limbs.len + 1;
+        const needed_limbs = 2 * a.toConst().limbs.len + 1;
 
         if (rma.limbs.ptr == a.limbs.ptr) {
             var m = try Managed.initCapacity(rma.allocator, needed_limbs);
```

```
$ time ~/zig/zig-0.10.0-dev.3004+397e6547a/zig test src/zig-master.zig
All 1 tests passed.

real    0m1.082s
user    0m0.940s
sys     0m0.211s
```

# zig-0.10.0-dev.2998+a45592715

```
$ time zig test src/zig-master.zig
Test [1/1] test "expNnWindowed"... [default] (debug): i=3, yi=47549
[default] (debug): j=0, z=1, zz=1845527255602271981702742937530238186257264257200908066252664038294878570532216775755901106041276767961878015944229343145
[default] (debug): j=4, z=1, zz=0
[default] (debug): j=8, z=1, zz=0
[default] (debug): j=12, z=1, zz=0
[default] (debug): j=16, z=1, zz=0
[default] (debug): j=20, z=1, zz=0
[default] (debug): j=24, z=1, zz=0
[default] (debug): j=28, z=1, zz=0
[default] (debug): j=32, z=1, zz=0
[default] (debug): j=36, z=1, zz=0
[default] (debug): j=40, z=1, zz=0
[default] (debug): j=44, z=1, zz=0
[default] (debug): j=48, z=1, zz=0
[default] (debug): j=52, z=9523152963402951471625424590658989670922241046576300808420570282327067728379306733271599318022070576040345009923426205595, zz=0
^C
real    0m40.456s
user    0m0.960s
sys     0m0.130s
```

```
$ zig version
0.10.0-dev.2998+a45592715
```

# zig-0.10.0-dev.2853+6279a1d68

```
$ time ~/zig/zig-0.10.0-dev.2853+6279a1d68/zig test src/zig-master.zig
Test [1/1] test "expNnWindowed"... [default] (debug): i=3, yi=47549
[default] (debug): j=0, z=1, zz=1845527255602271981702742937530238186257264257200908066252664038294878570532216775755901106041276767961878015944229343145
[default] (debug): j=4, z=1, zz=0
[default] (debug): j=8, z=1, zz=0
[default] (debug): j=12, z=1, zz=0
[default] (debug): j=16, z=1, zz=0
[default] (debug): j=20, z=1, zz=0
[default] (debug): j=24, z=1, zz=0
[default] (debug): j=28, z=1, zz=0
[default] (debug): j=32, z=1, zz=0
[default] (debug): j=36, z=1, zz=0
[default] (debug): j=40, z=1, zz=0
[default] (debug): j=44, z=1, zz=0
[default] (debug): j=48, z=1, zz=0
[default] (debug): j=52, z=9523152963402951471625424590658989670922241046576300808420570282327067728379306733271599318022070576040345009923426205595, zz=0
^C

real    0m42.177s
user    0m0.886s
sys     0m0.185s
```

# zig-0.10.0-dev.2577+5816d3eae

```
$ ~/zig/zig-0.10.0-dev.2577+5816d3eae/zig test src/zig-master.zig
./src/zig-master.zig:44:19: error: expected type 'std.math.big.int.Const', found '*std.math.big.int.Managed'
        try p.sqr(p2);
                  ^
/home/hnakamur/zig/zig-0.10.0-dev.2577+5816d3eae/lib/std/math/big/int.zig:1854:19: note: std.math.big.int.Const declared here
pub const Const = struct {
                  ^
```

# zig-0.9.1

$ (time ~/zig/zig-0.9.1/zig test src/zig-0.9.1.zig) 2>&1 | cat > zig-0.9.1.log
```

```
1/1 test "expNnWindowed"... [default] (debug): i=3, yi=47549
[default] (debug): j=0, z=1, zz=1845527255602271981702742937530238186257264257200908066252664038294878570532216775755901106041276767961878015944229343145
[default] (debug): j=4, z=1, zz=0
[default] (debug): j=8, z=1, zz=0
[default] (debug): j=12, z=1, zz=0
[default] (debug): j=16, z=1, zz=0
[default] (debug): j=20, z=1, zz=0
[default] (debug): j=24, z=1, zz=0
[default] (debug): j=28, z=1, zz=0
[default] (debug): j=32, z=1, zz=0
[default] (debug): j=36, z=1, zz=0
[default] (debug): j=40, z=1, zz=0
[default] (debug): j=44, z=1, zz=0
[default] (debug): j=48, z=1, zz=0
[default] (debug): j=52, z=9523152963402951471625424590658989670922241046576300808420570282327067728379306733271599318022070576040345009923426205595, zz=0

...(snip)...

[default] (debug): j=60, z=20437227017141239263065766638578576461443669640157144118304654708690057743086359324541353357718437626600055113934622054939527460698272382277420894889815213867479502633198279010460487766076419730052816447647164892030898803734744439663284240225710284451912912875131154769591597752438642957522246443465105771879730096293536587931509785010583684591909204348109836718091704273027679936848012568785147378114589034684530399769036547734747960926921658036443619072238122210401009185302254184301372809469374842388258847357420232193908939481554921133222110031649251147338089456131403771221446325995321947144296025317049028911860, zz=2486
OK
All 1 tests passed.

real	0m0.081s
user	0m0.060s
sys	0m0.110s
```

See zig-0.9.1.log for full log.
