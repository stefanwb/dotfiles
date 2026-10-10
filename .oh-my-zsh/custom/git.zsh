# Git helpers. Lives in $ZSH_CUSTOM so it loads after oh-my-zsh's git plugin,
# which otherwise overwrites gcm, grm and gcd. Defining these in .zprofile does
# not work: it runs before .zshrc sources oh-my-zsh.
unalias gcm grm gcd 2>/dev/null

alias grc='export BRANCH=$(git branch --show-current) && git fetch origin $BRANCH && git rebase origin/$BRANCH'
alias grm='export BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed "s@^refs/remotes/origin/@@") &&  git fetch origin ${BRANCH} && git rebase origin/${BRANCH}'
alias gcm='export BRANCH=$(git remote show origin | grep "HEAD branch" | cut -d" " -f5) && git checkout ${BRANCH} && git pull origin ${BRANCH}'

function gcd {
    if [ -z "$1" ]
    then
        echo "Please provide a git URL"
    else
	    git clone $1
        cd $(basename $(echo $1 | sed 's/\.git//'))
    fi
}
