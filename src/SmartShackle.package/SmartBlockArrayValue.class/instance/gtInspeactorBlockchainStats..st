as yet unclassified
gtInspeactorBlockchainStats: composite
	<gtInspectorPresentationOrder: 0>
	^ composite roassal2
		title: 'Stats';
		initializeView: [ SmartCharts new blockBasedMultiChart: value value ]