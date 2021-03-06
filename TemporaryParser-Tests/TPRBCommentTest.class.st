"
SUnit tests for RBComment
"
Class {
	#name : #TPRBCommentTest,
	#superclass : #TestCase,
	#category : #'TemporaryParser-Tests-Nodes'
}

{ #category : #tests }
TPRBCommentTest >> testIntersectsInterval [
	| node |
	node:= TPRBComment with: 'Some sample text' at: 5.
	
	self 
		assert: (node intersectsInterval: (4 to: 6)) description: 'either side of interval';
		assert: (node intersectsInterval: (4 to: 5)) description: 'before and on interval';
		assert: (node intersectsInterval: (5 to: 6)) description: 'and and after interval';
		assert: (node intersectsInterval: (5 to: 5)) description: 'on interval interval';
		assert: (node intersectsInterval: (1 to: 4)) not description: 'not in interval'
]
