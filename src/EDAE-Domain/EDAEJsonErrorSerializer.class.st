Class {
	#name : #EDAEJsonErrorSerializer,
	#superclass : #EDACMessageSerializer,
	#instVars : [
		'context',
		'extraContextInformation'
	],
	#category : 'EDAE-Domain-Strategies'
}

{ #category : #'instance creation' }
EDAEJsonErrorSerializer class >> withContext: aContext andExtraContextInformation: aDictionary [
	^ self new context: aContext; extraContextInformation: aDictionary; yourself
]

{ #category : #accessing }
EDAEJsonErrorSerializer >> context [
	^ context
]

{ #category : #accessing }
EDAEJsonErrorSerializer >> context: aContext [
	context := aContext
]

{ #category : #customization }
EDAEJsonErrorSerializer >> customJsonMappingsFor: aJsonWriter [
	self print: Context inJsonWriter: aJsonWriter.
	EDADomainException
		allSubclassesDo: [ :cls | self printException: cls inJsonWriter: aJsonWriter ].
	EDACommand
		allSubclassesDo: [ :cls | self print: cls inJsonWriter: aJsonWriter ].
	EDAEventSourcingEvent
		allSubclassesDo: [ :cls | self print: cls inJsonWriter: aJsonWriter ].
		EDAAggregateRoot
				allSubclassesDo: [ :cls | self print: cls inJsonWriter: aJsonWriter ].

]

{ #category : #accessing }
EDAEJsonErrorSerializer >> extraContextInformation [
	^ extraContextInformation
]

{ #category : #accessing }
EDAEJsonErrorSerializer >> extraContextInformation: aDictionary [
	extraContextInformation := aDictionary
]

{ #category : #customization }
EDAEJsonErrorSerializer >> print: anObject inJsonWriter: aJsonWriter [
	aJsonWriter
		for: anObject
		customDo: [ :mapping |
			mapping
				encoder: [ :obj |
					| stream |
					stream := WriteStream on: String new.
					obj printOn: stream.
					stream contents ] ]
]

{ #category : #customization }
EDAEJsonErrorSerializer >> printException: anExceptionClass inJsonWriter: aJsonWriter [
	aJsonWriter
		for: anExceptionClass
		customDo: [ :mapping |
			mapping
				encoder: [ :cls |
					| stream |
					stream := WriteStream on: String new.
					cls description greaseString printOn: stream.
					stream contents ] ]

]

{ #category : #parsing }
EDAEJsonErrorSerializer >> serialize: anException [
	^ self serialize: anException withContext: self context andExtraContextInformation: self extraContextInformation
]

{ #category : #parsing }
EDAEJsonErrorSerializer >> serialize: anException withContext: aContext andExtraContextInformation: aDictionary [
	| result meta body |
	result := Dictionary new.
	meta := Dictionary new.
	meta at: #timestamp put: DateAndTime now asUTC rounded greaseString.
	meta at: #error put: anException greaseString.
	body := Dictionary newFrom: aDictionary.
	body at: #context put: aContext.
	result at: #meta put: meta.
	result at: #body put: body.
	^ String
		streamContents: [ :stream |
			| jsonWriter |
			jsonWriter := NeoJSONWriter on: stream.
			jsonWriter
				for: DateAndTime
				customDo: [ :mapping | mapping encoder: [ :tmst | tmst printString ] ].
			self customJsonMappingsFor: jsonWriter.
			jsonWriter nextPut: result ]
]
