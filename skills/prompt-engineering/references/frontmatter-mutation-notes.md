# Skill Frontmatter Mutation Notes

## Signal: frontmatter placement bugs when patching SKILL.md

When adding `skills:` or other YAML keys to an existing SKILL.md, the insertion
must land inside the `--- ... ---` block. Common failure modes:

- Inserting between the opening `---` and the closing `---` — the key ends up
  outside the YAML block and is ignored.
- Inserting after the closing `---` — same result; not parsed as metadata.

### Fix pattern

Read the file first. Find the last key inside the frontmatter block (usually
`related_skills` or `tags`). Insert the new key with matching indentation
*before* the closing `---`.

### Verified example

In `requesting-code-review`:

```yaml
---                              # opening delimiter
name: requesting-code-review
description: "..."
metadata:
  hermes:
    tags: [...]
    related_skills: [...]
    skills: [coding-standards]   # ← added inside metadata block
---                              # closing delimiter
```

NOT:

```yaml
    related_skills: [...]
---
skills: [coding-standards]       # ← broken: outside the block

# Pre-Commit Code Verification
```

## Related skills

- `prompt-engineering` — when to split prompts, fail-closed patterns
- `hermes-agent-skill-authoring` — SKILL.md frontmatter spec
