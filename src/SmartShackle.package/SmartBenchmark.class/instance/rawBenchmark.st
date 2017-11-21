benchmarking
rawBenchmark
	rawmode := true .
	(SmartBenchmark methods collect: #selector thenSelect: [ :s | s beginsWith: 'try' ]) collect: [ :s | self perform: s  ]