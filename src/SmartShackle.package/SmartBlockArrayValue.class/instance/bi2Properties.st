as yet unclassified
bi2Properties
	^ value value
		collect: [ :b | 
			SmartValue new 
				name: b number;
				value: b;
				yourself ]