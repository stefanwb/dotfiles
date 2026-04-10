---
name: create-team
description: Creates a new team using TeamCreate and runs the agents in the foreground. Use when the user says "create a team".
argument-hint: [team-name and agent descriptions]
---

# Create Team Skill

When the user says "create a team", use the `TeamCreate` tool to create a new team.

**Important**: All agents on the team must run in the **foreground** (not background).

Use `$ARGUMENTS` to determine the agent configuration. If the user hasn't provided enough detail, ask for:
1. Agent roles/names and their responsibilities
2. The task the team should work on

**Team naming**: Do NOT ask the user for a team name. Instead, generate a suitable name based on the context, goal, and team composition (e.g., `infra-migration-team`, `api-redesign-squad`).
