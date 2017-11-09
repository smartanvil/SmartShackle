benchmarking
benchmark
	(SmartBlockArrayValue methods collect: #selector thenSelect: [ :s | s beginsWith: 'try' ]) do: [ :s | self perform: s ].
	^ self result