---
title: "Endpoint Security, Part 2: Deception and Social Engineering"
date: 2026-10-31 21:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, social-engineering, phishing, deception, security-awareness]
---

The second part of today's study was about **deception**: attacks that target people instead of computers. I covered social engineering briefly in my Introduction to Cybersecurity notes, but this course goes deeper. It explains *why* these tricks work on smart, careful people. Once you understand the "why," you can recognize a trick even when the story is new.

## What social engineering is

**Social engineering** is manipulating people into giving away information or doing something unsafe, like clicking a link, sharing a password or sending money. Instead of hacking the computer, the attacker hacks the human.

Attackers use it because it's easier. Breaking into a well-protected system can take weeks. Convincing one employee to share a password can take one phone call.

It works because it uses good human qualities against us: we want to be helpful, we respect authority, we react quickly under pressure, and we trust what looks familiar.

## Three common types

- **Pretexting:** the attacker invents a believable story (a *pretext*) to justify the request. *Example: "This is the bank's fraud team. To block a suspicious payment on your account ending in 4521, I need the code we just sent you."* Knowing a real detail makes the story convincing, but a real bank would never ask for that code.
- **Something for something (quid pro quo):** the attacker offers something in return. *Example: "Fill in this staff survey with your work login and get a free gift card."* Or a fake "IT support" caller offers to fix a problem if you install their "tool."
- **Identity fraud:** using someone else's personal details, for example to open a bank account or take a loan in their name. The data often comes from breaches, phishing or oversharing on social media.

## The seven tactics: why people fall for it

This was the most useful part for me. Most scams use two or three of these at once:

| Tactic | What it does | Example |
|---|---|---|
| **Authority** | Pretends to be someone important | "This is the CEO. Process this transfer now." |
| **Intimidation** | Scares or bullies the victim | "Help me now or I'll report you to your manager." |
| **Consensus** (social proof) | Says everyone else is doing it | "Your whole team already verified their accounts here." |
| **Scarcity** | Makes something seem limited | "Only 3 free licenses left." |
| **Urgency** | Removes time to think | "Your account will be closed in 30 minutes." |
| **Familiarity** | Uses a known name or friendly tone | A "colleague" asking you to check a file |
| **Trust** | Builds a relationship first | Weeks of friendly LinkedIn chat, then a malicious "job description" file |

Familiarity and trust sound similar, but familiarity is instant (using a name you know), while trust is built over weeks before the request comes.

The biggest red flag: **strong emotion plus a request for something sensitive**.

## Physical tricks

Not all deception happens online:

- **Shoulder surfing:** watching someone type their PIN or password, up close or with a camera from a distance. *Defense: cover the keypad, use privacy screens.*
- **Dumpster diving:** searching the trash for printed emails, staff lists or sticky notes with passwords. *Defense: shred documents and wipe old drives.*
- **Impersonation:** pretending to be a delivery person, technician or new employee to get in or get help. *Defense: verify identity through official channels, escort visitors.*
- **Hoaxes:** fake warnings that cause panic. A real example told people to delete the Windows file `jdbgmgr.exe` because it was a "virus." It was a normal system file. *Defense: check warnings with official sources before acting.*
- **Piggybacking and tailgating:** following an authorized person into a secure area. In **piggybacking** the employee knowingly lets them in (often just being polite). In **tailgating** the attacker slips in without being noticed. *Defense: everyone badges in separately, turnstiles, and **mantraps** (two-door entries that let one person through at a time).*

## Other methods of deception

- **Invoice scam:** a fake bill, or a "we've changed our bank details" message, sent to the finance team, hoping someone pays without checking. *Defense: confirm any new bank details by phone on a known number.*
- **Watering hole attack:** instead of attacking the targets directly, the attacker infects a website they visit often, like an industry news site. It's named after a predator waiting at a watering hole for animals to come and drink.
- **Typosquatting:** registering misspelled domains like `gooogle.com` or `paypa1.com` to catch typing mistakes. The fake site steals logins or installs malware.
- **Prepending:** adding something to the start to look trusted, like "RE:" or "SAFE:" in an email subject, or a trusted name in front of a domain, as in `paypal.com.secure-login.net`.
- **Influence campaigns:** large, organized efforts to change public opinion using fake news, fake accounts and bots. They're used in elections and conflicts between countries.

A trick I now use for links: look at the hostname (the part between `://` and the next `/`) and read it **from the right**. The last two parts are the real domain. In `paypal.com.secure-login.net`, the real domain is `secure-login.net`, not PayPal.

## Spotting the attack

Before acting on any unexpected message, I can ask:

1. Was I expecting this?
2. Is it rushing me?
3. Does it want a password, a code, money or personal data?
4. Is it making me feel scared, excited or guilty?
5. Do the sender address and link look *exactly* right?
6. Is it asking me to skip normal procedures?
7. Can I check it another way, like calling a number I already have?

Here's a phishing email I broke down using these questions:

```
From: IT Support <support@micros0ft-helpdesk.com>
Subject: URGENT: Your password expires today

All staff have already updated their passwords.
Click below within 2 hours to keep your account active.
[ Update Password ]
```

- `micros0ft` with a zero → typosquatting
- "URGENT", "within 2 hours" → urgency
- "All staff have already updated" → consensus
- "IT Support" → authority
- A button asking for a password → requesting sensitive data

The right action: don't click, report it.

## Defending against deception

Defense works when people, processes and technology work together:

- **People:** security awareness training, phishing simulations, and a culture where reporting a mistake quickly is encouraged, not punished.
- **Processes:** never share passwords with anyone; confirm money or access requests through a second channel; visitor sign-in and escorts; a clean desk policy; shredding.
- **Technology:** email filtering, **multi-factor authentication** (a stolen password alone isn't enough), web filtering and physical controls like badge readers.

## Why this matters for a SOC engineer

- **Phishing is still the most common first step** in real attacks, so analyzing reported emails is a big part of daily SOC work.
- **Business email compromise** (authority plus urgency emails asking for payments) causes huge losses. Detection rules often look for outside senders using executive names, or emails about changed bank details.
- **Typosquatted domains** can be detected automatically by comparing domains in logs against the company's real domain names.
- **Physical tricks leave digital traces.** A badge swipe with no matching computer login, or two people entering on one swipe, can be spotted in a SIEM.

## Questions I should be able to answer

- What is social engineering, and why does it work?
- Name the seven tactics and give an example of each.
- What's the difference between piggybacking and tailgating?
- How does a watering hole attack work?
- How would I check whether a link's domain is real?

## Next

Tomorrow: cyber attacks on the technology itself (logic bombs, DNS attacks, Layer 2 attacks, man-in-the-middle, zero-days and keyloggers) and then wireless and mobile attacks.
