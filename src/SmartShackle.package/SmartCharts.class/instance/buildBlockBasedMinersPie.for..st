block
buildBlockBasedMinersPie: pie for: blocksToAnalyze
	| es |
	pie interaction popup.
	pie
		objects:
			((blocksToAnalyze groupedBy: #miner) associations
				inject: OrderedCollection new
				into: [ :acc :asoc | 
					acc
						add:
							(SmartGroupedEntry new
								kind: (asoc key first: 5);
								ammount: asoc value size;
								yourself);
						yourself ]).
	es := pie slice: [ :v | v value amount ].
	pie labeled.
	pie normalizer
		elements: es;
		distinctColor.
	pie build.
	^ pie