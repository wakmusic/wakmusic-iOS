generate:
	tuist fetch
	TUIST_ENV=DEV TUIST_ROOT_DIR=${PWD} tuist generate

test:
	TUIST_ENV=DEV TUIST_ROOT_DIR=${PWD} tuist test

clean:
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

reset:
	tuist clean
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

feature:
	python3 Scripts/generate_new_feature.py

pg:
	swift Scripts/GeneratePlugin.swift

module:
	swift Scripts/GenerateModule.swift