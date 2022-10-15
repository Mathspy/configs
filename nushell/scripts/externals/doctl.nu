export def "doctl droplets list" [] {
	^doctl compute droplet list --output json | from json
}
