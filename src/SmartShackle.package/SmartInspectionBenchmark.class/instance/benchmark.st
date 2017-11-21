generated
benchmark
	| futures |
	results size > 0
		ifFalse: [ futures := FogCache current contractInstances do: [ :i | [ self analyze: i ] future ].
			futures do: [ :f | f synchronizeTimeout: 1 minute ] ]