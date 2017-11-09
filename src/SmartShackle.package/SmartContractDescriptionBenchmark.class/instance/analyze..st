generated
analyze: aFileReference
	| rslt |
	[ rslt := FogFileContractDescription loadCode: aFileReference connection: FogConnection currentConnection ]
		on: Error
		do: [ :e | rslt := e ].
	results at: aFileReference put: rslt