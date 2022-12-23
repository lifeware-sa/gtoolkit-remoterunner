Class {
	#name : #GtRrWorkerConnectionExceptionHandler,
	#superclass : #PharoLinkConnectionExceptionHandler,
	#category : #'RemoteRunner-Worker'
}

{ #category : #accessing }
GtRrWorkerConnectionExceptionHandler >> handleExceptionsDuring: aBlock [

	[ super handleExceptionsDuring: aBlock ]
		on: ConnectionClosed
		do: [ :ex |
			"Announce that we're exiting"
			GtRrWorkerOperationShutdownAnnouncement new emit.
			"Give other processes time to finish"
			Processor activeProcess priority: 15.
			Smalltalk snapshot: false andQuit: true ].
]