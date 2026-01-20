---
name: autoskill
description: Analyze coding sessions to detect corrections and preferences, then propose targeted improvements to Skills used in the session. Use this skill when the user asks to "learn from this session", "update skills", or "remember this pattern".
allowed-tools: Read, Write, Glob, Bash
---

# autoskill

**Version**: 1.0.0  
**Last updated**: 2025-01-11

This skill analyzes coding sessions to extract durable preferences from corrections and approvals, then proposes targeted updates to Skills that were active during the session. It acts as a learning mechanism across sessions, ensuring Claude improves based on feedback.

---

## Scope

- **Reads**: All SKILL.md files that were active during the session
- **Writes**: SKILL.md files when changes are approved by user
- **Does NOT**: 
  - Modify code files directly
  - Create new skills without 3+ related signals
  - Run automatically (always requires explicit user trigger)

---

## Session definition

A "session" = the conversation history since the last autoskill run, or since the project conversation started if autoskill hasn't been run yet.

---

## When to activate

### Trigger on explicit requests:
- "autoskill"
- "learn from this session"
- "update skills from these corrections"
- "remember this pattern"
- "make sure you do X next time"

### Do NOT activate when:
- User says "just this once" or "for now"
- Corrections are about fixing bugs (not establishing patterns)
- No Skills were active during the session
- User declines skill modifications

**Silent skip**: If no durable patterns are detected and the user didn't explicitly invoke autoskill, don't announce "no patterns found" — just continue normally.

---

## Signal detection

Scan the session for:

### Corrections (highest value)
- "No, use X instead of Y"
- "We always do it this way"
- "Don't do X in this codebase"
- "Never put Y in Z"

### Repeated patterns (high value)
- Same feedback given 2+ times in the session
- Consistent naming/structure choices across multiple files
- User repeatedly makes the same type of edit

### Approvals (supporting evidence)
- "Yes, that's right"
- "Perfect, keep doing it this way"
- "This is exactly how we do it"

### Ignore:
- Context-specific one-offs ("use X here" without "always")
- Ambiguous feedback ("maybe try X?")
- Contradictory signals (ask for clarification instead)
- Bug fixes without pattern implications

---

## Signal quality filter

Before proposing any change, verify:

1. **Was this correction repeated, or stated as a general rule?**  
   ❌ "Use 'await' here"  
   ✅ "Always await database calls"

2. **Would this apply to future sessions, or just this task?**  
   ❌ "Name this variable 'userData'"  
   ✅ "User-related data should be prefixed with 'user'"

3. **Is it specific enough to be actionable?**  
   ❌ "Make it better"  
   ✅ "Extract magic numbers into named constants"

4. **Is this new information I wouldn't already know?**  
   ❌ "Use semantic HTML"  
   ✅ "Our design system uses `<Button>` from shadcn, not native `<button>`"

**Only propose changes that pass all four criteria.**

---

## What counts as "new information"

### Worth capturing:
- Project-specific conventions  
  *"we use cn() not clsx() here"*
- Custom component/utility locations  
  *"buttons are in @/components/ui, not /components/common"*
- Team preferences that differ from defaults  
  *"we prefer explicit returns over implicit"*
- Domain-specific terminology or patterns  
  *"customer records are called 'accounts' in our codebase"*
- Non-obvious architectural decisions  
  *"auth logic lives in middleware, not components"*
- Integration quirks specific to this stack  
  *"Stripe webhooks must validate signature before parsing body"*

### NOT worth capturing (I already know this):
- General best practices (DRY, separation of concerns)
- Language/framework conventions (React hooks rules, TypeScript basics)
- Common library usage (standard Tailwind classes, typical Next.js patterns)
- Universal security practices (input validation, SQL injection prevention)
- Standard accessibility guidelines (alt text, ARIA labels)

**If I'd give the same advice to any project, it doesn't belong in a skill.**

---

## Mapping signals to Skills

Match each signal to the Skill that was active and relevant:

