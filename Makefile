generate:
	tuist fetch
	tuist generate

clean:
	tuist clean
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

graph:
	tuist graph -t -d
