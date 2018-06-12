generated
analyze: aFileReference
	| rslt |
	[ rslt := (FogFileContractDescription loadCode: aFileReference session: session) mirror instanceMirror ]
		on: Error
		do: [ :e | rslt := e ].
	results at: aFileReference put: rslt