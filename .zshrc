# ~/.zshrc — converted from .bashrc for Zsh on macOS
# (DISCLAIMER: never used zsh before, this was converted by ChatGPT)

# Return if not running interactively
[[ $- != *i* ]] && return

# --- History settings ---
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
setopt APPEND_HISTORY
setopt SHARE_HISTORY

# --- Auto window size update ---
setopt CHECK_WINSIZE

# --- Less filter (macOS may use /usr/bin/lesspipe.sh) ---
if [[ -x /usr/bin/lesspipe.sh ]]; then
  eval "$(SHELL=/bin/zsh lesspipe.sh)"
fi

# --- Detect chroot (keep for compatibility; optional on macOS) ---
if [[ -z "$debian_chroot" && -r /etc/debian_chroot ]]; then
  debian_chroot=$(< /etc/debian_chroot)
fi

# --- Prompt setup ---
autoload -Uz colors && colors

# Check for color terminal
if [[ "$TERM" == (xterm-color|*-256color) ]]; then
  color_prompt=yes
else
  color_prompt=no
fi

# Use color prompt by default
force_color_prompt=yes

if [[ "$force_color_prompt" == yes && "$color_prompt" == yes ]]; then
  # You can also use gitstatus or vcs_info for git branch
  autoload -Uz vcs_info
  precmd() { vcs_info }
  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:git:*' formats ' (%b)'

  PROMPT='%F{cyan}%n%F{green}@%m%f:%F{blue}%~%F{red}${vcs_info_msg_0_}%f$ '
else
  PROMPT='%n@%m:%~$ '
fi
unset color_prompt force_color_prompt

# --- Set terminal title for xterm and iTerm2 ---
case "$TERM" in
  xterm*|rxvt*|screen*|tmux*)
    precmd() { print -Pn "\e]0;%n@%m: %~\a" }
    ;;
esac

# --- Enable colorized ls, grep, etc. ---
if (( $+commands[dircolors] )); then
  if [[ -r ~/.dircolors ]]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
else
  # macOS ls uses BSD flags
  alias ls='ls -G'
  alias grep='grep --color=auto'
fi

# --- ls aliases ---
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# --- Alert alias (using macOS notification) ---
alert() {
  if [[ $? == 0 ]]; then
    osascript -e 'display notification "Command finished successfully" with title "Terminal"'
  else
    osascript -e 'display notification "Command failed" with title "Terminal"'
  fi
}

# --- Load extra aliases if present ---
if [[ -f ~/.bash_aliases ]]; then
  source ~/.bash_aliases
fi

# --- Completion system ---
autoload -Uz compinit
compinit

# Enable some completion features
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''

# Optional: add Homebrew completions
if [[ -d /opt/homebrew/share/zsh-completions ]]; then
  FPATH="/opt/homebrew/share/zsh-completions:$FPATH"
fi

# --- End of file ---
