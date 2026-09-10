---
name: "OPSX: Archive"
description: Archive a completed change in the experimental workflow
category: Workflow
tags: [workflow, archive, experimental]
---

Run the `openspec-archive-change` skill.

The argument after `/opsx:archive` is the change name. If omitted, infer it from
conversation context; if that is ambiguous, prompt with the available changes.
