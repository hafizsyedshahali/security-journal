---
title: "Endpoint Security, Part 1: Threats, Vulnerabilities and Where Attacks Land"
date: 2026-10-31 14:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, endpoint-security, threats, vulnerabilities, apt, rootkits, threat-intelligence]
---

Today I started Cisco's **Endpoint Security** course, the next course in the Junior Cybersecurity Analyst path. The first section asks a simple question: **what can actually go wrong?**

My first surprise was that the answer isn't just "hackers." A broken hard drive, a power cut or a careless employee can cause as much damage as an attacker. This post is my notes on the different types of threats, where they hit an organization, and how defenders learn about them.

## Three words that come up everywhere

Before anything else, I wanted to be clear on three terms:

- **Asset:** anything valuable that needs protecting, like data, devices, software or reputation
- **Threat:** anything that could harm an asset, like an attacker, a flood or a bug
- **Vulnerability:** a weakness a threat can use, like an unpatched server or an unlocked door

A threat only causes damage when it meets a vulnerability. A burglar (threat) gets in through an unlocked window (vulnerability). We usually can't remove the threats, so most security work is about closing the weaknesses.

## Why we need cybersecurity

Banks, hospitals, power grids, shops and our phones all run on connected systems. The more we depend on them, the more it hurts when they fail. Cybersecurity is about keeping data **confidential**, **accurate** and **available**: the CIA triad from my last course.

## The eight types of threats

Not every threat is an attack. The course lists eight types:

| Threat | What it means | Example | Main defense |
|---|---|---|---|
| **Software attack** | A deliberate attack using software | A virus, or a DoS attack taking a website down | Antivirus, firewalls, patching |
| **Software error** | A bug in the software | An app crashes after an update, or shows one customer's data to another | Testing, patching |
| **Sabotage** | Deliberate damage, often by someone with access | An angry employee deletes files on their last day | Least privilege, backups |
| **Human error** | An honest mistake | Wrong data entered, or a firewall misconfigured | Training, reviews |
| **Theft** | Equipment or data stolen | A laptop stolen from a car | Encryption, physical security |
| **Hardware failure** | A physical part breaks | A hard drive crashes | Redundancy, backups |
| **Utility interruption** | Power, water or internet fails | A power cut or water leak in the server room | UPS, generators |
| **Natural disaster** | Nature damages equipment | Flood, earthquake, fire | Off-site backups, disaster recovery plan |

What I noticed: **backups** show up as a defense in almost every row. They protect against ransomware, sabotage, mistakes, broken hardware and disasters.

## Internal vs external threats

- **Internal threats** come from inside: employees, contractors or partners. They can be deliberate (stealing data) or accidental (clicking a phishing link). They're dangerous because insiders **already have access** and know where valuable data is, so their activity looks normal.
- **External threats** come from outside: criminals, hacktivists or other countries. They first have to find a way in, usually through a vulnerability or by tricking a user.

One point I liked: if an outside attacker steals an employee's password, they effectively become an insider. That's why you can't simply trust everything inside the network.

## User threats and vulnerabilities

Users are often called the weakest link, not because people are careless, but because attackers target people when technology is hard to break. The course lists seven user-related problems:

1. **No awareness of security:** users don't recognize phishing or know what to report. *Fix: regular training.*
2. **Poorly enforced security policies:** the rules exist on paper but nobody follows or checks them. *Fix: enforce with technology and audits.*
3. **Data theft:** a user copies sensitive data to take with them. *Fix: Data Loss Prevention (DLP) tools and monitoring.*
4. **Unauthorized downloads and media:** random software or unknown USB drives bring in malware. *Fix: block installs, control USB ports.*
5. **Unauthorized VPNs:** a user's own VPN creates an encrypted tunnel the security team can't see into. *Fix: allow only the company VPN.*
6. **Unauthorized websites:** risky sites can install malware just from a visit (a **drive-by download**). *Fix: web and DNS filtering.*
7. **Destruction of systems, applications or data:** on purpose or by accident. *Fix: least privilege, backups, logging.*

## Where threats land

An organization isn't one thing to protect. The course splits it into five areas, each with its own threats:

