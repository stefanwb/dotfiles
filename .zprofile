export PATH="$PATH:/opt/homebrew/bin:$HOME/.local/bin:$HOME/go/bin/:$HOME/.tfenv/bin"
export GIT_EDITOR=vi
export TFENV_ARCH=amd64

alias grc='export BRANCH=$(git branch --show-current) && git fetch origin $BRANCH && git rebase origin/$BRANCH'
alias grm='git fetch origin master && git rebase origin/master'
alias gw="cd ~/git-work/"
alias python=python3
alias vi="nvim -O"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

function gcd {
    if [ -z "$1" ]
    then
        echo "Please provide a git URL"
    else
	git clone $1 
        cd $(basename $(echo $1 | sed 's/\.git//'))
    fi
}

# AWS
function aws-sso-login {
    if [ -z "$1" ]
    then
        echo "Please provide an SSO profile!"
    else
        aws sso login --profile $1
        export AWS_PROFILE=$1
    fi
}

function aws-session {
    if [ -z "$1" ]
    then
        echo "Please provide an instance ID!"
    else
        if [ -z "$2" ]
        then
            aws ssm start-session --target $1
        else
            if [ -z "$3" ]
            then
                aws ssm start-session --target $1 \
                           --document-name AWS-StartPortForwardingSession \
                           --parameters "{\"portNumber\":[\"$2\"],\"localPortNumber\":[\"$2\"]}"
            else
                aws ssm start-session --target $1 \
                           --document-name AWS-StartPortForwardingSession \
                           --parameters "{\"portNumber\":[\"$2\"],\"localPortNumber\":[\"$3\"]}"
            fi
        fi
    fi
}

function aws-session-remote {
    if [ -z "$1" ]
    then
        echo "Please provide an instance ID!"
    else
        if [ -z "$3" ]
        then
            echo "Please provide an remote host!"
        else
            if [ -z "$4" ]
            then
                aws ssm start-session --target $1 \
                           --document-name AWS-StartPortForwardingSessionToRemoteHost \
                           --parameters "{\"host\":[\"$2\"],\"portNumber\":[\"$3\"],\"localPortNumber\":[\"$3\"]}"
            else
                aws ssm start-session --target $1 \
                           --document-name AWS-StartPortForwardingSessionToRemoteHost \
                           --parameters "{\"host\":[\"$2\"],\"portNumber\":[\"$3\"],\"localPortNumber\":[\"$4\"]}"
            fi
        fi
    fi
}
