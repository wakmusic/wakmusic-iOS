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
	echo "\033[0;31m이 명령어는 deprecated 되었습니다. 'make module'을 사용해주세요! \033[0m"
	python3 Scripts/generate_new_feature.py

pg:
	swift Scripts/GeneratePlugin.swift

module:
	swift Scripts/GenerateModule.swift

setup:
	sh Scripts/Setup.sh

format:
	swiftformat ./Projects --config .swiftformat