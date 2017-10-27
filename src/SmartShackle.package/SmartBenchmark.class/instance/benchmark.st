benchmarking
benchmark
	(self class methods collect: #selector thenSelect: [ :s | s beginsWith: 'try' ]) do: [ :s | self perform: s ]