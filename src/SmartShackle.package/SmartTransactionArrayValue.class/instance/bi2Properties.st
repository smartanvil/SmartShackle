as yet unclassified
bi2Properties
	^ value value
		collect: [ :b | 
			SmartValue new
				name: 'Tx- ' , b transactionIndex asString;
				value: b;
				yourself ]