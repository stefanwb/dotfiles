#!/bin/sh
# Claude Code status line — mirrors key Powerlevel10k segments

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // empty')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Shorten home directory to ~
home="$HOME"
short_cwd=$(echo "$cwd" | sed "s|^$home|~|")

# Git branch (skip optional locks to avoid blocking)
git_branch=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  git_branch=$(git -C "$cwd" -c core.hooksPath=/dev/null symbolic-ref --short HEAD 2>/dev/null \
    || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

# Terraform workspace
tf_workspace=""
tf_env_file="$cwd/.terraform/environment"
if [ -f "$tf_env_file" ]; then
  tf_workspace=$(cat "$tf_env_file" 2>/dev/null)
fi
[ -z "$tf_workspace" ] && tf_workspace="default"

# AWS profile
aws_profile="${AWS_PROFILE:-${AWS_DEFAULT_PROFILE:-}}"

# Build status line with ANSI colors (dimmed-friendly)
output=""

# Directory in blue
output=$(printf '\033[34m%s\033[0m' "$short_cwd")

# Git branch in green
if [ -n "$git_branch" ]; then
  output="$output $(printf '\033[32m(%s)\033[0m' "$git_branch")"
fi

# Terraform workspace in magenta (only if not default)
if [ -n "$tf_workspace" ] && [ "$tf_workspace" != "default" ]; then
  output="$output $(printf '\033[35mtf:%s\033[0m' "$tf_workspace")"
fi

# AWS profile in yellow
if [ -n "$aws_profile" ]; then
  output="$output $(printf '\033[33maws:%s\033[0m' "$aws_profile")"
fi

# Model and context in cyan
if [ -n "$model" ]; then
  model_part="$model"
  if [ -n "$remaining" ]; then
    model_part="$model_part ${remaining}% left"
  fi
  output="$output $(printf '\033[36m[%s]\033[0m' "$model_part")"
fi

printf '%s' "$output"
