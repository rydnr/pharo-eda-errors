"
**Class**

I'm a baseline to load PharoEDA Errors.

**Responsibilities**

Guide Metacello to load PharoEDA-Errors with its dependencies.

**Collaborators**

Metacello
"
Class {
	#name : #BaselineOfPharoEDAErrors,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoEDAErrors
}

{ #category : #meta }
BaselineOfPharoEDAErrors class >> declareGroupsIn: spec [
	spec
		group: 'core'
			with:
			#(#'EDAE-Domain');
		group: 'default' with: #('core')
]

{ #category : #meta }
BaselineOfPharoEDAErrors class >> declarePackagesIn: spec [
	spec
		package: #'EDAE-Domain'
			with: [ spec requires: #('PharoEDACommon') ]
]

{ #category : #dependencies }
BaselineOfPharoEDAErrors class >> includePharoEDACommon: spec [
	spec
		baseline: 'PharoEDACommon'
		with: [ spec repository: 'github://rydnr/pharo-eda-common:main' ].
	^ spec

]

{ #category : #baselines }
BaselineOfPharoEDAErrors >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec blessing: #baseline.
		spec postLoadDoIt: #postload:package:.
		self class includePharoEDACommon: spec;
		 declarePackagesIn: spec;
		 declareGroupsIn: spec ]
]

{ #category : #hooks }
BaselineOfPharoEDAErrors >> postload: loader package: packageSpec [

	Locale localeID: 'es'.
	(IceRepository registry
		 detect: [ :each | each name = 'pharo-eda-errors' ]
		 ifNone: nil) ifNotNil: [ :repo |
		| location |
		location := repo location.
		EDACIconProvider addDefaultLocation:
			location / 'resources' / 'icons'.
		EDACTranslationProvider addDefaultLocation:
			location / 'resources' / 'l10n'.
		NaturalLanguageTranslator current:
			EDACCompositeTranslationProvider wrapCurrent ]
]
