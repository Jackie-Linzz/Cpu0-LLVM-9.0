; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s | FileCheck %s
target datalayout = "e-m:e-i64:64-n32:64"
target triple = "powerpc64le-unknown-linux-gnu"

define i1 @and_cmp_variable_power_of_two(i32 %x, i32 %y) {
; CHECK-LABEL: and_cmp_variable_power_of_two:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subfic 4, 4, 32
; CHECK-NEXT:    rlwnm 3, 3, 4, 31, 31
; CHECK-NEXT:    blr
  %shl = shl i32 1, %y
  %and = and i32 %x, %shl
  %cmp = icmp eq i32 %and, %shl
  ret i1 %cmp
}

define i1 @and_cmp_variable_power_of_two_64(i64 %x, i64 %y) {
; CHECK-LABEL: and_cmp_variable_power_of_two_64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subfic 4, 4, 64
; CHECK-NEXT:    rldcl 3, 3, 4, 63
; CHECK-NEXT:    blr
  %shl = shl i64 1, %y
  %and = and i64 %x, %shl
  %cmp = icmp eq i64 %and, %shl
  ret i1 %cmp
}

define i1 @and_ncmp_variable_power_of_two(i32 %x, i32 %y) {
; CHECK-LABEL: and_ncmp_variable_power_of_two:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subfic 4, 4, 32
; CHECK-NEXT:    nor 3, 3, 3
; CHECK-NEXT:    rlwnm 3, 3, 4, 31, 31
; CHECK-NEXT:    blr
  %shl = shl i32 1, %y
  %and = and i32 %x, %shl
  %cmp = icmp ne i32 %and, %shl
  ret i1 %cmp
}

define i1 @and_ncmp_variable_power_of_two_64(i64 %x, i64 %y) {
; CHECK-LABEL: and_ncmp_variable_power_of_two_64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    not 3, 3
; CHECK-NEXT:    subfic 4, 4, 64
; CHECK-NEXT:    rldcl 3, 3, 4, 63
; CHECK-NEXT:    blr
  %shl = shl i64 1, %y
  %and = and i64 %x, %shl
  %cmp = icmp ne i64 %and, %shl
  ret i1 %cmp
}
