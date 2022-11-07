"
Class: EDAELaunchDebuggerProjectionErrorHandlingStrategy

This strategy launches the default debugger when an error is detected while projecting events.

Responsibility:

To launch the debugger to help figuring out how to fix bugs.

Collaborators:

The settings framework is responsible to allow the user to choose among the available strategy implementations.

Public API and Key Messages:

See EDAEProjectionErrorHandlingStrategy
"
Class {
	#name : #EDAELaunchDebuggerErrorStrategy,
	#superclass : #EDAEErrorHandlingStrategy,
	#classInstVars : [
		'errors'
	],
	#category : #'EDAE-Domain-Strategies'
}

{ #category : #accessing }
EDAELaunchDebuggerErrorStrategy class >> annotateError: anError [
	self errors add: anError
]

{ #category : #accessing }
EDAELaunchDebuggerErrorStrategy class >> description [
	^ 'Launch debugger'
]

{ #category : #accessing }
EDAELaunchDebuggerErrorStrategy class >> errors [
	^ errors
]

{ #category : #accessing }
EDAELaunchDebuggerErrorStrategy class >> errors: aCollection [
	errors := aCollection
]

{ #category : #'class initialization' }
EDAELaunchDebuggerErrorStrategy class >> initialize [
	self errors: OrderedCollection new
]

{ #category : #'error handling' }
EDAELaunchDebuggerErrorStrategy >> handleError: anException withExtraContextInformation: aDictionary [
	anException freeze.
	self class annotateError: anException.
	anException signal.
	^ true
]
