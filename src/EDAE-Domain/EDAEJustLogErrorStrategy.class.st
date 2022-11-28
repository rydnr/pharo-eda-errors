"
Class: EDAEJustLoggingProjectionErrorHandlingStrategy

This class represents a concrete strategy when dealing with errors detected when projecting events.

Responsibility:

Any strategy must extend this class and implement #handleError:.

Collaborators:

Any EDAProjector processing events should react upon errors by retrieving the selected strategy and delegating the error to it.
The Settings framework allows the user to review and choose among all defined strategies.

Public API and Key Messages:

- handleError: to deal with the error itself.
- description (class side): to describe the main purpose of the strategy.
"
Class {
	#name : #EDAEJustLogErrorStrategy,
	#superclass : #EDAEErrorHandlingStrategy,
	#traits : 'EDACLogging',
	#classTraits : 'EDACLogging classTrait',
	#category : #'EDAE-Domain-Strategies'
}

{ #category : #accessing }
EDAEJustLogErrorStrategy class >> description [
	^ #'pharoeda.errors.strategies.justlog.description'
]

{ #category : #accessing }
EDAEJustLogErrorStrategy class >> shouldPersistFuel [
	^ false
]

{ #category : #'error handling' }
EDAEJustLogErrorStrategy >> handleError: anException withExtraContextInformation: aDictionary [
	| event projection |
	event := aDictionary at: #event ifAbsent: nil.
	projection := aDictionary at: #projection ifAbsent: nil.
	projection
		ifNil: [ | projections |
			projections := aDictionary
				at: #projections
				ifAbsent: OrderedCollection new.
			self
				logWarningMessage:
					(String streamContents: [ :s | s nextPutAll: 'Projection of event '; nextPutAll: event greaseString; nextPutAll: ' in projections '
						; nextPutAll: projections greaseString; nextPutAll: ' failed with error '
						; nextPutAll: anException description ])]
		ifNotNil: [ :arg |
			self
				logWarningMessage: (String streamContents: [ :s | s nextPutAll:
					'Projection of event '; nextPutAll: event greaseString; nextPutAll: ' in projection '
						; nextPutAll: projection greaseString; nextPutAll: ' failed with error '
						; nextPutAll: anException description ] )].
	^ false
]
