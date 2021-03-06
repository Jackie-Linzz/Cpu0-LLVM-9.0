# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=bdver2 -iterations=100 -resource-pressure=false -timeline -timeline-max-iterations=2 < %s | FileCheck %s

# movss/movsd explicitly zeroes out the high bits of xmm,
# so addps can start immediately, without waiting for sqrtss to finish.
# AMD SOG for the AMD family 15h processors, 5.5 Partial-Register Writes

# LLVM-MCA-BEGIN
sqrtss %xmm0, %xmm0
movss  (%eax), %xmm0
addps  %xmm0, %xmm0
# LLVM-MCA-END

# LLVM-MCA-BEGIN
sqrtsd %xmm0, %xmm0
movsd  (%eax), %xmm0
addps  %xmm0, %xmm0
# LLVM-MCA-END

# CHECK:      [0] Code Region

# CHECK:      Iterations:        100
# CHECK-NEXT: Instructions:      300
# CHECK-NEXT: Total Cycles:      655
# CHECK-NEXT: Total uOps:        300

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    0.46
# CHECK-NEXT: IPC:               0.46
# CHECK-NEXT: Block RThroughput: 6.5

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      9     4.50                        sqrtss	%xmm0, %xmm0
# CHECK-NEXT:  1      5     1.50    *                   movss	(%eax), %xmm0
# CHECK-NEXT:  1      5     1.00                        addps	%xmm0, %xmm0

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789
# CHECK-NEXT: Index     0123456789          012

# CHECK:      [0,0]     D=eeeeeeeeeER  .    . .   sqrtss	%xmm0, %xmm0
# CHECK-NEXT: [0,1]     DeeeeeE-----R  .    . .   movss	(%eax), %xmm0
# CHECK-NEXT: [0,2]     D======eeeeeER .    . .   addps	%xmm0, %xmm0
# CHECK-NEXT: [1,0]     D===========eeeeeeeeeER   sqrtss	%xmm0, %xmm0
# CHECK-NEXT: [1,1]     .D==eeeeeE------------R   movss	(%eax), %xmm0
# CHECK-NEXT: [1,2]     .D=========eeeeeE-----R   addps	%xmm0, %xmm0

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     7.0    1.0    0.0       sqrtss	%xmm0, %xmm0
# CHECK-NEXT: 1.     2     2.0    2.0    8.5       movss	(%eax), %xmm0
# CHECK-NEXT: 2.     2     8.5    1.5    2.5       addps	%xmm0, %xmm0

# CHECK:      [1] Code Region

# CHECK:      Iterations:        100
# CHECK-NEXT: Instructions:      300
# CHECK-NEXT: Total Cycles:      655
# CHECK-NEXT: Total uOps:        300

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    0.46
# CHECK-NEXT: IPC:               0.46
# CHECK-NEXT: Block RThroughput: 6.5

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      9     4.50                        sqrtsd	%xmm0, %xmm0
# CHECK-NEXT:  1      5     1.50    *                   movsd	(%eax), %xmm0
# CHECK-NEXT:  1      5     1.00                        addps	%xmm0, %xmm0

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789
# CHECK-NEXT: Index     0123456789          012

# CHECK:      [0,0]     D=eeeeeeeeeER  .    . .   sqrtsd	%xmm0, %xmm0
# CHECK-NEXT: [0,1]     DeeeeeE-----R  .    . .   movsd	(%eax), %xmm0
# CHECK-NEXT: [0,2]     D======eeeeeER .    . .   addps	%xmm0, %xmm0
# CHECK-NEXT: [1,0]     D===========eeeeeeeeeER   sqrtsd	%xmm0, %xmm0
# CHECK-NEXT: [1,1]     .D==eeeeeE------------R   movsd	(%eax), %xmm0
# CHECK-NEXT: [1,2]     .D=========eeeeeE-----R   addps	%xmm0, %xmm0

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     7.0    1.0    0.0       sqrtsd	%xmm0, %xmm0
# CHECK-NEXT: 1.     2     2.0    2.0    8.5       movsd	(%eax), %xmm0
# CHECK-NEXT: 2.     2     8.5    1.5    2.5       addps	%xmm0, %xmm0
