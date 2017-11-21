benchmarking
benchmark
	| futures |
	rawmode := false.
	results size > 0
		ifFalse: [ futures := (SmartBenchmark methods collect: #selector thenSelect: [ :s | s beginsWith: 'try' ]) collect: [ :s | [ self perform: s ] future ].
			futures do: [ :f | f synchronizeTimeout: 1 minute ] ]