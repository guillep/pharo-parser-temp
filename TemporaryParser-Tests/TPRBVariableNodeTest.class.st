"
SUnit tests for RBVariableNode
"
Class {
	#name : #TPRBVariableNodeTest,
	#superclass : #TPRBParseTreeTest,
	#category : #'TemporaryParser-Tests-Nodes'
}

{ #category : #tests }
TPRBVariableNodeTest >> testStartForReplacement [

	| source tree dTemporary |
	source := 'foo
	|a b c de d|
	de := 4'.
	tree := self parseMethod: source.
	dTemporary := tree body temporaries last.
	self assert: dTemporary name equals: #d.
	self assert: (source copyFrom: dTemporary start to: dTemporary stop) equals: 'd'.
	self assert: (source copyFrom: dTemporary startForReplacement to: dTemporary stop) equals: ' d'.
	self assert: (dTemporary start - dTemporary startForReplacement) equals: 1
]

{ #category : #tests }
TPRBVariableNodeTest >> testStartForReplacement02 [

	| source tree dTemporary |
	source := 'foo
	|a b c de 
	
d|
	de := 4'.
	tree := self parseMethod: source.
	dTemporary := tree body temporaries last.
	self assert: dTemporary name equals: #d.
	self assert: (source copyFrom: dTemporary start to: dTemporary stop) equals: 'd'.
	self assert: (source copyFrom: dTemporary startForReplacement to: dTemporary stop) equals: ' 
	
d'.
	self assert: (dTemporary start - dTemporary startForReplacement) equals: 4
]
