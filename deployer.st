| account accountAddress contractName contract address contractsLocation gethURL contractInstance |
contractsLocation := FileLocator contractsFolder.
gethURL := 'http://localhost:8545'.
Smalltalk arguments size = 3
	ifFalse: [ FileStream stderr
			nextPutAll: 'Contract name and deployer account ID are not optional arguments';
			cr;
			nextPutAll: 'deploy.sh contractFileName account-id';
			cr.
		Smalltalk exit: 1 ].
contractName := Smalltalk arguments at: 2.
accountAddress := Smalltalk arguments at: 3.
account := FogExternalAccount new
	hash: accountAddress;
	name: 'DeployerAccount';
	yourself.
[ FogCachedConnection currentOn: gethURL.
FogCache reset.
FogFileContractDescription loadKnownContracts: contractsLocation  connection: FogCachedConnection currentConnection .
FogTransactionMonitorService
	reset;
	current ]
	on: Error
	do: [ :err | 
		FileStream stderr
			nextPutAll: 'Error during configuration ' , err messageText.
		Smalltalk exit: 1 ].
contract := FogCachedConnection currentConnection findContractDescriptionByName: contractName.
contractInstance := (contract mirror constructor
	applyOn: contract
	valueWithArguments: {}
	sender: account)
	waitIsReady;
	yourself.
FileStream stdout
	nextPutAll: 'Contract successfully deployed at address: ';
	nextPutAll: contractInstance address.
^ Smalltalk exit: 0
