# Global Preferences (gprefs)

## Quality & Honesty
- **No sycophancy, challenge reasoning.** Be direct — no praise, flattery, or filler. Push back on flawed assumptions or suboptimal approaches (yours and mine). Flag trade-offs honestly.
- **Match length to the question.** Answer directly and put the outcome first. Skip preamble, restatement of the request, and recaps of work I watched happen. Reach for headers, tables, and bullets when the content is genuinely tabular or enumerable, not as a default shape for prose.

## Tool Usage
- Always use dedicated tools instead of Bash equivalents: `Read` (not `cat`/`head`/`tail`), `Glob` (not `find`/`ls`), `Grep` (not `grep`/`rg`)
- These dedicated tools are allowed without prompting; Bash commands are not
- **Never read, search, or access credential/token files** (e.g. config files containing tokens, `.env` files with secrets) without explicit user approval
- Use `jq` for JSON parsing, not python one-liners

## Terraform
- Use `terraform` CLI locally, not `tofu`/`opentofu` (CI uses `gitlab-tofu` wrapper but locally it's `terraform`)
- `terraform validate` is flaky — kill and retry if no output after 10 seconds

## GitLab
- Always use `glab` as the CLI tool for GitLab (NOT `lab` or `gh`)
- `sbp.gitlab.schubergphilis.com` requires Cisco Secure Client VPN
- **Before any GitLab operation** (CI, MR, pipelines), load the `/gitlab` skill first to inform your decisions — don't rely on assumptions about `glab` syntax or available commands

## Git
- Always push to a non-default branch unless explicitly told otherwise. Never push directly to main/master.
- After completing a functional change (feature, fix, refactor), create a commit with a meaningful message before moving on.
- Stage specific files — never `git add -A` or `git add .`.
- Do not commit after research, questions, or partial/in-progress work.
- **Work in a git worktree for any change to tracked files.** Before the first edit, call `EnterWorktree` (named after the task) so the work is isolated on its own branch. Skip it for read-only work, research, and questions. If I've already put you on a task branch or in a worktree, stay there.
- Do not call `ExitWorktree` on your own — leave it in place for review; keep vs. remove is my call.

## Node.js
- Always use `pnpm`, never `npm`
- Replace `npx` with `pnpm dlx`
- Replace `nx` with `pnpm nx`

## Shell Aliases
- **`gcm`**: Checks out the default branch and pulls latest. Use this when the user says "checkout master/main" or "switch to default branch".
- **`grm`**: Rebases current branch on the default branch.
- **`grc`**: Rebases current branch on its remote tracking branch.
- **`gh`**: GitHub CLI.
