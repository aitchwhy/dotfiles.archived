# dotfiles

서버 개발에 필요한 OS X 머신을 빠르게 셋업하기 위한 자동화 스트립트입니다.

## 1. Xcode 설치

Xcode와 같이 설치되는 CLI Tool이 필요합니다. 앱 스토어를 방문해서 Xcode를 설치합니다.

설치가 끝나면 맥 기본 터미널을 열어 다음 명령을 입력합니다.

```bash
~ $ sudo xcodebuild -license # 콘솔에서 라이선스 동의하기
~ $ xcode-select --install   # Command Line Tool 설치
```

## 2. 깃 사용자 등록

SSH 키를 생성하고 깃허브에 등록하고 이 저장소를 클론하는 과정은 생략합니다.

https://help.github.com/articles/connecting-to-github-with-ssh/

## 3. dotfiles 설치

이 저장소의 dotfiles 폴더를 사용자 홈 폴더로 복사 또는 이동합니다. `.`이 숨김 파일들이 잘 복사되었는지 꼭 확인해야 합니다.

```bash
~ $ mv /path/to/prime-utility/dotfiles ./

~ $ tree dotfiles -L 1
~/dotfiles
├── .aliases            # 별칭 모음 (e.g. ll 등)
├── .export             # 환경 변수 모음
├── .functions          # 함수 모음
├── .gitconfig          # Global git 설정
├── .gitignore_global   # 글로벌 gitignore
├── .path               # 경로 모음
├── .zshrc              # Zsh Profile
├── Brewfile            # Homebrew Bundler용 레지스트리 파일
└── bootstrap.sh        # 메인 스크립트
```

## 4. dotfiles 실행

먼저 사용할 셸을 `zsh`로 변경해 놓습니다.

```bash
~ $ sudo echo "" >> /etc/shells && sudo echo "/usr/local/bin/zsh" >> /etc/shells
```

필요한 파일을 열어 깃 사용자 정보를 변경하고 저장합니다.

```bash
# ~/dotfiles/bootstrap.sh

CODE_DIR=$HOME/workspace
GIT_USER_NAME="foo"
GIT_EMAIL="foo@bar.com"
```

이제 모든 준비가 끝났습니다. dotfiles를 실행합니다.

```bash
~/dotfiles $ bash bootstrap.sh
```

자동 설치 과정이 끝나고 나면 OS X 머신을 재부팅해 줍니다.

## 5. 유지 보수

더 이상 dotfiles를 유지보수하지 않을 것이라면 삭제하셔도 무방합니다.

바이너리나 애플리케이션의 설치 삭제등을 계속 추적하고 다른 OS X 머신에서도 동일한 환경을 사용하려면 `~/dotfiles` 폴더를 별도 저장소로 등록하고, `~/dotfiles/Brewfile`을 지속적으로 관리하면 됩니다.

