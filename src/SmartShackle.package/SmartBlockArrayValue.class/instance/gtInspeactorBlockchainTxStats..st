as yet unclassified
gtInspeactorBlockchainTxStats: composite
"	<gtInspectorPresentationOrder: 0>"
	^ composite roassal2
		title: 'Stats Tx ';
		initializeView: [ SmartCharts new transactionsBasedMultiChart: (value flatCollect: #transactions) ]