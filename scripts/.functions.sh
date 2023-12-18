#!/opt/homebrew/bin/zsh

#-------------------------------------------------------------------------------
# CLI shortcuts (functions instead of alias to avoid slow startup (alias uses 'eval'))
# Note that * operator needs to be preceded with \
#-------------------------------------------------------------------------------
function copyssh() {
  pbcopy < $HOME/.ssh/id_rsa.pub
}
function reloadcli() {
  source $HOME/.zshrc
}
function reloaddns() {
  dscacheutil -flushcache && sudo killall -HUP mDNSResponder
}
function copyssh() {
  $(brew --prefix coreutils)/libexec/gnubin/ls -ahlF --color --group-directories-first
}
function cleanupds() {
  find . -type f -name '*.DS_Store' -ls -delete
}

# https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/
function get_user_shell() {
    dscl . -read /Users/$USER UserShell
}

# we want homebrew Zsh : /opt/homebrew/bin/zsh (for M1 versions)
function set_user_shell() {
    local shell_path=$(which $1)
    chsh -s $shell_path $USER
    # below could be unnecessary but just in case (persists across reboots)
    sudo dscl . -create /Users/$USER UserShell $shell_path
}

#-------------------------------------------------------------------------------
# Simple calculator
# Note that * operator needs to be preceded with \
#-------------------------------------------------------------------------------

function cal() {
  local result="";
  result="$(printf "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')";

  if [[ "$result" == *.* ]]; then
    # improve the output for decimal numbers
    printf "$result" |
    sed -e 's/^\./0./'        `# add "0" for cases like ".5"` \
        -e 's/^-\./-0./'      `# add "0" for cases like "-.5"`\
        -e 's/0*$//;s/\.$//';  # remove trailing zeros
  else
    printf "$result";
  fi;
  printf "\n";
}

#-------------------------------------------------------------------------------
# Create a new directory and enter it
#-------------------------------------------------------------------------------

function mkd() {
  mkdir -p "$@" && cd "$_";
}

#-------------------------------------------------------------------------------
# Open man page as PDF
#-------------------------------------------------------------------------------

function manpdf() {
  man -t "${1}" | open -f -a /Applications/Preview.app/
}

#-------------------------------------------------------------------------------
# Extract many types of compressed packages
# Credit: http://nparikh.org/notes/zshrc.txt
#-------------------------------------------------------------------------------

extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)  tar -jxvf "$1"                        ;;
      *.tar.gz)   tar -zxvf "$1"                        ;;
      *.bz2)      bunzip2 "$1"                          ;;
      *.dmg)      hdiutil mount "$1"                    ;;
      *.gz)       gunzip "$1"                           ;;
      *.tar)      tar -xvf "$1"                         ;;
      *.tbz2)     tar -jxvf "$1"                        ;;
      *.tgz)      tar -zxvf "$1"                        ;;
      *.zip)      unzip "$1"                            ;;
      *.ZIP)      unzip "$1"                            ;;
      *.pax)      cat "$1" | pax -r                     ;;
      *.pax.Z)    uncompress "$1" --stdout | pax -r     ;;
      *.Z)        uncompress "$1"                       ;;
      *) echo "'$1' cannot be extracted/mounted via extract()" ;;
    esac
  else
     echo "'$1' is not a valid file to extract"
  fi
}

#-------------------------------------------------------------------------------
# Create a data URL from a file
#-------------------------------------------------------------------------------

