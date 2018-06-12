generated
analyze: aFileReference
	| rslt |
	^ rawmode
		ifTrue: [ (FogFileContractDescription loadCode: aFileReference session: session) mirror ]
		ifFalse: [ [ rslt := (FogFileContractDescription loadCode: aFileReference session: session) mirror ]
				on: Error
				do: [ :e | rslt := e ].
			results at: aFileReference put: rslt ]