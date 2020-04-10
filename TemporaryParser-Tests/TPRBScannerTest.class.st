"
SUnit tests for RBScanner
"
Class {
	#name : #TPRBScannerTest,
	#superclass : #TestCase,
	#category : #'TemporaryParser-Tests-Parser'
}

{ #category : #initialize }
TPRBScannerTest >> buildScannerForText: source [
	^ self scannerClass on: source readStream
]

{ #category : #initialize }
TPRBScannerTest >> scannerClass [
	^ TPRBScanner
]

{ #category : #tests }
TPRBScannerTest >> testNextLiteralCharacterWithAMissingCharacter [
	| source scanner scannedToken |
	source := '$'.
	scanner := self buildScannerForText: source.
	scannedToken := scanner next.
	self verifyErrorToken: scannedToken message: 'A Character was expected' translated valueExpected: ''

]

{ #category : #tests }
TPRBScannerTest >> testNextWithAWrongSymbolGetError [
	| source scanner scannedToken |
	source := '#^'.
	scanner := self buildScannerForText: source.
	scannedToken := scanner next.
	self verifyErrorToken: scannedToken message: 'Expecting a literal type' translated valueExpected: '^'
]

{ #category : #tests }
TPRBScannerTest >> testNextWithAnIdentifierTokenGetTheIdentifierToken [
	| source scanner token |	
	source := 'identifierToken'.
	scanner := self buildScannerForText: source.
	token := scanner next.
	self assert: token isIdentifier.
	self deny: token isError.
	self assert: token value equals: source
]

{ #category : #tests }
TPRBScannerTest >> testNextWithAnOpeningCommentAtEndGetError [
	| source |	
	source := 'self "'.
	self should: [(self buildScannerForText: source) next] raise: SyntaxErrorNotification
]

{ #category : #tests }
TPRBScannerTest >> testNextWithAnOpeningCommentGetError [
	| source |	
	source := '"only the opening'.
	self should: [(self buildScannerForText: source) next] raise: SyntaxErrorNotification
]

{ #category : #tests }
TPRBScannerTest >> testNextWithAnOpeningStringsGetError [
	| source scannedToken |
	source := '''only the opening'.
	scannedToken := (self buildScannerForText: source) next.
	self verifyErrorToken: scannedToken message: 'Unmatched '' in string literal.' translated valueExpected: 'only the opening'
]

{ #category : #tests }
TPRBScannerTest >> testNextWithAnUnknownCharacterGetError [
	| source scanner scannedToken |	
	source := '¿'.
	scanner := self buildScannerForText: source.
	scannedToken := scanner next.
	self verifyErrorToken: scannedToken message: 'Unknown character' translated valueExpected: source
]

{ #category : #tests }
TPRBScannerTest >> testNextWithTwoDoubleQuotesInComment [
	| source token |
	source := '"only the"" opening"'.
	self
		shouldnt: [ token := (self buildScannerForText: source) next ]
		raise: SyntaxErrorNotification.
	self assert: token comments first equals: (1 to: source size)
]

{ #category : #tests }
TPRBScannerTest >> testNextWithTwoDoubleQuotesInCommentGetError [
	| source |
	source := '"only the"" opening'.
	self
		should: [ (self buildScannerForText: source) next ]
		raise: SyntaxErrorNotification
]

{ #category : #scanAnySymbol }
TPRBScannerTest >> testScanAnySymbolOnAlphabeticProduceLiteralToken [
	"This test is aimed at verifying the production a litteral token with the right properties when 	scanning alphabetic token"
		
	| token |
	token := (self buildScannerForText: 'alpha') scanAnySymbol.
	self assert: token isLiteralToken.
	self assert: token value equals: 'alpha'.
	"No need for further testing as scanAnySymbol uses scanSymbol to create token."
]

{ #category : #scanAnySymbol }
TPRBScannerTest >> testScanAnySymbolOnBinaryProduceLiteralToken [
	"This test is aimed at verifying the production a litteral token with the right properties when 	scanning binary character."
		
	| token |
	token := (self buildScannerForText: '=') scanAnySymbol.
	self assert: token isLiteralToken.
	self assert: token value equals: '='.
	"No need for further testing as scanAnySymbol uses 'scanBinary: TPRBLiteralToken' to create token."
]

{ #category : #scanAnySymbol }
TPRBScannerTest >> testScanAnySymbolOnNonAlphabeticNonBinaryProduceEOFToken [
	"This test is aimed at verifying the production a token marking the end of file with the right 	 	   	 properties when scanning non alphabetic non binary character."
		
	| token |
	token := (self buildScannerForText: '1') scanAnySymbol.
	self assert: token class equals: TPRBToken.
	
	token := (self buildScannerForText: '1alpha') scanAnySymbol.
	self assert: token class equals: TPRBToken.
	
	token := (self buildScannerForText: '1=') scanAnySymbol.
	self assert: token class equals: TPRBToken.
	
	token := (self buildScannerForText: '1 alpha') scanAnySymbol.
	self assert: token class equals: TPRBToken.
]

{ #category : #scanAnySymbol }
TPRBScannerTest >> testScanAnySymbolOnProduceOnlyFirstToken [
	"This test is aimed at verifying that scanAnySymbol only scan first token."
		
	| token |
	token := (self buildScannerForText: '= alpha') scanAnySymbol.
	self assert: token value equals: '='.
	
	token := (self buildScannerForText: 'alpha =') scanAnySymbol.
	self assert: token value equals: 'alpha'.
	
	token := (self buildScannerForText: '= +') scanAnySymbol.
	self assert: token value equals: '='.
	
	token := (self buildScannerForText: 'alpha beta') scanAnySymbol.
	self assert: token value equals: 'alpha'.
]

{ #category : #scanAnySymbol }
TPRBScannerTest >> testScanAnySymbolStartSendTo0 [
	"This test is aimed at verifying the start position of scanAnySymbol."
		
	| token |
	token := (self buildScannerForText: ' "wtf"  alpha   ') scanAnySymbol.
	self assert: token isLiteralToken.
	self assert: token value equals: 'alpha'.
	
	
]

{ #category : #scanAnySymbol }
TPRBScannerTest >> testScanAnySymbolTrimSeparators [
	"This test is aimed at verifying that scanAnySymbol trims the separators."
		
	| token |
	token := (self buildScannerForText: ' "wtf"  alpha   ') scanAnySymbol.
	self assert: token isLiteralToken.
	self assert: token value equals: 'alpha'.
	
	
]

{ #category : #'scanBinary:' }
TPRBScannerTest >> testScanBinaryTrimSeparators [
	"This test is aimed at verifying that scanAnySymbol trims the separators."
		
	| token |
	token := (self buildScannerForText: ' "wtf"  +-   ') scanBinary: TPRBLiteralToken.
	self assert: token isLiteralToken.
	self assert: token value equals: '+-'.
]

{ #category : #'scanBinary:' }
TPRBScannerTest >> testScanBinaryWithAnyValueToken [
	"This test is a reminder that you can feed any Token that has a value and a start variable, hence 	every RBValueToken.
	
	binaryCharacter ::= '!' | '%' | '&' | '*' | '+' | ',' | '/' | '<' | '=' | '>' | '?' | '@' | '\' | 							 							 '~' | '|' | '-'"
	| token tokens |
	tokens := {TPRBBinarySelectorToken. TPRBErrorToken. TPRBIdentifierToken. TPRBKeywordToken.        	 	           TPRBLiteralToken. TPRBMultiKeywordLiteralToken. TPRBNumberLiteralToken. 	   	  	 	  	   	 				  TPRBPatternBlockToken. TPRBSpecialCharacterToken.}.
	"Test the creation of a literal for every binary."
	tokens do: [:tok | 
		token := (self buildScannerForText: '!') scanBinary: tok.
					 self assert: token class equals: tok.
					 self assert: token value equals: '!'].
]

{ #category : #'scanBinary:' }
TPRBScannerTest >> testScanBinaryWithLitteralToken [
"This test is aimed at verifying the production a litteral token with the right properties when 	scanning binary character.
	
	binaryCharacter ::= '!' | '%' | '&' | '*' | '+' | ',' | '/' | '<' | '=' | '>' | '?' | '@' | '\' | 							 							 '~' | '|' | '-'"
	| token binary |
	binary := #('!' '%' '&' '*' '+' ',' '/' '<' '=' '>' '?' '@' '\' '~' '|' '-').
	"Test the creation of a literal for every binary."
	binary do: [:sbin | token := (self buildScannerForText: sbin) scanBinary: TPRBLiteralToken.
							  self assert: token isLiteralToken.
							  self assert: token value equals: sbin].
]

{ #category : #'scanBinary:' }
TPRBScannerTest >> testScanBinaryWithLitteralTokenWithNonBinaryCharacterForFirstValue [
	"This test is aimed at verifying the production a litteral token with the right properties when 	scanning non binary character as first character.
	
	binaryCharacter ::= '!' | '%' | '&' | '*' | '+' | ',' | '/' | '<' | '=' | '>' | '?' | '@' | '\' | 							 							 '~' | '|' | '-'"
	| token nonbinary |
	nonbinary := #('1' 'p' '^' 'é' '1=' '1=+').
	"Test the creation of a literal for every binary."
	nonbinary do: [:snbin | token := (self buildScannerForText: snbin) scanBinary: TPRBLiteralToken.
							  self assert: token isLiteralToken.
							  self assert: token value equals: snbin].
]

{ #category : #'scanBinary:' }
TPRBScannerTest >> testScanBinaryWithLitteralTokenWithNonBinaryValues [
"This test is aimed at verifying the production a litteral token with the right properties when 	scanning binary character.
	
	binaryCharacter ::= '!' | '%' | '&' | '*' | '+' | ',' | '/' | '<' | '=' | '>' | '?' | '@' | '\' | 							 							 '~' | '|' | '-'"
	| token nonbinary |
	nonbinary := #(#('1' '1') #('p' 'p') #('^' '^') #('1alpha' '1') #('11' '1') #('a b' 'a')).
	"Test the creation of a literal for every binary."
	nonbinary do: [:snbin | token := (self buildScannerForText: (snbin first)) scanBinary: 																											 					                                                                     TPRBLiteralToken.
							  self assert: token isLiteralToken.
							  self assert: token value equals: (snbin last)].
]

{ #category : #'scanError:' }
TPRBScannerTest >> testScanErrorWithMultipleCharacters [
	"This test is aimed at verifying that the value of the token is only the first character of the 	string."
	| token example |
	"List of strings to test the scanner on paired with the expected value."
	example := #(#('1a+' '1') #('1+a' '1') #('a1+' 'a') #('+1' '+') #('éa' 'é') #('a$' 'a')).
	example do: [:ex | token := (self buildScannerForText: ex first) scanError: 'Generic error message'.
	                             self assert: token isError.
	                             self assert: token value equals: ex last.
										 self assert: token cause equals: 'Generic error message'].
]

{ #category : #'scanError:' }
TPRBScannerTest >> testScanErrorWithSinglecharacter [
	"This test is aimed at checking on the production of the error token."
	| token example |
	example := #('1' 'a' '+' 'é' '$').
	"Test the creation of an for every type of character."
	example do: [:ex | token := (self buildScannerForText: ex) scanError: 'Generic error message'.
	                             self assert: token isError.
	                             self assert: token value equals: ex.
										 self assert: token cause equals: 'Generic error message'].
]

{ #category : #scanIdentifierOrKeyword }
TPRBScannerTest >> testScanIdentifierOrKeywordAsKeyword [
	"This test is aimed at verifying if a keyword followed by an argument is scanned, only the keyword 	     will be taken as value."
	| token str |
	str := #(#('alpha: arg' 'alpha:') #(': arg' ':') #('12: arg' '12:')
		      #('alpha12: arg' 'alpha12:') #('12alpha: arg' '12alpha:')).
	"Test the creation of a literal for every binary."
	str do: [:s | token := (self buildScannerForText: (s first)) scanIdentifierOrKeyword.
							  self assert: token isKeyword.
							  self assert: token value equals: (s last)].
]

{ #category : #scanIdentifierOrKeyword }
TPRBScannerTest >> testScanIdentifierOrKeywordAsMultipleKeywords [
	"This test is aimed at verifying if scanning multiple keywords gives the right token with the right 	 	 values."
	"| token str |
	str := #(#('alpha: arg beta: arg2' 'alpha:beta:') 
		      #('1alpha: arg 2beta1: arg2 3gamma: arg3' '1alpha:2beta:3gamma')
		      #('alpha1: beta1: arg2 alpha2: arg2 beta2: arg' 'alpha1:beta1:alpha2:beta2:')).
	str do: [:s | token := (self buildScannerForText: (s first)) scanIdentifierOrKeyword.
							  self assert: token isMultiKeyword.
							  self assert: token value equals: (s last)]."
						
	"Test delayed as it is using the start and stop positions which are not initialized."
]

{ #category : #scanIdentifierOrKeyword }
TPRBScannerTest >> testScanIdentifierOrKeywordIdentifier [
	"This test is aimed at verifying the creation of the special identifiers true, false, nil."
	| token |
	token := (self buildScannerForText: 'identifier') scanIdentifierOrKeyword.
				 self assert: token isIdentifier.
				 self assert: token value equals:'identifier'.
	token := (self buildScannerForText: '123456') scanIdentifierOrKeyword.
				 self assert: token isIdentifier.
				 self assert: token value equals: '123456'.
	token := (self buildScannerForText: '1d3nt1f13r') scanIdentifierOrKeyword.
				 self assert: token isIdentifier.
				 self assert: token value equals: '1d3nt1f13r'.
]

{ #category : #scanKeyword }
TPRBScannerTest >> testScanKeywordWithArguments [
	"This test is aimed at verifying if a keyword followed by an argument is scanned, only the keyword 	     will be taken as value."
	| token str |
	str := #(#('alpha: arg' 'alpha:') #(': arg' ':') #('12: arg' '12:')
		      #('alpha12: arg' 'alpha12:') #('12alpha: arg' '12alpha:')).
	"Test the creation of a literal for every binary."
	str do: [:s | token := (self buildScannerForText: (s first)) scanName. 
			        token := token scanKeyword.
							  self assert: token isKeyword.
							  self assert: token value equals: (s last)].
]

{ #category : #scanKeyword }
TPRBScannerTest >> testScanKeywordWithoutArguments [
	"This test is aimed at verifying if a keyword followed by an argument is scanned, only the keyword 	     will be taken as value."
	| token str |
	str := #('alpha:' ':' '12:' 'alpha12:' '12alpha:').
	"Test the creation of a literal for every binary."
	str do: [:s | token := (self buildScannerForText: s) scanName. 
			        token := token scanKeyword.
							  self assert: token isKeyword.
							  self assert: token value equals: s].
]

{ #category : #scanLiteral }
TPRBScannerTest >> testScanLiteralBeginningWithAlphabetic [
	""
	| token |
	token := (self buildScannerForText: '#alpha') scanLiteral.
	self assert: token isLiteralToken.
	self assert: token value equals: #alpha.
	

]

{ #category : #scanLiteral }
TPRBScannerTest >> testScanLiteralBeginningWithKeywords [
	""
	| token |
	token := (self buildScannerForText: '#alpha:') scanLiteral.
			self assert: token isLiteralToken.
			self assert: token value equals: #alpha:.
			
	token := (self buildScannerForText: '#alpha:beta:gamma:') scanLiteral.
			self assert: token isLiteralToken.
			self assert: token value equals: #'alpha:beta:gamma:'.
	
	token := (self buildScannerForText: '#alpha:beta:gamma:arg') scanLiteral.
			self assert: token isLiteralToken.
			self assert: token value equals: #'alpha:beta:gamma:arg'.
	
	

]

{ #category : #scanLiteralCharacter }
TPRBScannerTest >> testScanLiteralCharacterWithAnyCharacterType [
	"Literal character should be introduced by $"
	| token characters |
	"Each string to scan paired with their expected value"
	characters := #(#('$a' $a) #('$1' $1) #('$é' $é) #('$^' $^) #('$+' $+)).
	
	characters do: [:chara | token := (self buildScannerForText: (chara first)) scanLiteralCharacter.
											self assert: token isLiteralToken.
											self assert: token value equals: (chara last)].
]

{ #category : #scanLiteralCharacter }
TPRBScannerTest >> testScanLiteralCharacterWithMultipleCharacters [
	"Literal character should be introduced by $. Only one character should be scanned"
	| token characters |
	"Each string to scan paired with their expected value"
	characters := #(#('$alpha' $a) #('$1234' $1) #('$ép12' $é) #('$^a1' $^) #('$+3a' $+)).
	
	characters do: [:chara | token := (self buildScannerForText: (chara first)) scanLiteralCharacter.
											self assert: token isLiteralToken.
											self assert: token value equals: (chara last)].
]

{ #category : #scanLiteralCharacter }
TPRBScannerTest >> testScanLiteralCharacterWithoutSpecialCharacter [
	"Literal character should be introduced by $"
	| token |
	token := (self buildScannerForText: 'a') scanLiteralCharacter.
			self assert: token isError.
			self assert: token value equals: ''.
			self assert: token cause equals: 'A Character was expected'.
]

{ #category : #scanLiteral }
TPRBScannerTest >> testScanLiteralDoNotAllowDigits [
	""
	| token |
	token := (self buildScannerForText: '#1alpha') scanLiteral.
			self assert: token isError.
			self assert: token value equals: '1'.
			self assert: token cause equals: 'Expecting a literal type'.
]

{ #category : #scanLiteral }
TPRBScannerTest >> testScanLiteralDoNotAllowSpaces [
	""
	| token |
	token := (self buildScannerForText: '# alpha') scanLiteral.
			self assert: token isError.
			self assert: token value equals: ' '.
			self assert: token cause equals: 'Expecting a literal type'.
]

{ #category : #scanLiteralString }
TPRBScannerTest >> testScanLiteralStringUnfinishedRaiseError [
	"Literal character should be introduced by '."
	| token |
	token := (self buildScannerForText: '''alpha') scanLiteralString.
			self assert: token isError.
			self assert: token value equals: 'alpha'.
		   self assert: token cause equals: 'Unmatched '' in string literal.'.
		
	token := (self buildScannerForText: '''123') scanLiteralString.
			self assert: token isError.
			self assert: token value equals: '123'.
		   self assert: token cause equals: 'Unmatched '' in string literal.'.
]

{ #category : #scanName }
TPRBScannerTest >> testScanNameDoesNothingWhenWrongCharacter [
	"This test is for verifying that nothing is made when the current character is not of type 	   	 	 			 	 alphabetic or digit."
	| scanner nonAlphaNonDigit |
	nonAlphaNonDigit := #('^' '=' '^ aplha' '+ 23' '-21' 'alpha+' '12-').
	nonAlphaNonDigit do: [:tok | scanner := (self buildScannerForText: tok) scanName. 
							  			  self deny: scanner atEnd].
]

{ #category : #scanName }
TPRBScannerTest >> testScanNameWithRightCharacterScanEverything [
	"This test is for verifying that nothing is made when the current character is not of type 	   	 	 			 	 alphabetic or digit."
	| scanner nonAlphaNonDigit |
	nonAlphaNonDigit := #('1' 'a' '1a2' 'a1b' 'aa' 'bb').
	nonAlphaNonDigit do: [:tok | scanner := (self buildScannerForText: tok) scanName. 
							  			  self assert: scanner atEnd].
]

{ #category : #scanSpecialCharacter }
TPRBScannerTest >> testScanSpecialCharacterWithAnyOtherCharacter [
	""
	| token character |
	"Each string to scan paired with their expected value"
	character := #(#('a' $a) #('1' $1) #('é' $é) #('^' $^) #('+' $+)).
	
	character do: [:chara | token := (self buildScannerForText: (chara first)) scanSpecialCharacter.
										self assert: token isSpecial.
										self assert: token value equals: (chara last).].
]

{ #category : #scanSpecialCharacter }
TPRBScannerTest >> testScanSpecialCharacterWithAnyOtherCharacters [
	""
	| token characters |
	"Each string to scan paired with their expected value"
	characters := #(#('ab' $a) #('12' $1) #('éà' $é) #('^`' $^) #('+=' $+)).
	
	characters do: [:chara | token := (self buildScannerForText: (chara first)) scanSpecialCharacter.
										self assert: token isSpecial.
										self assert: token value equals: (chara last).].
]

{ #category : #scanSpecialCharacter }
TPRBScannerTest >> testScanSpecialCharacterWithAssignment [
	""
	| token |
	token := (self buildScannerForText: ':=') scanSpecialCharacter.
			self assert: token isAssignment.
]

{ #category : #scanSpecialCharacter }
TPRBScannerTest >> testScanSpecialCharacterWithSimpleColon [
	""
	| token |
	token := (self buildScannerForText: ':') scanSpecialCharacter.
			self assert: token isSpecial.
]

{ #category : #scanSpecialCharacter }
TPRBScannerTest >> testScanSpecialCharacterWithUnderscore [
	""
	| token |
	token := (self buildScannerForText: '_') scanSpecialCharacter.
			self assert: token isAssignment.
]

{ #category : #scanSymbol }
TPRBScannerTest >> testScanStringSymbolWithAlphabeticOrDigitOrColonCharacters [
	"Gives empty Literal Tokens."
	| token characters |
	characters := #('alpha' 'alph:' 'alph4' 'alp:a' ':lpha' ':lph4' 'a1:h:b3t:' ).
	
	characters do: [:chara | token := (self buildScannerForText: chara) scanSymbol.
										self assert: token isLiteralToken.
										self assert: token value equals: chara.].
]

{ #category : #scanSymbol }
TPRBScannerTest >> testScanStringSymbolWithNonAlphabeticNonColonFirstCharacters [
	"Gives empty Literal Tokens."
	| token characters |
	characters := #('1' '^`' '12' '+' '=+').
	
	characters do: [:chara | token := (self buildScannerForText: chara) scanSymbol.
										self assert: token isLiteralToken.
										self assert: token value equals: ''.].
]

{ #category : #scanSymbol }
TPRBScannerTest >> testScanStringSymbolWithNonAlphabeticNonDigitCharacters [
	"Gives empty Literal Tokens."
	| token characters |
	"Each string to scan paired with their expected value"
	characters := #('1' '^`' '12' '+' '=+').
	
	characters do: [:chara | token := (self buildScannerForText: chara) scanSymbol.
										self assert: token isLiteralToken.
										self assert: token value equals: ''.].
]

{ #category : #scanSymbol }
TPRBScannerTest >> testScanStringSymbolWithNonAlphabeticNonDigitCharactersBegginingWithColon [
	"Gives empty Literal Tokens."
	| token characters |
	"Each string to scan paired with their expected value"
	characters := #(':=' ':^`' ':12' ':+' ':=+').
	
	characters do: [:chara | token := (self buildScannerForText: chara) scanSymbol.
										self assert: token isLiteralToken.
										self assert: token value equals: ':'.].
]

{ #category : #'tests - creation api' }
TPRBScannerTest >> testScanTokenObjects1 [
	| inp exp |
	inp := 'Object subclass: #NameOfSubclass'.
	exp := {'Object'.
	'subclass:'.
	#NameOfSubclass asString}.
	self assert: ((self scannerClass scanTokenObjects: inp) collect: [ :each | each value ]) equals: exp.
	
]

{ #category : #'tests - creation api' }
TPRBScannerTest >> testScanTokenObjects2 [
	| inp exp |
	inp := 'classVariableNames: '''' "ha ha"
package: ''UndefinedClasses-Experiment'.
	exp := {'classVariableNames:' . '' . 'package:' . 'UndefinedClasses-Experiment'}.
	self assert: ((self scannerClass scanTokenObjects: inp) collect: [ :each | each value ]) equals: exp
]

{ #category : #'tests - creation api' }
TPRBScannerTest >> testScanTokens1 [
	| inp exp |
	inp := 'Object subclass: #NameOfSubclass'.
	exp := {'Object'.
	'subclass:'.
	#NameOfSubclass asString}.
	self assert: (self scannerClass scanTokens: inp) equals: exp.
	
]

{ #category : #'tests - creation api' }
TPRBScannerTest >> testScanTokens2 [
	| inp exp |
	inp := 'classVariableNames: '''' "ha ha"
package: ''UndefinedClasses-Experiment'.
	exp := {'classVariableNames:' . '' . 'package:' . 'UndefinedClasses-Experiment'}.
	self assert: (self scannerClass scanTokens: inp) equals: exp
]

{ #category : #utilities }
TPRBScannerTest >> verifyErrorToken: scannedToken message: message valueExpected: valueExpected [
	self assert: scannedToken isError.
	self assert: scannedToken cause equals: message.
	self assert: scannedToken value equals: valueExpected.
	self assert: scannedToken start equals: 1.
]
