if test -d "/opt/homebrew/bin/"; then
	PATH="/opt/homebrew/bin/:${PATH}"
fi

export PATH

if which needle > /dev/null; then
	ROOT= Projects/App/
	touch $ROOT/Sources/Application/NeedleGenerated.swift
	needle generate $ROOT/Sources/Application/NeedleGenerated.swift ../
else
	echo "warning: Needle not installed, plz run 'brew install needle'"
fi