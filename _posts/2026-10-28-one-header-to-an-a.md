---
title: "From One Security Header to an A: Hardening My Portfolio"
date: 2026-10-28 21:00:00 +0500
categories: [Hands-on, Web Security]
tags: [security-headers, csp, hsts, gitleaks, secrets, nextjs, git]
---

My mentor will review my portfolio, so before sending it I ran a full audit on it. The goal was simple: a security person should not find easy problems on the site of someone who wants to work in security.

This post is what I found, what I changed, and what I learned.

## Where I started

The audit showed a few problems:

- The site had only **one** security header: HSTS.
- It ran on **Next.js 13.5.1**, which had a critical advisory. `npm audit` reported **20 vulnerabilities** (1 critical, 15 high).
- The contact form had no spam protection.
- And the worst one: the git history had an **old Gmail app password** in it, left over from the template I started from.

## The headers I added

I added these in `next.config.js` so every page gets them:

| Header | What it does |
|---|---|
| `Content-Security-Policy` | Tells the browser which sources can load scripts, styles, images and fonts. Everything is limited to my own site. |
| `Strict-Transport-Security` | Forces HTTPS for two years, including subdomains. |
| `X-Frame-Options: DENY` | Stops other sites from putting my site in an iframe (clickjacking). |
| `X-Content-Type-Options: nosniff` | Stops the browser from guessing file types. |
| `Referrer-Policy` | Sends only the origin, not the full URL, to other sites. |
| `Permissions-Policy` | Turns off camera, microphone and location, because the site never needs them. |

I also upgraded to Next.js 15 and removed about 30 unused packages. `npm audit` went from 1 critical to **0 critical**. The 5 that are left are build-time only (PostCSS inside Next.js and Tailwind), and no user input reaches them.

Result on [securityheaders.com](https://securityheaders.com): **A**.

## Why A and not A+

The grade is capped at A because my CSP has `'unsafe-inline'` in `script-src`.

Next.js puts small inline scripts in statically built pages, so the site breaks without it. The fix is a nonce-based CSP: the server creates a random value for every request, and only scripts with that value can run. But that means every page must be rendered on the server for every visit. No more static pages.

My site is static, has no login, no cookies and no user data. The XSS risk is low, and the cost of the fix is high. So I accepted the A. I think the important part is knowing *why* you accept a risk, not getting the highest score.

## The secret that gitleaks missed

This was the biggest lesson of the day.

I ran **gitleaks** on the whole history and it said: **no leaks found**. But a manual review of the first commit found a Gmail SMTP app password in the contact form code. It had been removed in a later commit, but in git, "removed" does not mean "gone". Anyone could still read it in the history.

gitleaks missed it because a Gmail app password is just 16 lowercase letters. It has no prefix like `AKIA` (AWS) or `ghp_` (GitHub), so the default rules have nothing to match.

What I did, in this order:

1. **Revoked the password first.** Cleaning the history does not make a leaked secret safe. Only revoking it does.
2. Made the repo private.
3. Rebuilt the history as a single clean commit and force-pushed it.
4. Turned on GitHub push protection for my account.

## Small fixes on the contact form

- A hidden **honeypot** field. Bots fill it, people don't, so those messages are dropped.
- Requests from other **origins** are rejected.
- Bad JSON now returns **400** instead of 500.
- Line breaks are removed from the name and subject, so nobody can inject extra email headers.

## What I learned

1. **A tool saying "no leaks" is not proof.** Scanners only find what their rules know. Manual review still matters.
2. **Revoke first, clean later.** Once a secret is public, assume someone has it.
3. **Every security decision is a trade-off.** Write down why you accepted a risk.
4. **Old dependencies are a real risk.** One upgrade removed the only critical issue.

Next, I want to add these checks (gitleaks, `npm audit`, a header check) to GitHub Actions, so they run on every change instead of only when I remember.
