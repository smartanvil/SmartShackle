required
showableProperties
	^ mirror instanceMirror properties
		collect: [ :property | 
			SmartValue new
				name: property name;
				value: (property value: instance) ]