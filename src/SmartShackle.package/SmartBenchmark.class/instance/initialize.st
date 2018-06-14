initialization
initialize
	super initialize.
	results := Dictionary new.
	session := FogConnection createDefaultConnection nonCachedSession .