---
name: "OPSX: Apply"
description: Implement tasks from an OpenSpec change (Experimental)
category: Workflow
tags: [workflow, artifacts, experimental]
---

Run the `openspec-apply-change` skill.

The argument after `/opsx:apply` is the change name. If omitted, infer it from
conversation context; if that is ambiguous, prompt with the available changes.
