namespace Renraku.Compiler

import System
import System.IO

file = StreamWriter(File.OpenWrite('Obj/kernel.asm'))
Console.SetOut(file)

# Set up intrinsics
BooRuntimeIntrinsics()
InterruptIntrinsics()
ObjectIntrinsics()
PointerIntrinsics()
PortIntrinsics()
StringIntrinsics()

cilExp = Frontend.FromAssembly(argv[0])
cilExp = Blockifier.Blockify(cilExp)
cilExp = IntrinsicRunner.Apply(cilExp)
asmExp = X86.Compile(cilExp)
X86.Emit(asmExp)

file.Flush()
