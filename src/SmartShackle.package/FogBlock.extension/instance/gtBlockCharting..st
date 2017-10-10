*SmartShackle
gtBlockCharting: composite
	<gtInspectorPresentationOrder: 0>
	^ composite roassal2
		title: 'Stats';
		initializeView: [ SmartCharts new blockBasedMultiChart: {self} ]