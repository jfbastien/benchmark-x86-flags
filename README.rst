===============================
Benchmark x86 Flag Save/restore
===============================

:Author:
   JF Bastien

Background
----------

LLVM isn't very smart about x86 flags, and as of r220529_ and PR20376_ it
emitted `PUSHF` and `POPF` to save and restore all user-mode flags in `EFLAGS`
when flags are live across a call. A more optimal approach is to use `LAHF` and
`SAHF` (for `CF`, `PF`, `AF`, `ZF`, `SF`) combined with `SETO` and `ADDB` (for
`OF`). An even more optimal approach is to treat each of the flags in `EFLAGS`
as sub-registers and only use the right `SETcc` instruction when a single flag
is live, such as using `SETO` and `TEST` when only `ZF` is actually live.

The NaCl_ validator doesn't allow `PUSHF` and `POPF` instructions because
they've been the source of security bugs. D6629_ tries to fix this issue and
potentially make LLVM more efficient.

This benchmark is aimed at figuring out which approach LLVM should take.

Results
-------

The results on an Intel Haswell E5-2690 CPU at 2.9GHz are:

+---------------------+--------------+--------------------------------+
| Time per call (ms)  | Runtime (ms) | Benchmark                      |
+=====================+==============+================================+
| 0.000012514         |      6257    | sete.i386                      |
+---------------------+--------------+--------------------------------+
| 0.000012810         |      6405    | sete.i386-fast                 |
+---------------------+--------------+--------------------------------+
| 0.000010456         |      5228    | sete.x86-64                    |
+---------------------+--------------+--------------------------------+
| 0.000010496         |      5248    | sete.x86-64-fast               |
+---------------------+--------------+--------------------------------+
| 0.000012906         |      6453    | lahf-sahf.i386                 |
+---------------------+--------------+--------------------------------+
| 0.000013236         |      6618    | lahf-sahf.i386-fast            |
+---------------------+--------------+--------------------------------+
| 0.000010580         |      5290    | lahf-sahf.x86-64               |
+---------------------+--------------+--------------------------------+
| 0.000010304         |      5152    | lahf-sahf.x86-64-fast          |
+---------------------+--------------+--------------------------------+
| 0.000028056         |     14028    | pushf-popf.i386                |
+---------------------+--------------+--------------------------------+
| 0.000027160         |     13580    | pushf-popf.i386-fast           |
+---------------------+--------------+--------------------------------+
| 0.000023810         |     11905    | pushf-popf.x86-64              |
+---------------------+--------------+--------------------------------+
| 0.000026468         |     13234    | pushf-popf.x86-64-fast         |
+---------------------+--------------+--------------------------------+

.. _r220529: http://llvm.org/viewvc/llvm-project?view=revision&revision=220529
.. _PR20376: http://llvm.org/bugs/show_bug.cgi?id=20376
.. _NaCl: http://gonacl.com
.. _D6629: http://reviews.llvm.org/D6629
