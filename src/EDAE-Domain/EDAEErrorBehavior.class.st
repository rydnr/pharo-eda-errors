Class {
	#name : #EDAEErrorBehavior,
	#superclass : #Object,
	#traits : 'EDACPrintOnHelper',
	#classTraits : 'EDACPrintOnHelper classTrait',
	#classInstVars : [
		'strategy'
	],
	#category : #'EDAE-Domain-Behaviors'
}

{ #category : #accessing }
EDAEErrorBehavior class >> strategy [
	^ strategy
]

{ #category : #accessing }
EDAEErrorBehavior class >> strategy: aStrategy [
	strategy := aStrategy
]