1. **If the signal relates to a Skill that was used**, update that Skill's SKILL.md
2. **If 3+ related signals don't fit any active Skill**, propose creating a new Skill
3. **Ignore signals** that don't map to any Skill used in the session

---

## Proposing changes

For each proposed edit, use this format:

```diff
File: path/to/SKILL.md
Section: [existing section name or "NEW SECTION: Title"]
Confidence: HIGH | MEDIUM

Signal: "[exact user quote or paraphrase]" (line reference if available)

--- Current
[existing content, if modifying]

+++ Proposed
[updated content]

Rationale: [one sentence explaining why this change improves the skill]
```

**Group proposals by file. Present HIGH confidence changes first.**

---

## Review flow

Always present changes for review before applying:

```
## autoskill summary

Detected [N] durable preferences from this session.

### HIGH confidence (recommended to apply)

```diff
File: react-patterns/SKILL.md
Section: Component Patterns

- Use clsx() for className merging
+ Use cn() utility from @/lib/utils for className merging

Confidence: HIGH
Signal: "We always use cn() not clsx() here" (line 47)
Rationale: Project-specific utility preference
```

### MEDIUM confidence (review carefully)

```diff
File: api-design/SKILL.md
Section: NEW SECTION: Error Responses

+++ Proposed
Always return error messages in {error: string, code: string} format

Confidence: MEDIUM
Signal: User corrected error response format twice
Rationale: Possible team convention, but not explicitly stated as "always"
```

---

**Apply high confidence changes?** [y/n/selective]
```

Wait for explicit approval before editing any file.

---

## Applying changes

When approved:

1. **Edit the target file** with minimal, focused changes
2. **If git is available**, commit with message:  
   `chore(autoskill): [brief description]`  
   Example: `chore(autoskill): add cn() utility preference to react-patterns`
3. **Report what was changed**:
   ```
   ✓ Updated react-patterns/SKILL.md (1 change)
   ✓ Updated api-design/SKILL.md (2 changes)
   ✓ Committed changes to git
   ```

---

## Constraints

- **Never delete existing rules** without explicit instruction
- **Prefer additive changes** over rewrites (easier to review/revert)
- **One concept per change** (granular for easy reversal)
- **Preserve existing file structure and tone**
- **When uncertain**, downgrade to MEDIUM confidence and ask for guidance
- **Maximum 10 proposals per session** (if more, suggest creating a new skill or splitting the session)

---

## Edge cases

### Conflicting signals
If the session contains contradictory feedback:
```
⚠ Conflicting signals detected:
- Line 23: "Always use async/await"
- Line 67: "Callbacks are fine for simple cases"

Please clarify: Should I propose "prefer async/await" or "use either based on complexity"?
```

### No Skills were active
If autoskill is triggered but no Skills were used:
```
No Skills were active during this session. 

Would you like me to:
1. Analyze the session for patterns and propose a new Skill?
2. Skip autoskill for this session?
```

### Modifications to autoskill itself
If signals suggest changing autoskill's own behavior:
```
⚠ Detected feedback about autoskill itself.

This requires manual editing of autoskill/SKILL.md.
Suggested change: [describe the meta-improvement]
```

---

## Example usage

```
User: "autoskill"

Claude: 
## autoskill summary

Detected 3 durable preferences from this session.

### HIGH confidence (recommended to apply)

```diff
File: typescript-patterns/SKILL.md
Section: Type Definitions

- Use 'interface' for object shapes
+ Use 'type' for object shapes (team preference)

Confidence: HIGH
Signal: "We use 'type' not 'interface'" (line 34)
Rationale: Explicit team convention stated during code review
```

Apply high confidence changes? [y/n/selective]

User: "y"

Claude:
✓ Updated typescript-patterns/SKILL.md (1 change)
✓ Committed: chore(autoskill): standardize on 'type' over 'interface'

Session learning complete. These preferences will apply to future sessions.
```
