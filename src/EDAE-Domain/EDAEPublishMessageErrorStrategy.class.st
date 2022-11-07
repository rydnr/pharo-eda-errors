"
Class: EDAEErrorAsEventStrategy

This strategy generates and publishes an event when an error is detected when processing a command.

Responsibility:

To produce an event representing the error detected.

Collaborators:

The settings framework is responsible to allow the user to choose among the available strategy implementations.

Public API and Key Messages:

See EDAECommandErrorHandlingStrategy
"
Class {
	#name : #EDAEPublishMessageErrorStrategy,
	#superclass : #EDAEErrorHandlingStrategy,
	#classInstVars : [
		'topicPublisher'
	],
	#category : #'EDAE-Domain-Strategies'
}

{ #category : #accessing }
EDAEPublishMessageErrorStrategy class >> description [
	^ #'pharoeda.errors.strategies.publishmessage.description'
]

{ #category : #accessing }
EDAEPublishMessageErrorStrategy class >> topicPublisher [
	^ topicPublisher
]

{ #category : #accessing }
EDAEPublishMessageErrorStrategy class >> topicPublisher: aTopicPublisher [
	topicPublisher := aTopicPublisher
]

{ #category : #'error handling' }
EDAEPublishMessageErrorStrategy >> handleError: anError withExtraContextInformation: aDictionary [
	| serializer message |
	serializer := EDAEJsonErrorSerializer
		withContext: thisContext clone
		andExtraContextInformation: aDictionary.
	message := serializer serialize: anError greaseString.
	EDAAEventStompTopicPublisher new publishError: message
]
