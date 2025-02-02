Class {
	#name : #GtRrJobStartupAndShutdown,
	#superclass : #Object,
	#instVars : [
		'remoteRunner'
	],
	#category : #'RemoteRunner-Runner'
}

{ #category : #accessing }
GtRrJobStartupAndShutdown >> remoteRunner [

	^ remoteRunner
]

{ #category : #accessing }
GtRrJobStartupAndShutdown >> remoteRunner: anObject [

	remoteRunner := anObject
]

{ #category : #'api - shutdown' }
GtRrJobStartupAndShutdown >> shutdown [ 
	"Perform any actions associated with stopping the DTS cluster:
	Subclasses can perform additional actions"

]

{ #category : #'api - shutdown' }
GtRrJobStartupAndShutdown >> shutdownJob: aJobContext [
	| job |

	remoteRunner removeCurrentlyExecutingJob: aJobContext id.
	job := aJobContext job.
	job markJobCompleted.
	remoteRunner announceAndLog: (GtRrJobCompletedAnnouncement job: job).
]

{ #category : #'api - startup' }
GtRrJobStartupAndShutdown >> startup [ 
	"Perform any actions associated with starting the RemoteRunner:
	Subclasses can perform additional actions"
]

{ #category : #'api - startup' }
GtRrJobStartupAndShutdown >> startupJob: aGtRrJobContext [
	"Perform actions to start the supplied job context.
	- Use the scheduler to group all the tests in to tasks.
	Must be called within sharedAccess."

	aGtRrJobContext 
		markJobStarted;
		submitTasks.
	remoteRunner timeoutManager addContext: aGtRrJobContext.

]
