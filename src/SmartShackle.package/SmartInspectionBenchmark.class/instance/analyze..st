generated
analyze: aBind
	| rslt |
	[ rslt := SmartInspect new
		instance: aBind;
		json ]
		on: Error
		do: [ :e | rslt := e ].
	results at: aBind put: rslt