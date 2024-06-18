if test -d "/opt/homebrew/bin/"; then
	PATH="/opt/homebrew/bin/:${PATH}"
fi

export PATH

if which needle > /dev/null; then

	ROOT_PATH="Projects/App"

	if [ $# -eq 0 ]; then #로컬 
		needle generate Sources/Application/NeedleGenerated.swift ../
	else #ci
		touch "${ROOT_PATH}/Sources/Application/NeedleGenerated.swift"
		needle generate ${ROOT_PATH}/Sources/Application/NeedleGenerated.swift ../
	fi

else
	echo "warning: Needle not installed, plz run 'brew install needle'"
fi