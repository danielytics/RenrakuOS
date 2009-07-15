namespace Renraku.Kernel

static class Kernel:
	def Main():
		Console.Init()
		MemoryManager.Init()
		ObjectManager.Init()
		InterruptManager()
		Drivers.Load()
		
		print 'Renraku initialized.'
	
	def Fault():
		print 'Fault.'
		
		while true:
			pass