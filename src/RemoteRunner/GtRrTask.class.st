Class {
	#name : #GtRrTask,
	#superclass : #Object,
	#instVars : [
		'startTime',
		'endTime',
		'workerIpAddress',
		'result',
		'taskId',
		'errorDetails',
		'state',
		'taskTimeout'
	],
	#category : #'RemoteRunner-Tasks'
}

{ #category : #accessing }
GtRrTask class >> leJsonV4Name [

	^ #remoteRunnerWorkerTask
]

{ #category : #accessing }
GtRrTask >> endTime [

	^ endTime
]

{ #category : #accessing }
GtRrTask >> endTime: anObject [

	endTime := anObject
]

{ #category : #accessing }
GtRrTask >> errorDetails [

	^ errorDetails
]

{ #category : #accessing }
GtRrTask >> errorDetails: aGtErrorDetails [
	"Set the error details of the receiver.
	Asynchronous events may cause multiple attempts at setting the details, use the first one"

	errorDetails ifNotNil: [ ^ self ].
	errorDetails := aGtErrorDetails
]

{ #category : #ui }
GtRrTask >> gtResultFor: aView [

	<gtView>
	result ifNil: [ ^ aView empty ].

	^ aView forward
		  title: 'Result';
		  priority: 20;
		  object: [ result ];
		  actionUpdateButton
]

{ #category : #ui }
GtRrTask >> gtSummaryFor: aView [

	<gtView>
	^ aView columnedList
		  title: 'Summary';
		  priority: 10;
		  items: [ self summaryAttributes ];
		  column: #Attribute text: [ :item | item key ];
		  column: #Value text: [ :item | item value ];
		  actionUpdateButton
]

{ #category : #testing }
GtRrTask >> hasCompleted [

	^ state = #completed or: [ state = #terminated ]
]

{ #category : #testing }
GtRrTask >> hasErrors [
	"Answer a boolean indicating if the receiver failed to execute successfully"

	^ errorDetails isNotNil
]

{ #category : #accessing }
GtRrTask >> initialize [

	super initialize.
	taskId := UUID new asString.
	state := #notStarted.
]

{ #category : #running }
GtRrTask >> markTaskCancelled [
	"Mark the receiver cancelled.
	Cancellation is specifically terminating the task before it was started."

	endTime := DateAndTime now.
	errorDetails := (GtRrErrorDetails new
		errorMessage: 'Task cancelled before execution';
		setTrace).
	state := #cancelled.
]

{ #category : #running }
GtRrTask >> markTaskCompleted [

	endTime := DateAndTime now.
	state := #completed.
]

{ #category : #running }
GtRrTask >> markTaskStarted [

	startTime := DateAndTime now.
	state := #started.
]

{ #category : #running }
GtRrTask >> markTaskTerminated [

	endTime := DateAndTime now.
	state := #terminated.
]

{ #category : #running }
GtRrTask >> markTaskTerminating [

	state := #terminating.
]

{ #category : #printing }
GtRrTask >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		<< self state.
	self hasErrors ifTrue:
		[ aStream << ' with errors' ].
	aStream nextPut: $).
]

{ #category : #accessing }
GtRrTask >> result [

	^ result
]

{ #category : #accessing }
GtRrTask >> result: anObject [

	result := anObject
]

{ #category : #accessing }
GtRrTask >> run [

	self subclassResponsibility
]

{ #category : #accessing }
GtRrTask >> startTime [

	^ startTime
]

{ #category : #accessing }
GtRrTask >> startTime: anObject [

	startTime := anObject
]

{ #category : #accessing }
GtRrTask >> state [
	"Answer a Symbol indicating the inferred state of the receiver.
	One of: #notStarted, #started, #cancelled, #terminating, #terminated, #completed.
	The errorDetails are used to determine if the task completed successfully, why and where it was terminated, etc."

	^ state
]

{ #category : #private }
GtRrTask >> state: aSymbol [
	"Set the state.
	Only used by object serialisation"
	
	state := aSymbol
]

{ #category : #ui }
GtRrTask >> summaryAttributes [
	"Answer a collection of key/value attributes that can simply be listed as a summary of the receiver"

	^ Array streamContents: [ :stream |
		stream nextPut: #State -> self state.
		self hasErrors ifTrue:
			[ stream nextPut: #Error -> errorDetails errorMessage ].
		startTime ifNotNil:
			[ stream nextPut: #Started -> startTime ].
		endTime ifNotNil:
			[ stream nextPut: #Ended -> endTime ].
		stream nextPut: #ID -> taskId.
		stream nextPut: 'Worker IP Address' -> workerIpAddress ]
]

{ #category : #accessing }
GtRrTask >> taskId [

	^ taskId
]

{ #category : #accessing }
GtRrTask >> taskId: anObject [

	taskId := anObject
]

{ #category : #accessing }
GtRrTask >> taskTimeout [
	<return: #Duration>

	^ taskTimeout
]

{ #category : #accessing }
GtRrTask >> taskTimeout: aDuration [

	taskTimeout := aDuration
]

{ #category : #accessing }
GtRrTask >> workerIpAddress [

	^ workerIpAddress
]

{ #category : #accessing }
GtRrTask >> workerIpAddress: anObject [

	workerIpAddress := anObject
]