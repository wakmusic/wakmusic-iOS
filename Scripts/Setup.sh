if test -d "/opt/homebrew/bin/"; then
    PATH="/opt/homebrew/bin/:${PATH}"
fi

export PATH

if which swiftlint > /dev/null; then
  echo "✅ SwiftLint가 설치되어있어요."
else
  echo "❌ SwiftLint가 설치되어있지 않아요. SwiftLint 설치를 시작해요."
  brew install swiftlint
fi

if which swiftformat > /dev/null; then
  echo "✅ SwiftFormat이 설치되어있어요."
else
  echo "❌ SwiftFormat이 설치되어있지 않아요. SwiftFormat 설치를 시작해요."
  brew install swiftformat
fi

if which needle > /dev/null; then
  echo "✅ Needle이 설치되어있어요."
else
  echo "❌ Needle이 설치되어있지 않아요. Needle 설치를 시작해요."
  brew install needle
fi

if which tuist > /dev/null; then
  echo "✅ Tuist가 설치되어있어요."
else
  echo "❌ Tuist가 설치되어있지 않아요. Tuist 설치를 시작해요."
  curl https://mise.run | sh
  echo 'eval "$(~/.local/bin/mise activate --shims zsh)"' >> ~/.zshrc
  source ~/.zshrc

  mise install tuist
  tuist version
fi

if which carthage > /dev/null; then
  echo "✅ Carthage가 설치되어있어요."
else
  echo "❌ Carthage가 설치되어있지 않아요. Carthage 설치를 시작해요."
  brew install carthage
fi

echo "✅ 개발 환경 기본 세팅을 완료했어요!"

git config --local include.path ../.gitconfig
chmod 777 .githooks/*