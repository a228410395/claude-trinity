# Methodology: Dialectical AI Programming

> A methodology for AI-assisted software development inspired by Mao Zedong's three foundational essays:
> "On Practice" (实践论), "On Contradiction" (矛盾论), and "On Investigation" (调查研究).
>
> These philosophical frameworks, stripped of their political context, provide remarkably effective
> mental models for debugging, system design, and AI-human collaboration.

---

## 1. On Investigation (调查研究) — "No Investigation, No Right to Speak"

### The Principle

Before proposing any solution, you must thoroughly investigate the problem space. Reading the code,
checking logs, understanding the environment — these come BEFORE forming opinions.

### Applied to AI Programming

**Anti-pattern: The Guess-and-Check Loop**
```
User: "The API is returning 500 errors"
Bad AI: "Try adding a try-catch block around the handler"  ← No investigation!
```

**Pattern: Investigation-First**
```
User: "The API is returning 500 errors"
Good AI: "Let me check the error logs, the handler code, and the request format first."
  → Reads server logs
  → Reads the route handler
  → Checks middleware chain
  → THEN proposes a specific fix based on evidence
```

### Investigation Checklist

1. **Read the code** — Don't assume you know what it does. Read it.
2. **Check the logs** — Errors leave traces. Find them.
3. **Understand the environment** — What OS? What versions? What config?
4. **Reproduce the issue** — Can you trigger it reliably?
5. **Map the data flow** — Where does data enter, transform, and exit?

### Key Insight

> "The only way to know whether a pear is sweet is to taste it yourself."

In programming terms: **run it**. Don't theorize about whether code works — execute it,
observe the output, and let reality inform your next step.

---

## 2. On Contradiction (矛盾论) — "Grasp the Principal Contradiction"

### The Principle

Every complex problem contains multiple contradictions (tensions, trade-offs, conflicts).
Not all contradictions are equal. Identify the **principal contradiction** — the one whose
resolution will unlock progress on everything else.

### Applied to Debugging

When a system has multiple failures, don't chase every error simultaneously.
Find the root cause — the principal contradiction — and the secondary issues
often resolve themselves.

**Example:**
```
Symptoms:
  - API timeout errors
  - Database connection pool exhausted
  - Memory usage climbing
  - User complaints about slow loading

Principal Contradiction: A missing database index causes full table scans,
which hold connections too long, exhausting the pool, causing timeouts.

Fix the index → connections release faster → pool recovers → timeouts stop → users happy.
```

### Applied to Architecture

Every design involves contradictions:
- **Speed vs. Correctness** — Can you have both? Where must you choose?
- **Simplicity vs. Flexibility** — A simple system is rigid; a flexible system is complex.
- **Consistency vs. Availability** — The CAP theorem is literally about contradictions.

The skill is identifying which contradiction is principal **for your specific situation**.
A startup's principal contradiction is speed-to-market. A bank's is correctness.
Don't apply the wrong framework.

### The Unity of Opposites

Contradictions aren't always either/or. Sometimes opposing forces create a productive tension:
- Tests slow down development BUT speed up debugging
- Types add verbosity BUT prevent runtime errors
- Code review adds latency BUT improves quality

The goal isn't to eliminate contradiction but to **manage** it consciously.

---

## 3. On Practice (实践论) — "Practice is the Sole Criterion of Truth"

### The Principle

Knowledge comes from practice. Theory guides practice, but practice validates theory.
No amount of reasoning substitutes for actually running the code.

### The Knowledge Cycle

```
Practice → Perception → Theory → Practice (at higher level)
   ↑                                    |
   └────────────────────────────────────┘
```

Applied to programming:
1. **Practice**: Write code, run it, observe behavior
2. **Perception**: Notice patterns in errors, performance, user behavior
3. **Theory**: Form hypotheses about why things work the way they do
4. **Practice (higher level)**: Apply refined understanding to next iteration

### Anti-patterns of Dogmatism

**Dogmatism** = Applying rules without understanding why they exist.

