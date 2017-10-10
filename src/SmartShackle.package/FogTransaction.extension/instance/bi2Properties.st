*SmartShackle
bi2Properties
	^ {(SmartValue new
		name: #Timestamp;
		value: [ self block timestamp ]).
	(SmartValue new
		name: #From;
		value: [ self from ]).
	(SmartValue new
		name: #To;
		value: [ self to ]).
	(SmartValue new
		name: #Index;
		value: [ self transactionIndex ]).
	(SmartValue new
		name: #Block;
		value: [ self block ])}