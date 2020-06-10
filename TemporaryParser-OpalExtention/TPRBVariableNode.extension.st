Extension { #name : #TPRBVariableNode }

{ #category : #'*TemporaryParser-OpalExtention' }
TPRBVariableNode >> binding [
	^self propertyAt: #binding ifAbsent: [nil].
]

{ #category : #'*TemporaryParser-OpalExtention' }
TPRBVariableNode >> binding: aSemVar [
	aSemVar ifNil: [^self removeProperty: #binding ifAbsent: []].
	self propertyAt: #binding put: aSemVar.
]

{ #category : #'*TemporaryParser-OpalExtention' }
TPRBVariableNode >> isArg [

	^self binding isArg
]

{ #category : #'*TemporaryParser-OpalExtention' }
TPRBVariableNode >> isArgOrTemp [
	^self binding isTemp
]

{ #category : #'*TemporaryParser-OpalExtention' }
TPRBVariableNode >> isClean [
	^ (self isInstance | self isSpecialVariable) not
]

{ #category : #'*TemporaryParser-OpalExtention' }
TPRBVariableNode >> isGlobal [
	^self binding isGlobal
]

{ #category : #'*TemporaryParser-OpalExtention' }
TPRBVariableNode >> isInstance [
	^self binding isInstance
]

{ #category : #'*TemporaryParser-OpalExtention' }
TPRBVariableNode >> isSpecialVariable [
	^ self binding isSpecialVariable
]

{ #category : #'*TemporaryParser-OpalExtention' }
TPRBVariableNode >> isUndeclared [

	^self binding isUndeclared
]