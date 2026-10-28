---
title: "My Secret Scanner Missed a Real Password, So I Wrote a Rule That Catches It"
date: 2026-10-28 19:00:00 +0500
categories: [Hands-on, DevSecOps]
tags: [gitleaks, secrets, detection-engineering, github-actions, semgrep, ci-cd]
---

In my [last post](/security-journal/posts/one-header-to-an-a/) I wrote that gitleaks reported no leaks in my portfolio repository, while a manual review found a Gmail app password in the git history.

A missed detection is a problem to fix, not a footnote. This post covers why the scanner missed it, the rule I wrote to close the gap, how I proved the rule works on the real incident, and the pipeline that now runs it on every change.

## Why the default rules missed it

gitleaks detects secrets with regular expressions, plus keywords and entropy checks to keep false positives down. Most of its rules match structure: a known prefix such as `AKIA` for AWS keys or `ghp_` for GitHub tokens, a fixed length, a known character set.

A Google app password has almost no structure. It is 16 lowercase letters, often shown in four groups of four. There is no prefix, no digits, no special characters, and its entropy is close to that of normal text. A generic rule that flagged every 16-letter string would fire on ordinary words all day, so the default rule set does not try.

The lesson is simple: a clean scan only means "nothing matched the rules you have", not "there are no secrets".

## Writing the rule

The pattern on its own is too weak, so the rule needs context. In real code, an app password almost always appears as a value assigned to something named like a password, inside SMTP or mail configuration. That context is the signal.

I extended the default configuration instead of replacing it, so all built-in rules still run. A simplified version of the rule:

```toml
[extend]
useDefault = true

[[rules]]
id = "gmail-app-password"
description = "Gmail / Google app password assigned to a password-like key"
regex = '''(?i)(?:pass|password|app_password|smtp_pass)\s*[:=]\s*["']([a-z]{4} ?[a-z]{4} ?[a-z]{4} ?[a-z]{4})["']'''
keywords = ["pass", "password", "smtp", "gmail"]
```

- The keywords act as a pre-filter: gitleaks only evaluates the regex on content that contains one of them.
- The regex requires an assignment (`pass: "..."`, `password = '...'`), not just 16 letters somewhere in a file.
- The capture group is the secret itself, which gitleaks redacts in its output.

## Proving it works on the real incident

A detection rule is only useful if it catches the thing it was written for, without drowning you in noise. I tested it three ways:

| Test | Default rules | With the new rule |
|---|---|---|
| A synthetic test file outside the repository | 0 findings | 1 finding |
| The original commit with the real leaked password (in a local backup branch) | 0 findings | 1 finding, correct file and line |
| The current repository, all tracked files | 0 findings | 0 findings (no false positives) |

I also ran the rule alone across all of `node_modules`, which is a good source of random strings: 0 false positives.

The second row is the important one. The same scanner that missed the incident now catches it, on the exact commit where it happened. All output was redacted, and the password itself had already been revoked before any of this.

## Turning it into a pipeline

A rule I run by hand only protects me when I remember to run it. So the checks now run automatically in GitHub Actions:

| Check | What it does | When |
|---|---|---|
| Secret scan | gitleaks with the custom rule, across the full git history | Every push, every pull request, daily |
| Dependency audit | `npm audit`, fails on critical vulnerabilities | Every push to main, weekly |
| Code scan | Semgrep with JavaScript, TypeScript, React and secrets rule sets, plus ESLint | Every push to main, weekly |
| Live site check | All 8 security headers, CSP directives, HSTS age, the 308 redirect, `security.txt` expiry | After every production deploy, daily |
| Dependabot | Grouped update pull requests for npm packages and GitHub Actions | Weekly |

And one check runs before code ever leaves my laptop: a pre-commit hook that scans staged changes with the same gitleaks config and blocks the commit on a finding. I tested it by staging a file with a synthetic password: the commit was refused.

## Hardening the pipeline itself

A security pipeline is also code that runs with access to the repository, so it needs the same care:

- Actions pinned to full commit SHAs, not version tags, so a moved tag cannot change what runs.
- Read-only permissions by default (`contents: read`), and no repository secrets at all.
- The gitleaks binary is verified against the SHA-256 checksum from the official release before it runs.
- Semgrep runs from the official container image pinned by digest, with metrics turned off.

The first run of every workflow passed. The whole setup uses roughly 10% of the free Actions minutes for a private repository.

## What I took from this

1. **Test your tools against your own incidents.** A scanner's default rules are written for everyone. Your incidents are specific to you.
2. **Context beats patterns.** A weak pattern plus the right context (keywords, assignment, file type) gives a useful rule without false positives.
3. **Measure the miss before the fix.** Running the old rules on the real commit and getting 0 findings is what proves the new rule closes a real gap.
4. **Shift left, but keep the safety net.** The pre-commit hook stops mistakes early; the CI scan catches anything that slips past it, including commits made on another machine.
5. **Revoking comes first.** Detection and history cleanup reduce exposure, but only revoking the credential makes it safe.

Next, I want to apply the same approach to detection on the log side: Sigma rules for failed logons and SSH brute force, tested against real events from my lab.
