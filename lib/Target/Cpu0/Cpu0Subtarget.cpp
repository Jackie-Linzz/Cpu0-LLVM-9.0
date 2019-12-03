
#include "llvm/Support/MathExtras.h"



#include "Cpu0Subtarget.h"

#include "Cpu0MachineFunction.h"
#include "Cpu0.h"
#include "Cpu0RegisterInfo.h"

#include "Cpu0TargetMachine.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/TargetRegistry.h"


using namespace llvm;

#define DEBUG_TYPE "cpu0-subtarget"

#define GET_SUBTARGETINFO_TARGET_DESC
#define GET_SUBTARGETINFO_CTOR
#include "Cpu0GenSubtargetInfo.inc"

static cl::opt<bool> EnableOverflowOpt
                ("cpu0-enable-overflow", cl::Hidden, cl::init(false),
                 cl::desc("Use trigger overflow instructions add and sub \
                 instead of non-overflow instructions addu and subu"));

static cl::opt<bool> UseSmallSectionOpt
                ("cpu0-use-small-section", cl::Hidden, cl::init(false),
                 cl::desc("Use small section. Only work when -relocation-model="
                 "static. pic always not use small section."));

static cl::opt<bool> ReserveGPOpt
                ("cpu0-reserve-gp", cl::Hidden, cl::init(false),
                 cl::desc("Never allocate $gp to variable"));

static cl::opt<bool> NoCploadOpt
                ("cpu0-no-cpload", cl::Hidden, cl::init(false),
                 cl::desc("No issue .cpload"));

bool Cpu0ReserveGP;
bool Cpu0NoCpload;

extern bool FixGlobalBaseReg;

void Cpu0Subtarget::anchor() { }



//@1 {
Cpu0Subtarget::Cpu0Subtarget(const Triple &TT, const std::string &CPU,
                             const std::string &FS, bool little, 
                             const Cpu0TargetMachine &_TM) :
    //@1 }
    // Cpu0GenSubtargetInfo will display features by llc -march=cpu0 -mcpu=help
    Cpu0GenSubtargetInfo(TT, CPU, FS), IsLittle(little), TargetTriple(TT), TM(_TM), TSInfo(),
    InstrInfo(Cpu0InstrInfo::create(initializeSubtargetDependencies(CPU, FS, TM))),
    FrameLowering(Cpu0FrameLowering::create(*this)),
    TLInfo(Cpu0TargetLowering::create(TM, *this)) {
  
  EnableOverflow = EnableOverflowOpt;
  // Set UseSmallSection.
  UseSmallSection = UseSmallSectionOpt;
  Cpu0ReserveGP = ReserveGPOpt;
  Cpu0NoCpload = NoCploadOpt;
}

bool Cpu0Subtarget::isPositionIndependent() const {
  return TM.isPositionIndependent();
}

Cpu0Subtarget &
Cpu0Subtarget::initializeSubtargetDependencies(StringRef CPU, StringRef FS,
                                               const TargetMachine &TM) {
  if (TargetTriple.getArch() == Triple::cpu0 || TargetTriple.getArch() == Triple::cpu0el) {
    if (CPU.empty() || CPU == "generic") {
      CPU = "cpu032II";
    }
    else if (CPU == "help") {
      CPU = "";
      return *this;
    }
    else if (CPU != "cpu032I" && CPU != "cpu032II") {
      CPU = "cpu032II";
    }
  }
  else {
    errs() << "!!!Error, TargetTriple.getArch() = " << TargetTriple.getArch()
           <<  "CPU = " << CPU << "\n";
    exit(0);
  }
  
  if (CPU == "cpu032I")
    Cpu0ArchVersion = Cpu032I;
  else if (CPU == "cpu032II")
    Cpu0ArchVersion = Cpu032II;

  if (isCpu032I()) {
    HasCmp = true;
    HasSlt = false;
  }
  else if (isCpu032II()) {
    HasCmp = true;
    HasSlt = true;
  }
  else {
    errs() << "-mcpu must be empty(default:cpu032II), cpu032I or cpu032II" << "\n";
  }

  // Parse features string.
  ParseSubtargetFeatures(CPU, FS);
  // Initialize scheduling itinerary for the specified CPU.
  InstrItins = getInstrItineraryForCPU(CPU);

  return *this;
}

bool Cpu0Subtarget::abiUsesSoftFloat() const {
//  return TM->Options.UseSoftFloat;
  return true;
}

const Cpu0ABIInfo &Cpu0Subtarget::getABI() const { return TM.getABI(); }

