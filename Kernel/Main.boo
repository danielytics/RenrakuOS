namespace Renraku.Kernel

import System
import Renraku.Apps

static class Kernel:
	def Main():
		Console.Init()
		MemoryManager.Init()
		ObjectManager.Init()
		InterruptManager()
		Drivers.Load()
		
		print 'Renraku initialized.'
		
		print 'Launching default app...'
		
		Shell()
	
	def Fault():
		print 'Fault.'
		
		while true:
			pass
