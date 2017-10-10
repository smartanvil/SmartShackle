*SmartShackle
bi2Properties
	^ {(SmartValue new
		name: #Full;
		value: [ self isFull ]).
	(SmartValue new
		name: #'Gas used';
		value: [ self gasUsed ]).
	(SmartValue new
		name: #'Mined by';
		value: [ self miner ]).
	(SmartValue new
		name: #Nonce;
		value: [ self nonce ]).
	(SmartValue new
		name: #Number;
		value: [ self number ]).
	(SmartValue new
		name: #Hash;
		value: [ self privateBlockHash ]).
	(SmartValue new
		name: #Size;
		value: [ self size ]).
	(SmartValue new
		name: #Parent;
		value: [ self parent ]).
	(SmartBlockArrayValue new
		name: #Uncles;
		value: [ self uncles ]).
	(SmartValue new
		name: #Difficulty;
		value: [ self difficulty ]).
	(SmartValue new
		name: #Time;
		value: [ self timestamp ]).
	(SmartTransactionArrayValue new
		name: #Transactions;
		value: [ self transactions ])}