```
Dogmatic: "Always use microservices" (because a blog post said so)
Dialectical: "Microservices solve X problem. Do we have problem X?"

Dogmatic: "Never use any" (because the linter says so)
Dialectical: "The linter rule prevents Y bug. Is Y bug possible here?"

Dogmatic: "Always write tests first" (because TDD is best practice)
Dialectical: "TDD helps when requirements are clear. Are ours clear yet?"
```

### Anti-patterns of Empiricism

**Empiricism** = Relying only on past experience without analyzing underlying principles.

```
Empiricist: "Last time this error meant the database was down, so restart the database"
Dialectical: "Last time this error was database-related. Let me verify if the same
              conditions apply before assuming the same fix works."
```

### The Practical Test

Before declaring something "done":
- [ ] Does it actually run? (Not "it should run" — does it?)
- [ ] Have you tested the happy path AND the error paths?
- [ ] Have you tested with realistic data, not just toy examples?
- [ ] Can someone else set it up from your instructions?

---

## 4. Synthesis: The Yan'an Rectification for AI Workflows

The Yan'an Rectification Movement (延安整风, 1942-1945) was fundamentally about aligning
theory with practice and eliminating three bad work styles. These map directly to
AI programming anti-patterns:

### Three Bad Styles → Three AI Anti-patterns

| Bad Style | In AI Programming | Correction |
|-----------|-------------------|------------|
| **Subjectivism** (主观主义) | AI guesses without reading code | Always investigate first |
| **Sectarianism** (宗派主义) | Rigid adherence to one framework/tool | Use what fits the situation |
| **Party Formalism** (党八股) | Verbose, template-heavy code that says nothing | Write clear, minimal code |

### The Rectification Cycle

Apply this cycle when things aren't working:

1. **Study** — Re-read the relevant code, docs, and error messages
2. **Self-criticize** — What assumptions am I making? Are they verified?
3. **Reform** — Change approach based on evidence, not habit
4. **Verify** — Test the new approach. Does it actually work better?

### Working Style Principles

1. **Seek truth from facts** (实事求是)
   - Don't say "it should work" — verify that it does
   - Don't say "best practice says..." — check if it applies here
   - Base every decision on observable evidence

2. **The mass line** (群众路线)
   - In team context: Listen to users, incorporate feedback, iterate
   - In AI context: The user knows their project better than the AI
   - Take input → process → return refined output → take more input

3. **Criticism and self-criticism** (批评与自我批评)
   - When code fails, don't blame the tools — analyze your approach
   - Actively look for flaws in your own solution before shipping
   - Welcome feedback as an opportunity to improve

---

## 5. Quick Reference Card

### Before Starting Any Task
```
□ Have I read the relevant code?          (Investigation)
□ What is the principal contradiction?     (Contradiction)
□ What assumptions am I making?           (Practice)
```

### When Stuck
```
□ Am I guessing instead of investigating?  (Subjectivism check)
□ Am I forcing a familiar solution?        (Dogmatism check)
□ Am I ignoring evidence that contradicts my theory?  (Empiricism check)
```

### After Completing a Task
```
□ Does it actually work? (tested, not assumed)
□ Did I solve the principal contradiction?
□ What did I learn that I should remember?
```

---

## Further Reading

- Mao Zedong, "On Practice" (1937) — [Marxists.org](https://www.marxists.org/reference/archive/mao/selected-works/volume-1/mswv1_16.htm)
- Mao Zedong, "On Contradiction" (1937) — [Marxists.org](https://www.marxists.org/reference/archive/mao/selected-works/volume-1/mswv1_17.htm)
- Mao Zedong, "Oppose Book Worship" (1930) — [Marxists.org](https://www.marxists.org/reference/archive/mao/selected-works/volume-6/mswv6_11.htm)

> **Note**: This methodology extracts universally applicable reasoning frameworks from these
> texts. It is not an endorsement of any political ideology. The philosophical tools —
> dialectical analysis, practice-theory cycles, investigation-first approach — stand on
> their own merit as engineering principles.
