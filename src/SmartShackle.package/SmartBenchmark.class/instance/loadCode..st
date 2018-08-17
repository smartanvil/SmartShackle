generated
loadCode: aFileReference
	^ (session loadPackageForCode: aFileReference readStream upToEnd named: #benchmark)
		descriptions anyOne