---
name: gitlab
description: Reference for the `glab` CLI tool — MR creation/editing, CI status/trace/retry, and VPN diagnostics for GitLab. MUST be loaded before running any `glab` command. Use when working with GitLab merge requests, pipelines, or connectivity issues.
argument-hint: [mr|ci|vpn]
---

# GitLab `glab` CLI Reference

Use this reference when performing GitLab operations. Always use `glab` — never `lab` or `gh` for GitLab.

Docs: https://docs.gitlab.com/cli/

## `glab mr create`

Syntax: `glab mr create [flags]`

| Flag | Purpose |
|------|---------|
| `-t "Title"` | MR title |
| `-d "Description"` | MR description (use `-d "$(cat file.md)"` for file input) |
| `--squash-before-merge` | Squash on merge |
| `--remove-source-branch` | Delete source branch after merge |
| `--draft` | Create as draft MR |
| `--reviewer username` | Assign reviewer |
| `-a username` | Assign assignee |
| `-l label` | Add label |
| `-m "milestone"` | Set milestone (**note:** `-m` is milestone, NOT message) |

Example:
```sh
glab mr create -t "Title" -d "Description" --squash-before-merge --remove-source-branch
```

## `glab mr update`

Syntax: `glab mr update <id> [flags]`

| Flag | Purpose |
|------|---------|
| `-t "Title"` | Update title |
| `-d "Description"` | Update description (use `-d "$(cat file.md)"` for file input) |
| `--target-branch <branch>` | Change target branch |
| `--draft` / `--ready` | Mark as draft / ready |
| `-l label` / `-u label` | Add / remove label |
| `-a username` / `-a '!username'` | Add / remove assignee |
| `--reviewer username` / `--reviewer '!username'` | Add / remove reviewer |
| `-m "milestone"` | Set milestone (use `""` to unassign) |

Examples:
```sh
glab mr update 12 -d "$(cat description.md)"
glab mr update 18 --target-branch master
glab mr update 23 -a '+johndoe' -a '!janedoe'
```

## `glab mr close`

Syntax: `glab mr close <id>`

No inline comment flag — use `glab mr note` first to leave a closing reason:

```sh
glab mr note 45 -m "Closing — superseded by direct commits on main."
glab mr close 45
```

## Keeping MRs in sync

After a push that changes what an existing MR does (new commits, a rebase that alters scope, a force-push over different work), update the MR title and description to match the current diff without being asked. A push that leaves the diff's scope unchanged, such as a typo fix or a lint pass, needs no description edit.

```sh
glab mr update <id> -t "Updated title" -d "$(cat <<'EOF'
Updated description...
EOF
)"
```

## `glab ci status`

Syntax: `glab ci status [flags]`

| Flag | Purpose |
|------|---------|
| `-b, --branch <branch>` | Branch to check |
| `--live` | Real-time updates until pipeline ends |
| `--compact` | Compact view |
| `-F json` | JSON output (not compatible with `--live`) |

Examples:
```sh
glab ci status -b main
glab ci status -b main --live    # monitor until completion
```

## `glab ci trace`

Syntax: `glab ci trace [flags]`

| Flag | Purpose |
|------|---------|
| `-b, --branch <branch>` | Branch |
| `-p, --pipeline-id <id>` | Pipeline ID |

To trace a specific job, pass the job name or ID as positional argument:
```sh
glab ci trace apply -b main
```

## `glab ci run`

Create a new pipeline:
```sh
glab ci run -b main
```

## Retrying / playing CI jobs

`glab` supports non-interactive retry and play of individual jobs — **always prefer this over creating a new pipeline**.

```sh
# Retry a failed job by name
glab ci retry plan -b main

# Play a manual job by name
glab ci trigger apply -b main

# Use pipeline ID for specificity
glab ci retry plan -b main -p 123456
glab ci trigger apply -b main -p 123456
```

**Exception:** Terraform `apply` jobs consume their `plan` artifact and can only be applied once. If `apply` fails, you must first retry the `plan` job to produce a fresh artifact, then trigger `apply` again.

### Typical Terraform deploy workflow

```sh
# 1. Retry the plan job to get a fresh artifact
glab ci retry plan -b main

# 2. Monitor until plan completes
glab ci status -b main --live

# 3. Trigger the manual apply job
glab ci trigger apply -b main

# 4. Monitor until apply completes
glab ci status -b main --live

# 5. If apply fails, check the trace and repeat from step 1
glab ci trace apply -b main
```

## `glab ci view`

**Do NOT use from Claude Code** — interactive TUI that crashes in non-interactive shells.

## VPN Diagnostics

`sbp.gitlab.schubergphilis.com` requires Cisco Secure Client VPN. When git push fails (403, timeout, connection refused), run this diagnostic before assuming auth issues:

1. Check process: `ps aux | grep -i "[Cc]isco"`
2. Check VPN state: `/opt/cisco/secureclient/bin/vpn state` — look for "Connected"
3. Test reachability: `curl -s -o /dev/null -w "%{http_code}" https://sbp.gitlab.schubergphilis.com/ --max-time 5` — expect 302
4. If disconnected, ask the user to reconnect via Cisco Secure Client
