
|  contractsLocation gethURL address instance pwd |

" Configuration of the specific image "

contractsLocation :=  FileLocator contractsFolder.
gethURL := 'http://localhost:8545'.


" Setting of configuration and load of sources "
[
	FogCachedConnection currentOn: gethURL.
	FogCache reset. 
	FogFileContractDescription loadKnownContracts: contractsLocation  connection: FogCachedConnection currentConnection .
	FogTransactionMonitorService reset; current. 
] on: Error do: [ :err | 
	FileStream stderr nextPutAll: 'Error during configuration ' , err messageText.
	Smalltalk exit: 1. 
].

" Execution "
"[" 
	address := Smalltalk arguments at:2.
	instance := FogConnection currentConnection findContractBindByHash: address blockTag: #latest. 
	instance contract hasAst ifFalse: [ 
		FileStream stderr nextPutAll: 'Contract instance does not match any available source code'; cr.
		Smalltalk exit: 1. 
	].
	FileStream stdout nextPutAll: (SmartInspect new instance: instance; yourself ) html; cr.
	Smalltalk exit: 0. 
"] on: Error do: [ :err | 
	FileStream stderr nextPutAll: 'Error generating output ', err messageText.
 ].
"






