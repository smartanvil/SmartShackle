as yet unclassified
inspect: aHash withDescription: aFileReference
	| description mirror instanceMirror inspection fetch |
	[ description := FogFileContractDescription loadCode: aFileReference connection: FogConnection currentConnection ]
		on: Error
		do: [ :e | description := e ].
	[ mirror := description mirror ]
		on: Error
		do: [ :e | mirror := e ].
	[ instanceMirror := mirror instanceMirror ]
		on: Error
		do: [ :e | instanceMirror := e ].
	[ fetch := FogConnection currentConnection findContractBindByHash: aHash blockTag: #latest.
	fetch contract binary = '0x0'
		ifTrue: [ fetch := 'Unavailable Contract ' ]
		ifFalse: [ fetch contract: description ] ]
		on: Error
		do: [ :e | fetch := e ].
	[ inspection := SmartInspect new
		instance: fetch;
		json;
		yourself ]
		on: Error
		do: [ :e | inspection := e ].
	results
		at: aHash
		put:
			{description.
			mirror.
			instanceMirror.
			inspection.
			fetch}