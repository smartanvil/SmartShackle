initialization
initialize
	super initialize.
	results := Dictionary new.
	session := FogConnection currentConnection nonCachedSession .