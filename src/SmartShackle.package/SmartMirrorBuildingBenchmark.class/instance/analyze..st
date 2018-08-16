generated
analyze: aFileReference
	| rslt |
	^ rawmode
		ifTrue: [ (self loadCode: aFileReference) mirror ]
		ifFalse: [ [ rslt := (self loadCode: aFileReference) mirror ]
				on: Error
				do: [ :e | rslt := e ].
			results at: aFileReference put: rslt ]