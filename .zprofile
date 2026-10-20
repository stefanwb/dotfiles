# Login shell environment: PATH and exports only. Aliases and functions are in
# zsh/*.zsh, sourced by .zshrc.
export PATH="$PATH:/opt/homebrew/bin:$HOME/.local/bin:$HOME/go/bin/:$HOME/.tfenv/bin:$HOME/bin"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export CXX="/opt/homebrew/opt/llvm/bin/clang++"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export GIT_EDITOR=nvim
export TFENV_ARCH=amd64
#export PYTHON_CONFIGURE_OPTS="--enable-framework"

# eval "$(pyenv init --path)"

# CDK
export JSII_SILENCE_WARNING_UNTESTED_NODE_VERSION=1

# Node.js NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm

# Claude-docker
# export CLAUDE_DOCKER_TMUX=cc
