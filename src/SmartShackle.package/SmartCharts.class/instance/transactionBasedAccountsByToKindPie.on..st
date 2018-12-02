transactions
transactionBasedAccountsByToKindPie: transactions on: aView
	| pie es |
	pie := RTPieBuilder new.
	pie view: aView.
	pie interaction popup.
	pie
		objects:
			(((transactions collect: #to) groupedBy: #class) associations
				inject: OrderedCollection new
				into: [ :acc :asoc | 
					acc
						add:
							(SmartGroupedEntry new
								kind: asoc key kindOfAccount;
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