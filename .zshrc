# Interactive shell config, shared across machines. Link it as ~/.zshrc.
# Machine-specific tools are guarded by existence checks, so the same file works
# everywhere. Environment and PATH live in .zprofile.

# Repo root, resolved through the ~/.zshrc symlink.
DOTFILES=${${(%):-%x}:A:h}

#
# Zsh options
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS
# Emacs keymap.
bindkey -e
# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

#
# Module configuration (must be set before Zim initializes)
#

# zsh-autosuggestions is the last module in .zimrc, so skip re-binding on each precmd.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

#
# Zim
#

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Completion dirs must be on fpath before Zim runs compinit.
[[ -d ~/.grok/completions/zsh ]] && fpath=(~/.grok/completions/zsh $fpath)

source ${ZIM_HOME}/init.zsh

# zsh-history-substring-search: up/down search history by prefix.
zmodload -F zsh/terminfo +p:terminfo
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key

#
# Completions
#

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

autoload -U +X bashcompinit && bashcompinit
(($+commands[aws_completer])) && complete -o nospace -C ${commands[aws_completer]} aws
(($+commands[terraform])) && complete -o nospace -C ${commands[terraform]} terraform
(($+commands[vault])) && complete -o nospace -C ${commands[vault]} vault

if (($+commands[helm])); then
  [[ -f ~/.zsh_helm_completion ]] || helm completion zsh > ~/.zsh_helm_completion
  source ~/.zsh_helm_completion
fi

if (($+commands[kubectl])); then
  [[ -f ~/.zsh_kubectl_completion ]] || kubectl completion zsh > ~/.zsh_kubectl_completion
  source ~/.zsh_kubectl_completion
  alias k="kubectl"
  complete -F __start_kubectl k
fi

#
# Tools installed on some machines only
#

if [[ -d ~/Library/pnpm ]]; then
  export PNPM_HOME=~/Library/pnpm
  [[ ":$PATH:" == *":$PNPM_HOME:"* ]] || export PATH="$PNPM_HOME:$PATH"
fi
[[ -d /opt/homebrew/opt/postgresql@16/bin ]] && export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
[[ -d ~/.grok/bin ]] && export PATH="$HOME/.grok/bin:$PATH"

#
# Aliases, functions and prompt
#

for f in $DOTFILES/zsh/*.zsh; do source $f; done
unset f

# Anything that shouldn't be shared (work-only, secrets-free tweaks) goes here.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Config: .config/starship.toml, linked to ~/.config/starship.toml.
(($+commands[starship])) && eval "$(starship init zsh)"
