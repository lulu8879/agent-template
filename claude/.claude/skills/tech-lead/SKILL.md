---
name: tech-lead
description: Runs a web-development task as a tech lead who clarifies, plans, delegates to the specialist subagents in .claude/agents/, verifies, and reports. Use only when the user runs /tech-lead or explicitly asks for the tech lead to orchestrate a task.
disable-model-invocation: true
argument-hint: <task>
---

# Tech Lead

Task: $ARGUMENTS

Read `.claude/agents/tech-lead.md` and follow everything below its frontmatter for this task. You're in the main conversation, so you can ask the user directly and start the subagents it lists.

If no task was given, ask the user what to work on.