- **Devices (endpoints):** laptops, desktops and phones. Threats: unlocked unattended computers, unpatched software, malware, unknown USB drives. This is why the course is called *Endpoint* Security. Most attacks start on an endpoint.
- **Local area network (LAN):** unauthorized access to server rooms and wiring closets, rogue devices plugged into the network, misconfigured firewalls.
- **Private cloud** (the company's own data center): port scans, unauthorized access, misconfigured routers and firewalls.
- **Public cloud** (AWS, Azure, Google Cloud): data breaches, data loss, hijacked cloud accounts, compliance problems. From my AWS course: the provider secures the infrastructure, but the customer secures their own data and settings.
- **Applications:** servers going down, network scanning, data loss and corrupted data.

Protecting each area with its own layer of controls is called **defense in depth**. If one layer fails, the others still stand.

## Threat complexity: Advanced Persistent Threats

Attacks today can be very sophisticated. The main example is the **Advanced Persistent Threat (APT)**:

- **Advanced:** skilled, well-funded attackers with custom tools, usually a government or large criminal group
- **Persistent:** they stay hidden inside the network for months or even years
- **Threat:** they have a clear goal, usually stealing data or spying

A typical APT moves step by step: research the target → get in (often with a targeted phishing email) → install hidden access → quietly move to other systems → gain admin rights → steal data slowly while staying hidden.

They're hard to catch because they move slowly, use normal tools already on the system, and try to look like ordinary traffic. Stuxnet, which I wrote about earlier, was an APT.

## Backdoors and rootkits

These two often work together.

**Backdoor:** a hidden way into a system that skips the normal login. Attackers install one so they can come back even after a password is changed or a hole is patched. My notes mention two classic examples from 1998:

- **NetBus:** let an attacker remotely control a Windows computer: transfer files, log keystrokes, even open the CD tray
- **Back Orifice:** released by the group Cult of the Dead Cow, giving full remote control of Windows 95/98 machines

Both are old now, but they started the idea of the **Remote Access Trojan (RAT)**, which attackers still use today.

**Rootkit:** malware that hides deep inside the operating system. The name comes from "root," the most powerful account on Linux, plus "kit," a set of tools. It changes how the system works so the attacker's files and processes don't show up in normal tools. When you ask the system "what's running?", the rootkit removes itself from the answer. Rootkits often also give the attacker the highest level of access, which is called **privilege escalation**.

| | Backdoor | Rootkit |
|---|---|---|
| **Purpose** | Secret access | Hiding the attacker |
| **Detection** | Often visible to normal tools | Hides from normal tools |
| **Usual fix** | Remove it, change passwords | Wipe and reinstall the system |

Because a rootkit lies to the operating system, you can never be fully sure it's gone. That's why the safest fix is usually a complete reinstall.

## Threat intelligence

Defenders don't have to learn only from their own incidents. **Threat intelligence** is shared information about attackers, their tools and the signs they leave behind. Sources from my notes:

- **Dark web:** hidden parts of the internet, reached with tools like Tor, where criminals sell stolen data and hacking tools. Researchers monitor it to spot new threats or leaked company data early.
- **Indicators of Compromise (IOCs):** evidence that an attack happened, like a malicious IP address, a domain name, or a file **hash** (a unique fingerprint of a file). Security tools alert when they see a match.
- **Automated Indicator Sharing (AIS):** a free service from CISA, the US cybersecurity agency, that shares threat indicators between organizations automatically and in real time. It uses two standards: **STIX** (the format for describing threats) and **TAXII** (the way to send them between systems).

## Why this matters for a SOC engineer

- **Not every alert is an attack.** A server going offline might be a hardware failure or a power cut. Knowing all eight threat types helps rule things out.
- **Insider activity** matters. An employee downloading thousands of files at 2 AM is worth checking, even if they're allowed to.
- **APTs** are why SOCs actively hunt for small, quiet signs instead of waiting for loud alarms.
- **IOCs** feed into the SIEM so it alerts on known-bad IPs, domains and hashes. Automating these feeds is the kind of SOC engineering work I want to do.

## Questions I should be able to answer

- What's the difference between a threat and a vulnerability?
- Why are insider threats harder to detect than external ones?
- Why is an unauthorized VPN a risk?
- What makes an APT different from a normal attack?
- Backdoor vs rootkit: what does each one do?
- What is an IOC? Give two examples.

## Next

Tonight: deception and social engineering, the ways attackers trick people instead of computers.
