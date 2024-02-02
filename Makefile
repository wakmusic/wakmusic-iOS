generate:
	tuist fetch
	TUIST_DEV=1 TUIST_ROOT_DIR=${PWD} tuist generate

test:
	TUIST_DEV=1 TUIST_ROOT_DIR=${PWD} tuist test

clean:
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

reset:
	tuist clean
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

feature:
	python3 Scripts/generate_new_feature.py
