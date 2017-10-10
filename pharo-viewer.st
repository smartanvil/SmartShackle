| contractsLocation gethURL address instance pwd |
contractsLocation := FileLocator contractsFolder.
gethURL := 'http://localhost:8545'.
[ FogCachedConnection currentOn: gethURL.
FogCache reset.
FogFileContractDescription
	loadKnownContracts: contractsLocation
	connection: FogCachedConnection currentConnection.
FogTransactionMonitorService
	reset;
	current ]
	on: Error
	do: [ :err | 
		UIManager default inform:'Error during configuration ' , err messageText. ].
address := Smalltalk arguments at: 2.
instance := FogConnection currentConnection findContractBindByHash: address blockTag: #latest. 
instance contract hasAst
	ifFalse: [ UIManager default inform:'Contract instance does not match any available source code'.].
(SmartInspect new
instance: instance;
yourself) inspect maximize.
