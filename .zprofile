export PATH="$PATH:/opt/homebrew/bin:$HOME/.local/bin:$HOME/go/bin/:$HOME/.tfenv/bin:$HOME/bin"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export CXX="/opt/homebrew/opt/llvm/bin/clang++"
#export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export GIT_EDITOR=nvim
export TFENV_ARCH=amd64
#export PYTHON_CONFIGURE_OPTS="--enable-framework"

# grc, grm, gcm and gcd live in .oh-my-zsh/custom/git.zsh (must load after oh-my-zsh)
alias gw="cd ~/git-work/"
alias python=python3
alias vi="nvim -O"
alias tf="terraform"
alias claude-tmp="cd /tmp && claude-docker --yolo"

#k8s
alias kdp="kubectl describe pod"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# CDK
function cdk-app {
    if [ -z "$1" ]
    then
        echo "Please provide a CDK app that is in in (src/apps)"
    else
        cdk --app "python -m src.apps.$1" ${@:2}
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

function aws-get-ec2-instances { 
    aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | [.InstanceId, (.Tags[]//[]|select(.Key=="Env")|.Value), (.Tags[]//[]|select(.Key=="Name")|.Value), (.PrivateDnsName), (.State.Name) ]|@tsv'
}

function aws-assume-role {
    if [ -z "$1" ]
    then
        echo "Please provide an role ARN"
    else
        eval $(aws sts assume-role --role-arn $1 --role-session-name assumed_by_zfunc | jq -r '"export AWS_ACCESS_KEY_ID=\"" + .Credentials.AccessKeyId + "\"\nexport AWS_SECRET_ACCESS_KEY=\"" + .Credentials.SecretAccessKey + "\"\nexport AWS_SESSION_TOKEN=\"" + .Credentials.SessionToken + "\""') 
    fi
}


# eval "$(pyenv init --path)"

# Hubble helper functions
function node-of-pod {
    kubectl -n $1 get pods $2 -o json | jq '.spec.nodeName'
}

function hubble-pod {
    kubectl -n kube-system get pods -l k8s-app=cilium -o json | \
    jq -r ".items[] | select(.spec.nodeName==$(node-of-pod $1 $2)) | .metadata.name"
}

# CDK
export JSII_SILENCE_WARNING_UNTESTED_NODE_VERSION=1

# Node.js NVM
  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm

# prevent Shai-Hulud from taking over my terminal
alias npm="echo 'npm is disabled because it is bad'"

# Claude-docker
# export CLAUDE_DOCKER_TMUX=cc
