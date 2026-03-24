# Enable Powerlevel10k instant prompt. Should stay close to the top
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Better ls (requires eza)
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first'
alias la='eza -la --icons --group-directories-first'

# fzf integration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fuzzy cd functions using fzf + fd
cdf() {
  cd "$(fd -t d . | fzf)"
}

cdfa() {
  cd "$(fd -t d -H . ~ \
    -E .git \
    -E node_modules \
    -E Library \
    -E Applications \
    | fzf)"
}

# Print environment variables nicely
printenv() {
  local YELLOW=$'\033[33m'
  local BLUE=$'\033[34m'
  local GREEN=$'\033[32m'
  local DIM=$'\033[2m'
  local RESET=$'\033[0m'

  local -a lines user system process
  local name line

  lines=("${(@f)$(command printenv)}")

  for line in "${lines[@]}"; do
    name="${line%%=*}"

    case "$name" in
      SHLVL|SSH_*|TERM_SESSION_ID|P9K_*|_P9K_*|TTY|_|PPID|RANDOM|SECONDS|EPOCHSECONDS|EPOCHREALTIME)
        process+=("$line") ;;
      TMPDIR|TERM|TERM_PROGRAM|TERM_PROGRAM_VERSION|__CFBundleIdentifier|XPC_*|OSLogRateLimit|HOMEBREW_*|INFOPATH|MANPATH|LSCOLORS|LS_COLORS|COLORTERM|ZSH)
        system+=("$line") ;;
      *)
        user+=("$line") ;;
    esac
  done

  print_section() {
    local title="$1" color="$2"; shift 2
    local -a arr=("$@")
    arr=("${(@o)arr}")
    echo "${color}== ${title} ==${RESET}"
    (( ${#arr} )) && printf '%s\n' "${arr[@]}" || echo "${DIM}(none)${RESET}"
    echo
  }

  print_section "1) User-specific variables" "$YELLOW" "${user[@]}"
  print_section "2) System-specific variables" "$BLUE" "${system[@]}"
  print_section "3) Process/session variables" "$GREEN" "${process[@]}"
}

# Example user variables
export MY_VAR="hello"
export num8=9
export age=89

# Cross-platform stat alias
# macOS uses -f, Linux uses -c
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias pstat='stat -f "Owner: %Su | Group: %Sg | Perms: %Sp"'
else
  alias pstat='stat -c "Owner: %U | Group: %G | Perms: %A"'
fi

# pnpm setup
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Node setup (use nvm or system Node)
export PATH="$(npm bin -g):$PATH"

# Optional: if you manually installed Node somewhere, add here
# export PATH="$HOME/.local/bin/node:$PATH"
