baselines
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ spec blessing: #baseline.
			spec
				project: 'Roassal2'
				with: [ spec
						className: #ConfigurationOfRoassal2;
						version: #stable;
						repository: 'http://www.smalltalkhub.com/mc/ObjectProfile/Roassal2/main' ].
			spec baseline: 'FogLive' with: [ spec repository: 'github://smartanvil/Fog/src' ].
			spec package: #SmartShackle with: [ spec requires: #('FogLive' Roassal2) ] ]
