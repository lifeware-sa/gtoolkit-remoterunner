Class {
	#name : #GtRrTestsJob,
	#superclass : #GtRrJob,
	#category : #'RemoteRunner-Model'
}

{ #category : #accessing }
GtRrTestsJob >> allItems [
	| allTests |

	allTests := OrderedCollection new.
	allTests addAll: testNames.
	classNames do: [ :className |
		className asClass testSelectors do: [ :selector |
			allTests add: className -> selector ] ].
	packageNames do: [ :packageName |
		packageName asPackage testSuite tests do: [ :test |
			allTests add: test class name -> test selector ] ].
	^ allTests
]