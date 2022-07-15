# zig-0.10.0-dev.2998+a45592715

```
$ zig version
0.10.0-dev.2998+a45592715
```

```
perf record -F 99 -g --call-graph dwarf zig test src/zig-master.zig
```

```
$ perf record -F 99 -g --call-graph dwarf zig test src/zig-master.zig
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
^C[ perf record: Woken up 139 times to write data ]
[ perf record: Captured and wrote 37.464 MB perf.data (4366 samples) ]
```

`perf report`

```
Samples: 4K of event 'cycles', Event count (approx.): 167526924356
  Children      Self  Command  Shared Object      Symbol
+   40.49%     5.14%  test     [kernel.kallsyms]  [k] asm_exc_page_fault
+   39.58%    17.83%  test     test               [.] memset
+   35.27%     0.34%  test     [kernel.kallsyms]  [k] exc_page_fault
+   34.05%    26.32%  test     test               [.] std.mem.set
+   33.87%     0.44%  test     [kernel.kallsyms]  [k] do_user_addr_fault
+   32.86%     0.83%  test     [kernel.kallsyms]  [k] handle_mm_fault
+   31.43%     1.27%  test     [kernel.kallsyms]  [k] __handle_mm_fault
+   30.00%     0.52%  test     [kernel.kallsyms]  [k] handle_pte_fault
+   27.51%     0.50%  test     [kernel.kallsyms]  [k] do_anonymous_page
+   21.77%     0.65%  test     [kernel.kallsyms]  [k] alloc_pages_vma
+   20.91%     0.42%  test     [kernel.kallsyms]  [k] __alloc_pages
+   20.16%     0.26%  test     [kernel.kallsyms]  [k] get_page_from_freelist
+   17.69%     5.06%  test     test               [.] memcpy
+   17.06%    17.01%  test     [kernel.kallsyms]  [k] clear_page_rep
+    5.95%     0.00%  test     [kernel.kallsyms]  [k] entry_SYSCALL_64_after_hwframe
+    5.95%     0.00%  test     [kernel.kallsyms]  [k] do_syscall_64
+    5.92%     0.00%  test     test               [.] std.os.linux.x86_64.syscall2
+    5.92%     0.00%  test     [kernel.kallsyms]  [k] __x64_sys_munmap
+    5.92%     0.00%  test     [kernel.kallsyms]  [k] __vm_munmap
+    5.92%     0.00%  test     [kernel.kallsyms]  [k] __do_munmap
+    5.92%     0.00%  test     [kernel.kallsyms]  [k] unmap_region
+    5.90%     0.00%  test     [kernel.kallsyms]  [k] unmap_vmas
+    5.90%     0.00%  test     [kernel.kallsyms]  [k] unmap_single_vma
+    5.90%     0.00%  test     [kernel.kallsyms]  [k] unmap_page_range
+    5.90%     0.00%  test     [kernel.kallsyms]  [k] zap_pmd_range.isra.0
+    5.84%     1.53%  test     [kernel.kallsyms]  [k] zap_pte_range
+    3.69%     1.12%  test     [kernel.kallsyms]  [k] release_pages
+    3.46%     0.00%  test     [kernel.kallsyms]  [k] tlb_flush_mmu
+    3.40%     0.03%  test     [kernel.kallsyms]  [k] free_pages_and_swap_cache
+    2.76%     0.86%  test     [kernel.kallsyms]  [k] rmqueue
+    2.73%     0.13%  test     [kernel.kallsyms]  [k] lru_cache_add_inactive_or_unevictable
+    2.57%     0.23%  test     [kernel.kallsyms]  [k] lru_cache_add
+    2.39%     0.23%  test     [kernel.kallsyms]  [k] __pagevec_lru_add
+    1.90%     0.31%  test     [kernel.kallsyms]  [k] free_unref_page_list
+    1.90%     1.87%  test     [kernel.kallsyms]  [k] rmqueue_bulk
+    1.69%     0.81%  test     [kernel.kallsyms]  [k] __pagevec_lru_add_fn
+    1.66%     0.68%  test     [kernel.kallsyms]  [k] __mod_lruvec_page_state
+    1.61%     0.23%  test     [kernel.kallsyms]  [k] __mod_lruvec_state
+    1.48%     0.13%  test     [kernel.kallsyms]  [k] free_unref_page_commit.constprop.0
+    1.43%     0.03%  test     [kernel.kallsyms]  [k] do_wp_page
+    1.37%     0.05%  test     [kernel.kallsyms]  [k] wp_page_copy
+    1.35%     0.29%  test     [kernel.kallsyms]  [k] free_pcppages_bulk
+    1.30%     0.03%  test     [kernel.kallsyms]  [k] __mem_cgroup_charge
```

