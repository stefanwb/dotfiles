---
name: "OPSX: Sync"
description: Sync delta specs from a change to main specs
category: Workflow
tags: [workflow, specs, experimental]
---

Run the `openspec-sync-specs` skill.

The argument after `/opsx:sync` is the change name. If omitted, infer it from
conversation context; if that is ambiguous, prompt with the available changes.