function dataurl() {
  local mimeType=$(file -b --mime-type "$1");
  if [[ $mimeType == text/* ]]; then
    mimeType="${mimeType};charset=utf-8";
  fi
  echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

#-------------------------------------------------------------------------------
# UTF-8-encode a string of Unicode symbols
#-------------------------------------------------------------------------------

function escape() {
  printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u);
  # print a newline unless we’re piping the output to another program
  if [ -t 1 ]; then
    echo ""; # newline
  fi;
}

#-------------------------------------------------------------------------------
# Decode \x{ABCD}-style Unicode escape sequences
#-------------------------------------------------------------------------------

function unidecode() {
  perl -e "binmode(STDOUT, ':utf8'); print \"$@\"";
  # print a newline unless we’re piping the output to another program
  if [ -t 1 ]; then
    echo ""; # newline
  fi;
}

#-------------------------------------------------------------------------------
# Get a character’s Unicode code point
#-------------------------------------------------------------------------------

function codepoint() {
  perl -e "use utf8; print sprintf('U+%04X', ord(\"$@\"))";
  # print a newline unless we’re piping the output to another program
  if [ -t 1 ]; then
    echo ""; # newline
  fi;
}

#-------------------------------------------------------------------------------
# `s` with no arguments opens the current directory in Sublime Text, otherwise
# opens the given location
#-------------------------------------------------------------------------------

function s() {
  if [ $# -eq 0 ]; then
    subl .;
  else
    subl "$@";
  fi;
}

#-------------------------------------------------------------------------------
# `o` with no arguments opens the current directory, otherwise opens the given
# location
#-------------------------------------------------------------------------------

function o() {
  if [ $# -eq 0 ]; then
    open .;
  else
    open "$@";
  fi;
}

#-------------------------------------------------------------------------------
# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
#-------------------------------------------------------------------------------

function tre() {
  tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

#-------------------------------------------------------------------------------
# Highlight
#-------------------------------------------------------------------------------

function hl() {
  if [[ "$1" && "$2" ]]
    then
      if [[ -z "$3" ]]; then FONTSIZE=24; else FONTSIZE=$3; fi;
      highlight -O rtf $1 --syntax $2 --font D2Coding --style solarized-dark \
          --font-size $FONTSIZE | pbcopy
    else
      echo "\033[31mError: missing required arguments.\033[0m"
      echo "Usage: "
      echo "  hl filename syntax [fontsize]"
    fi
}

#-------------------------------------------------------------------------------
# Docker
#-------------------------------------------------------------------------------

function dip() {
  docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
}

dsm() {
	docker stop $1 && docker rm $1
}

drm() {
  docker rm -f $(docker ps -a --format "{{.ID}}")
}

drmi() {
  docker rmi -f $(docker images -a --format "{{.ID}}")
}

dvrm() {
  docker volume rm -f $(docker volume ls -q)
}

dprune() {
  docker system prune --force
}

dreset() {
  drm
  drmi
  dprune
  dvrm
}

drun() {
	docker run --rm -t -i $@
}

drund() {
	docker run -d --name $@ $@
}

dbash() {
	if [ $# -lt 1 ] ; then
	  echo "Please provide a container id or name. Usage: docker-exec-bash <containerIdOrName>"
	else
		docker exec -it $1 bash
	fi
}

dps() {
	docker exec $1 ps -f
}

dlogs() {
  docker logs -f $1
}

#-------------------------------------------------------------------------------
# IP check
#-------------------------------------------------------------------------------

function myip() {
  curl -s "http://checkip.dyndns.org/" | grep -o "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]" | head -1
}

#-------------------------------------------------------------------------------
# Release Versions
#-------------------------------------------------------------------------------

function version() {
  BRANCH=`git rev-parse --abbrev-ref HEAD`
  HASH=`git show --pretty='format:%h' | head -1`
  echo $BRANCH~$HASH
}


#-------------------------------------------------------------------------------
# AWS CLI (aws, awslocal Localstack)
#-------------------------------------------------------------------------------
# params
# $1: queue name
# $1: message body (JSON)
awslocal_sqs_send_message() {
  LOCALHOST_QUEUE_NAME="$1"
  MESSAGE_JSON="$2"
  awslocal sqs send-message --queue-url "http://localhost:4566/000000000000/$1" --message-body "$2"
}

#-------------------------------------------------------------------------------
# View contents of file
#-------------------------------------------------------------------------------

peek() {
  fzf --preview '[[ $(file --mime {}) =~ binary ]] &&
    echo {} is a binary file ||
    (bat --style=numbers --color=always {} ||
     highlight -O ansi -l {} ||
     coderay {} ||
     rougify {} ||
     cat {}) 2> /dev/null | head -500'
}


#-------------------------------------------------------------------------------
# eza frequent function (modern ls)
#-------------------------------------------------------------------------------

# eza tree
function lt() {
  eza -al --tree --level="${1}"
}

#-------------------------------------------------------------------------------
# tmux convenience functions
#-------------------------------------------------------------------------------

# FZF search for tmux sessions list (when in detached shell)
tmux-fzf() {
    tmux attach -t $(tmux ls | awk -F':' '{print $1}' | fzf)
}

#-------------------------------------------------------------------------------
# GIT heart FZF <- FZF git functions as per (https://junegunn.kr/2016/07/fzf-git/)
#-------------------------------------------------------------------------------

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

git_curr_branch() {
  is_in_git_repo || return
  echo "$(git rev-parse --abbrev-ref HEAD)"
}

git_curr_url() {
  is_in_git_repo || return
  echo "$(git remote get-url origin)"
}

fzf-down() {
  fzf --height 50% "$@" --border
}

gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}

gb() {
  is_in_git_repo || return
  git branch --sort=-committerdate --color=always | grep -v '/HEAD\s' |
  fzf-down --ansi --multi --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

gba() {
  is_in_git_repo || return
  git branch -a --sort=-committerdate --color=always | grep -v '/HEAD\s' |
  fzf-down --ansi --multi --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1
}

gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}

# TODO: clashes vim-tmux-navigator mapping (BOTH gh() + gl())
gl() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}"
}

gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d$'\t' -f1
}

gsh() {
  # Push upstream to remote if none exist at 'origin'
  is_in_git_repo || return
  local curr_branch=$(git_curr_branch)
  local curr_url=$(git_curr_url)
  git ls-remote --exit-code --heads $curr_url $curr_branch > /dev/null 2>&1
  # Check exit code (0 if branch remote exists, 2 otherwise)
  if [[ "$?" = "0"  ]]; then
    # remote exists
    git push
  else
    # no remote exists -> create one for current
    git push --set-upstream origin $curr_branch
  fi
}

# Key-bindings
join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

bind-git-helper() {
  local c
  for c in $@; do
    eval "fzf-g$c-widget() { local result=\$(g$c | join-lines); zle reset-prompt; LBUFFER+=\$result }"
    eval "zle -N fzf-g$c-widget"
    eval "bindkey '^g^$c' fzf-g$c-widget"
  done
}
bind-git-helper f b t r l
unset -f bind-git-helper


# Symlinks
link() {
    local src=$1
    local dest=$2
    local dest_dir=$(dirname "$dest")

    # Create the directory if it does not exist
    mkdir -p "$dest_dir"

    # Create the symlink
    # echo "Creating symlink: $dest ---pointer--> $src"
    ln -nfs "$src" "$dest"
}

sudo_link() {
    local src=$1
    local dest=$2
    local dest_dir=$(dirname "$dest")

    # Create the directory if it does not exist
    mkdir -p "$dest_dir"

    # Create the symlink
    # echo "Creating symlink: $dest ---pointer--> $src"
    sudo ln -nfs "$src" "$dest"
}

#-------------------------------------------------------------------------------
# dropbox
#-------------------------------------------------------------------------------
# Ignore file/folder from sync (Selective Sync) -> https://help.dropbox.com/sync/ignored-files
# NOTE: The icon beside your file or folder will change to a gray minus sign indicating that it has been ignored.
dropbox_sync_ignore() {
    local ignore_path=$1
    xattr -d 'com.apple.fileprovider.ignore#P' "$1"
    xattr -d 'com.apple.fileprovider.ignore#P' "$1"
}


#-------------------------------------------------------------------------------
# FZF
#-------------------------------------------------------------------------------
# ripgrep_fzf_search_file() {
#     # 1. Search for text in files using Ripgrep
#     # 2. Interactively narrow down the list using fzf
#     # 3. Open the file in Vim
#     rg --color=always --line-number --no-heading --smart-case "${*:-}" |
#     fzf --ansi \
#         --color "hl:-1:underline,hl+:-1:underline:reverse" \
#         --delimiter : \
#         --preview 'bat --color=always {1} --highlight-line {2}' \
#         --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
#         --bind 'enter:become(vim {1} +{2})'
# }

# ripgrep_fzf_search_file
# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#switching-to-fzf-only-search-mode
ripgrep_fzf_search_file() {
    # Two-phase filtering with Ripgrep and fzf
    #
    # 1. Search for text in files using Ripgrep
    # 2. Interactively restart Ripgrep with reload action
    #    * Press alt-enter to switch to fzf-only filtering
    # 3. Open the file in Vim
    # 4. Switch between Ripgrep launcher mode (CTRL-R) and fzf filtering mode (CTRL-F)
    rm -f /tmp/rg-fzf-{r,f}
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
    INITIAL_QUERY="${*:-}"
    : | fzf --ansi --disabled --query "$INITIAL_QUERY" \
        --bind "start:reload($RG_PREFIX {q})+unbind(ctrl-r)" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(2. fzf> )+enable-search+rebind(ctrl-r)+transform-query(echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f)" \
        --bind "ctrl-r:unbind(ctrl-r)+change-prompt(1. ripgrep> )+disable-search+reload($RG_PREFIX {q} || true)+rebind(change,ctrl-f)+transform-query(echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r)" \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --prompt '1. ripgrep> ' \
        --delimiter : \
        --header '╱ CTRL-R (ripgrep mode) ╱ CTRL-F (fzf mode) ╱' \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
        # --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        # --bind 'enter:become(vim {1} +{2})'
}