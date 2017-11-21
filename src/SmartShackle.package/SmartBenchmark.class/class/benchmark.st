benchmarking
benchmark
	| is |  is := {SmartContractDescriptionBenchmark.
	SmartMirrorBuildingBenchmark.
	SmartInstanceMirrorBuildingBenchmark.
	SmartProxyGenerationBuildingBenchmark.
	SmartContractDeployBenchmark.
	SmartInspectionBenchmark} collect: [ :c | c instance ].
	is do: [ :i | i benchmark ].
	^ is