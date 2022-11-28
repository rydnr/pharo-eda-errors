Class {
	#name : #EDAEThrowError,
	#superclass : #EDAEErrorHandlingStrategy,
	#traits : 'EDACLogging',
	#classTraits : 'EDACLogging classTrait',
	#category : #'EDAE-Domain-Strategies'
}

{ #category : #accessing }
EDAEThrowError class >> description [

	^ #'pharoeda.errors.strategies.throwerror.description'
]

{ #category : #logging }
EDAEThrowError class >> shouldPersistFuel [
	^ false
]

{ #category : #'error handling' }
EDAEThrowError >> handleError: error withExtraContextInformation: aDictionary [
	"Handles the error"
	error signal
]
