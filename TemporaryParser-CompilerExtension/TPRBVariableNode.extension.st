Extension { #name : #TPRBVariableNode }

{ #category : #'*TemporaryParser-CompilerExtension' }
TPRBVariableNode >> binding [
	^self propertyAt: #binding ifAbsent: [nil].
]

{ #category : #'*TemporaryParser-CompilerExtension' }
TPRBVariableNode >> binding: aSemVar [
	aSemVar ifNil: [^self removeProperty: #binding ifAbsent: []].
	self propertyAt: #binding put: aSemVar.
]
