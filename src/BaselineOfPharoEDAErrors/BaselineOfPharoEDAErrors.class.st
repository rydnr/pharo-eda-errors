Class {
	#name : #BaselineOfPharoEDAErrors,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoEDAErrors
}

{ #category : #baselines }
BaselineOfPharoEDAErrors >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec blessing: #baseline.
			self includePharoEDACommon: spec.
			self declarePackagesIn: spec.
			self declareGroupsIn: spec ]
]

{ #category : #meta }
BaselineOfPharoEDAErrors >> declareGroupsIn: spec [
	spec
		group: 'core'
			with:
			#(#'EDAE-Domain');
		group: 'default' with: #('core')
]

{ #category : #meta }
BaselineOfPharoEDAErrors >> declarePackagesIn: spec [
	spec
		package: #'EDAE-Domain'
			with: [ spec requires: #('PharoEDACommon') ]
]

{ #category : #dependencies }
BaselineOfPharoEDAErrors >> includePharoEDACommon: spec [
	spec
		baseline: 'PharoEDACommon'
		with: [ spec repository: 'github://osoco/pharo-eda-common:main' ].
	^ spec

]