# zig-0.9.1

```
hnakamur@thinkcentre2:~/ghq/github.com/hnakamur/expNnWindowed-become-slow$ perf record -F 99 -g --call-graph dwarf ~/zig/zig-0.9.1/zig test src/zig-0.9.1.zig

...(snip)...

All 1 tests passed.
[ perf record: Woken up 21 times to write data ]
[ perf record: Captured and wrote 7.192 MB perf.data (587 samples) ]
```

`perf report`

```
Samples: 587  of event 'cycles', Event count (approx.): 4484503355
  Children      Self  Command  Shared Object      Symbol
+   21.36%    21.36%  zig      zig                [.] 0x0000000003222c6d
+   21.36%     0.00%  zig      zig                [.] 0x0000000003423c6d
+    6.43%     4.93%  zig      zig                [.] memset
+    5.47%     0.00%  zig      [kernel.kallsyms]  [k] entry_SYSCALL_64_after_hwframe
+    5.46%     0.00%  zig      [kernel.kallsyms]  [k] do_syscall_64
+    3.53%     0.98%  zig      [kernel.kallsyms]  [k] asm_exc_page_fault
+    3.07%     1.95%  zig      zig                [.] memcpy
+    2.55%     0.00%  zig      [kernel.kallsyms]  [k] exc_page_fault
+    2.52%     2.52%  zig      zig                [.] llvm::TargetRegisterInfo::shouldRealignStack
+    2.45%     0.00%  zig      [kernel.kallsyms]  [k] do_user_addr_fault
+    2.45%     0.00%  zig      [kernel.kallsyms]  [k] handle_mm_fault
+    2.45%     0.00%  zig      [kernel.kallsyms]  [k] __handle_mm_fault
+    2.45%     0.00%  zig      [kernel.kallsyms]  [k] handle_pte_fault
+    2.30%     0.00%  zig      [kernel.kallsyms]  [k] do_anonymous_page
+    2.18%     0.00%  zig      [kernel.kallsyms]  [k] alloc_pages_vma
+    2.18%     0.00%  zig      [kernel.kallsyms]  [k] __alloc_pages
+    2.18%     0.00%  zig      [kernel.kallsyms]  [k] get_page_from_freelist
+    1.96%     0.97%  zig      zig                [.] llvm::TargetRegisterInfo::getMinimalPhysRegClass
+    1.95%     1.95%  zig      zig                [.] llvm::MCAssembler::layout
+    1.67%     1.67%  zig      zig                [.] llvm::Value::getContext
+    1.38%     1.38%  zig      zig                [.] 0x0000000006823526
+    1.38%     0.00%  zig      zig                [.] 0x0000000006a24526
+    1.21%     1.21%  zig      zig                [.] 0x000000000644d6de
+    1.21%     0.00%  zig      zig                [.] 0x000000000664e6de
+    1.21%     1.21%  zig      [kernel.kallsyms]  [k] clear_page_rep
+    1.15%     0.00%  zig      zig                [.] munmap
+    1.15%     0.00%  zig      [kernel.kallsyms]  [k] __x64_sys_munmap
+    1.15%     0.00%  zig      [kernel.kallsyms]  [k] __vm_munmap
+    1.15%     0.00%  zig      [kernel.kallsyms]  [k] __do_munmap
+    1.13%     1.13%  zig      zig                [.] llvm::SelectionDAGISel::SelectCodeCommon
+    1.08%     1.08%  zig      zig                [.] 0x0000000005161d5a
+    1.08%     0.00%  zig      zig                [.] 0x0000000005362d5a
+    1.05%     1.05%  zig      zig                [.] llvm::StringMapImpl::LookupBucketFor
+    1.03%     1.03%  zig      zig                [.] 0x0000000005bf3f1e
+    1.03%     0.00%  zig      zig                [.] 0x0000000005df4f1e
+    1.01%     1.01%  zig      zig                [.] 0x00000000052d51bc
+    1.01%     0.00%  zig      zig                [.] 0x00000000054d61bc
+    0.99%     0.00%  zig      zig                [.] 0x00000000076ff4aa
+    0.99%     0.99%  zig      zig                [.] 0x00000000031eab57
+    0.99%     0.00%  zig      zig                [.] 0x00000000033ebb57
+    0.99%     0.00%  zig      [kernel.kallsyms]  [k] asm_sysvec_apic_timer_interrupt
+    0.99%     0.00%  zig      [kernel.kallsyms]  [k] sysvec_apic_timer_interrupt
```
