generated
analyze: aFileReference
	| rslt |
	[ rslt := (self loadCode: aFileReference) contract newWith: {} ]
		on: Error
		do: [ :e | rslt := e ].
	results at: aFileReference put: rslt