---
name: "OPSX: Verify"
description: Verify implementation matches change artifacts before archiving
category: Workflow
tags: [workflow, verify, experimental]
---

Run the `openspec-verify-change` skill.

The argument after `/opsx:verify` is the change name. If omitted, infer it from
conversation context; if that is ambiguous, prompt with the available changes.
