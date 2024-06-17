if test -d "/opt/homebrew/bin/"; then
	PATH="/opt/homebrew/bin/:${PATH}"
fi

export PATH

if which needle > /dev/null; then
	ROOT_PATH="Projects/App"
	touch "${ROOT_PATH}/Sources/Application/NeedleGenerated.swift"
	needle generate ${ROOT_PATH}/Sources/Application/NeedleGenerated.swift ../
else
	echo "warning: Needle not installed, plz run 'brew install needle'"
fi