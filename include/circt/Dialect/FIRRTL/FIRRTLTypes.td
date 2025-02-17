//===- FIRRTLTypes.td - FIRRTL Types Definition ------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This describes the FIRRTL types.
//
//===----------------------------------------------------------------------===//

#ifndef CIRCT_DIALECT_FIRRTL_FIRRTLTYPES_TD
#define CIRCT_DIALECT_FIRRTL_FIRRTLTYPES_TD

include "FIRRTLDialect.td"

//===----------------------------------------------------------------------===//
// FIRRTL Types Definitions
//===----------------------------------------------------------------------===//

class FIRRTLDialectType<Pred pred, string summary, string cpp, string desc = "">
  : DialectType<FIRRTLDialect,pred, summary, cpp> {
  let description = desc;
}

def FIRRTLType : FIRRTLDialectType<CPred<"$_self.isa<FIRRTLType>()">,
  "FIRRTLType", "::circt::firrtl::FIRRTLType", [{
    Any FIRRTL dialect type, represented by FIRRTLType.
  }]>;

def FIRRTLBaseType : FIRRTLDialectType<
  CPred<"$_self.isa<FIRRTLBaseType>()">,
  "a base type", "::circt::firrtl::FIRRTLBaseType", [{
    A base FIRRTL type, such as a clock, integer, or wire.

    Base types represent circuit elements and constructs,
    examples include ClockType, IntType, or BundleType.
    Nearly all FIRRTL types are base types.

    All base types are FIRRTLType's, and inherit from FIRRTLBaseType.
  }]>;

def ForeignType : FIRRTLDialectType<CPred<"!$_self.isa<FIRRTLType>()">,
                                    "foreign type", "::mlir::Type">;

def ClockType : FIRRTLDialectType<CPred<"$_self.isa<ClockType>()">,
    "clock", "::circt::firrtl::ClockType">;

def IntType : FIRRTLDialectType<CPred<"$_self.isa<IntType>()">,
 "sint or uint type", "::circt::firrtl::IntType">;

def SIntType : FIRRTLDialectType<CPred<"$_self.isa<SIntType>()">,
 "sint type", "::circt::firrtl::SIntType">;

def UIntType : FIRRTLDialectType<CPred<"$_self.isa<UIntType>()">,
 "uint type", "::circt::firrtl::UIntType">;

def AnalogType : FIRRTLDialectType<CPred<"$_self.isa<AnalogType>()">,
 "analog type", "::circt::firrtl::AnalogType">;

def BundleType : FIRRTLDialectType<CPred<"$_self.isa<BundleType>()">,
 "BundleType", "::circt::firrtl::BundleType">;

def FVectorType : FIRRTLDialectType<CPred<"$_self.isa<FVectorType>()">,
  "FVectorType", "::circt::firrtl::FVectorType">;

def FEnumType : FIRRTLDialectType<CPred<"$_self.isa<FEnumType>()">,
 "FEnumType", "::circt::firrtl::FEnumType">;

def AggregateType : FIRRTLDialectType<
  Or<[
    CPred<"$_self.isa<FVectorType>()">,
    CPred<"$_self.isa<BundleType>()">,
    CPred<"$_self.isa<FEnumType>()">
  ]>,
  "a aggregate type", "::circt::firrtl::FIRRTLBaseType">;

// TODO: When Refs can appear within Base, need to disallow that too.
def ConnectableType : FIRRTLDialectType<
    CPred<"$_self.isa<FIRRTLBaseType>()">,
    "a connectable type (base type)", "::circt::firrtl::FIRRTLType", [{
    Any type that is valid for use in connect statements.
    Currently this is any base type.
  }]>;

def SizedType : FIRRTLDialectType<CPred<"$_self.isa<FIRRTLBaseType>() && "
    "!$_self.cast<FIRRTLBaseType>().hasUninferredWidth()">,
    "a sized type (contains no uninferred widths)", "::circt::firrtl::FIRRTLType">;
def SizedOrForeignType : AnyTypeOf<[SizedType, ForeignType]>;

def UInt1Type : FIRRTLDialectType<
    CPred<"$_self.isa<UIntType>() && "
          "($_self.cast<UIntType>().getWidth() == 1 ||"
          " $_self.cast<UIntType>().getWidth() == std::nullopt)">,
    "UInt<1> or UInt", "::circt::firrtl::UIntType">;

def UInt32Type : FIRRTLDialectType<
    CPred<"$_self.isa<UIntType>() && "
          "$_self.cast<UIntType>().getWidth() == 32">,
    "UInt<32>", "::circt::firrtl::UIntType">;

def AsyncResetType : FIRRTLDialectType<
    CPred<"$_self.isa<AsyncResetType>()">,
    "AsyncReset", "::circt::firrtl::AsyncResetType">;

def ResetType : FIRRTLDialectType<
    CPred<"$_self.isa<ResetType>()">,
    "Reset", "::circt::firrtl::ResetType">;

def PassiveType : FIRRTLDialectType<
  CPred<"$_self.isa<FIRRTLBaseType>() && $_self.cast<FIRRTLBaseType>().isPassive()">,
  "a passive base type (contain no flips)", "::circt::firrtl::FIRRTLBaseType">;

def RefType : FIRRTLDialectType<
  CPred<"$_self.isa<RefType>()">,
   "reference type", "::circt::firrtl::RefType">;

def RWProbe : FIRRTLDialectType<
  CPred<"$_self.isa<RefType>() && $_self.cast<RefType>().getForceable()">,
   "rwprobe type", "::circt::firrtl::RefType">;

//===----------------------------------------------------------------------===//
// FIRRTL Types Predicates
//===----------------------------------------------------------------------===//

def OneBitType : FIRRTLDialectType<
 CPred<"($_self.isa<IntType>() && $_self.cast<IntType>().getWidth() == 1) || "
   "($_self.isa<AnalogType>() && $_self.cast<AnalogType>().getWidth() == 1)">,
 "UInt<1>, SInt<1>, or Analog<1>", "::circt::firrtl::FIRRTLBaseType">;


def AnyResetType : FIRRTLDialectType<
    CPred<"$_self.isa<FIRRTLBaseType>() && $_self.cast<FIRRTLBaseType>().isResetType()">,
    "Reset", "::circt::firrtl::FIRRTLBaseType">;

def AnyRegisterType : FIRRTLDialectType<
    CPred<"$_self.isa<FIRRTLBaseType>() && "
          "$_self.cast<FIRRTLBaseType>().isRegisterType()">,
    "a passive base type that does not contain analog",
    "::circt::firrtl::FIRRTLBaseType">;

def UIntSIntClockType : AnyTypeOf<[SIntType, UIntType, ClockType],
                                  "sint, uint, or clock",
                                  "::circt::firrtl::FIRRTLBaseType">;

def OneBitCastableType : AnyTypeOf<
  [OneBitType, AnyResetType, AsyncResetType, ClockType],
  "1-bit uint/sint/analog, reset, asyncreset, or clock",
                                  "::circt::firrtl::FIRRTLBaseType">;

//===----------------------------------------------------------------------===//
// Constraints on RefOps
//===----------------------------------------------------------------------===//

class RefTypeConstraint<string ref, string base>
  : TypesMatchWith<"reference base type should match",
                   ref, base,
                   "$_self.cast<RefType>().getType()">;

class RefResultTypeConstraint<string base, string ref>
  : TypesMatchWith<"reference base type should match",
                   base, ref,
                   "RefType::get($_self.cast<FIRRTLBaseType>().getPassiveType())">;

#endif // CIRCT_DIALECT_FIRRTL_FIRRTLTYPES_TD
