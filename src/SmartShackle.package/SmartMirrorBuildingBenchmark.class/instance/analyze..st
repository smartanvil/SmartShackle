generated
analyze: aFileReference
	| rslt |
	^ rawmode
		ifTrue: [ (FogFileContractDescription loadCode: aFileReference connection: FogConnection currentConnection) mirror ]
		ifFalse: [ [ rslt := (FogFileContractDescription loadCode: aFileReference connection: FogConnection currentConnection) mirror ]
				on: Error
				do: [ :e | rslt := e ].
			results at: aFileReference put: rslt ]