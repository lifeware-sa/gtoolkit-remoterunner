Class {
	#name : #GtRrLocalManagerStartupAndShutdown,
	#superclass : #GtRrManagerStartupAndShutdown,
	#instVars : [
		'watchDog',
		'watchdogSemaphore',
		'processes',
		'poolSize'
	],
	#category : #'RemoteRunner-Runner'
}

{ #category : #initialization }
GtRrLocalManagerStartupAndShutdown >> initialize [

	super initialize.
	poolSize := 2.
	processes := OrderedCollection new.
	watchdogSemaphore := Semaphore new.
]

{ #category : #testing }
GtRrLocalManagerStartupAndShutdown >> isRunning [

	^ watchDog isNotNil
]

{ #category : #private }
GtRrLocalManagerStartupAndShutdown >> newWorkerLocalProcess [
	| settings args |

	self flag: 'TODO settings should come from outside'.
	settings := LanguageLinkSettings pharoDefaultSettings.
	args := OrderedCollection new.
	args
		add: settings serverImage fullName;
		add: 'clap';
		add: 'remoteRunnerWorker'.
	remoteRunner debugMode ifTrue: [ args add: '--log' ].
	args
		add: '--taskPollForever';
		add: '--serverSocketAddress';
		add: remoteRunner port asString;
		add: '--detachChangesFromFileSystem'.
	^ GtSubprocessWithInMemoryOutput new
		  command: settings serverExecutable fullName;
		  arguments: args;
		  workingDirectory: settings workingDirectory resolve fullName;
		  terminateOnShutdown;
		  yourself
]

{ #category : #accessing }
GtRrLocalManagerStartupAndShutdown >> poolSize [

	^ poolSize
]

{ #category : #accessing }
GtRrLocalManagerStartupAndShutdown >> poolSize: anInteger [

	poolSize := anInteger
]

{ #category : #'startup - shutdown' }
GtRrLocalManagerStartupAndShutdown >> shutdown [ 

	self isRunning ifFalse: [ ^ self ].
	[ watchDog terminate ]
		on: ProcessAlreadyTerminating
		do: [ "noop" ].
	watchDog := nil.
	processes
		do: #terminate;
		removeAll.
	super shutdown.

]

{ #category : #'running tests' }
GtRrLocalManagerStartupAndShutdown >> signalWatchdog [
	"Signal the watchdog to check immediately.
	Used for testing."

	watchdogSemaphore signal.
]

{ #category : #private }
GtRrLocalManagerStartupAndShutdown >> startWatchDog [

	watchDog := [ [ | broken |
		watchdogSemaphore waitTimeoutSeconds: 30.
		broken := processes reject: #isRunning.
		broken do: [ :e | | process |
			process := self newWorkerLocalProcess.
			process run.
			processes
				remove: e;
				add: process.
			GtRrWatchdogTrace new
				failedProcess: e;
				newProcess: process;
				emit ].
		 ] repeat ] forkNamed:
			'GtRemoteRunner local watch dog'
]

{ #category : #'startup - shutdown' }
GtRrLocalManagerStartupAndShutdown >> startup [ 

	self assert: processes isEmpty.
	self assert: self isRunning not.
	super startup.

	self startWatchDog.
	poolSize timesRepeat: [ 
		| process |
		process := self newWorkerLocalProcess.
		process run.
		processes add: process ]
]