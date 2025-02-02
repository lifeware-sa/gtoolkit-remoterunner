"
GtRrPseudoPharoLinkServerConnection provides enough functionality for the {{gtClass:GtRrInImageWorker}} to operate.  See examples using {{gtClass:GtRrInImageWorker}}.
"
Class {
	#name : #GtRrPseudoPharoLinkServerConnection,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer'
	],
	#category : #'RemoteRunner-Examples'
}

{ #category : #announcer }
GtRrPseudoPharoLinkServerConnection >> announcer [
	<return: #Announcer>

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #testing }
GtRrPseudoPharoLinkServerConnection >> isConnected [
	"GtRrPseudoPharoLinkServerConnection doesn't really know if it is running or not, answer true"

	^ true
]

{ #category : #accessing }
GtRrPseudoPharoLinkServerConnection >> remoteAddress [

	^ #[127 0 0 1]
]

{ #category : #accessing }
GtRrPseudoPharoLinkServerConnection >> remoteAddressString [

	^ GtRemoteRunner printIpAddress: self remoteAddress
]

{ #category : #initialization }
GtRrPseudoPharoLinkServerConnection >> setCloseOnExec: aBoolean [

]

{ #category : #'start-stop' }
GtRrPseudoPharoLinkServerConnection >> start [
	"Nothing to do"
]

{ #category : #'start-stop' }
GtRrPseudoPharoLinkServerConnection >> stop [
	"Nothing to do"
]
