namespace Renraku.Kernel

import System.Collections.Generic

class EventHandler:
	eventObject as object
	handler as callable
	
	def constructor (e as object, h as callable):
		event = e
		handler = h

public class Capsule:
	# Each capsule has a reference to a single context.
	CurrentContext as Context
	# A capsule may have zero or more tasks.
	Tasks as List [of Task]
	# A capsule may have zero or more event handlers
	Handlers as List [of EventHandler]
	
	public Service [id as string] as IService:
		get:
			return CurrentContext.GetService(id)
		
	def GetContext () as Context:
		return CurrentContext
	
	def constructor (ctx as Context):
		CurrentContext = ctx
		Tasks = List()
		Handlers = List()
	
	private _CreateTask (taskServ as ITaskProvider, task as TaskCallable, arguments as (object), run as bool) as Task:
		task = taskServ.NewTask(task, arguments)
		Tasks.Add(task)
		if run:
			task.Start()
		return task
	
	def CreateTask (task as TaskCallable, arguments as (object), run as bool) as Task:
		taskServ = cast(ITaskProvider, Service['task'])
		return _CreateTask(taskServ, task, arguments, run)
		
	def CreateTask (task as TaskCallable, run as bool) as Task:
		return CreateTask(task, null, run)
	
	def CreateTasks (tasks as (TaskCallable), arguments as ((object)), run as bool) as (Task):
		numTasks = len(tasks)
		if arguments is null:
			arguments = array((object), len(tasks))
		elif numTasks != len(arguments):
			return array(Task, 0)
		
		taskObjs = array(Task, numTasks)
		taskServ = cast(ITaskProvider, Service['task'])
		for index in range(numTasks):
			taskObjs[index] = _CreateTask(taskServ, tasks[index], arguments[index], run)
		
	def CreateTasks (tasks as (TaskCallable), run as bool) as (Task):
		return CreateTasks(tasks, null, run);
	
	def CreateAndRunTask (task as TaskCallable):
		CreateTask(task, true)
	
	def CreateAndRunTask (task as TaskCallable, arguments as (object)):
		CreateTask(task, arguments, true)
	
	def RegisterEvent (eventObject as object, handler as callable):
		eventHandler = EventHandler(eventObject, handler)
		Handlers.Add(eventHandler)
		eventObject.Add(handler)
	