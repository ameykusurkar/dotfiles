---
name: review-this
description: >
  Quick-start PR review briefing. Fetches a PR, classifies it (bug fix / feature / refactor),
  highlights the key design decisions worth scrutinizing, and flags risk areas — all before
  you read a single line of diff yourself.
  Triggers on: "review this PR", "review this", "what do I need to know about this PR",
  "brief me on this PR", "PR briefing".
trigger: user
---

# review-this

Generate a concise reviewer's briefing for a pull request. The goal is to orient the
reviewer — not to be the review itself.

## Input

The user provides a PR URL or a PR number (assumes current repo if no URL).

## Steps

### 1. Fetch PR data

Run these in parallel:

```bash
gh pr view <number> --repo <owner/repo> --json title,body,author,labels,state,baseRefName,headRefName,files,commits,reviews,reviewRequests
gh pr diff <number> --repo <owner/repo>
```

If only a number is given with no repo, omit `--repo` (uses current directory's repo).

### 2. Read changed files for context

For each changed file in the diff, read the **current base branch version** of the file
(not just the diff) so you understand the surrounding code. Skip vendored, generated, or
lock files.

Limit: if there are more than 10 changed files, prioritise non-test source files first.
Only read files that help you understand the intent and risk — not every touched file.

### 3. Produce the briefing

Structure your response as:

#### Header
```
## PR #<number> — <title>
**Author:** <name> | **Status:** <state> | **<N> files changed** (+<additions> / -<deletions>)
```

#### Classification
One of: **Bug fix**, **New feature**, **Enhancement**, **Refactor**, **Config/infra change**,
**Test-only**, **Docs-only**. Include a 1-2 sentence explanation of *what* and *why* derived
from the PR body + diff (not just parroting the PR description).

#### Design decisions to review
Bullet list of the non-obvious choices the author made. For each:
- What was the decision
- What was the alternative not taken (if apparent)
- Why it matters — what breaks if this choice is wrong

This is the core value of the briefing. If there are no meaningful design decisions
(e.g. a one-line typo fix), say so and skip the section.

#### Risk areas
Anything that could go wrong:
- Hardcoded values, magic numbers
- Missing error handling at system boundaries
- Schema/migration changes
- Permission or access changes
- Performance implications (new joins, N+1 patterns, unbounded queries)
- Multi-region or multi-environment implications

Only list risks that are actually present — don't generate generic checklists.

#### Cosmetic / mechanical changes
Briefly note any formatting, import reordering, or linter-driven changes so the reviewer
knows to skim past them.

#### Verdict
A 1-2 sentence honest assessment: is this straightforward, does it need careful scrutiny,
are there open questions the author should answer before merge?

## Style

- Be direct and opinionated — the reviewer wants your read, not a neutral summary
- Don't repeat the PR description verbatim; synthesize it with what you see in the diff
- If the PR description is thin or missing, say so — that's a finding
- Keep the whole briefing scannable — prefer bullets over paragraphs
