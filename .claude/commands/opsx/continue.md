---
name: "OPSX: Continue"
description: Continue working on a change - create the next artifact (Experimental)
category: Workflow
tags: [workflow, artifacts, experimental]
---

Run the `openspec-continue-change` skill.

The argument after `/opsx:continue` is the change name. If omitted, infer it from
conversation context; if that is ambiguous, prompt with the available changes.
