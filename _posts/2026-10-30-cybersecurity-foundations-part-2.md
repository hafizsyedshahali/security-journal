---
title: "Cybersecurity Foundations, Part 2: Malware, Social Engineering and Common Attacks"
date: 2026-10-30 21:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, malware, social-engineering, ddos, passwords]
---

This is the second half of my notes from Cisco's Introduction to Cybersecurity. Part 1 covered data, privacy, the McCumber Cube and the different kinds of attackers. This part covers how attacks actually work.

## Types of malware

Malware is any software written to damage, disrupt or gain unauthorized access to a system. The main types:

- **Virus:** attaches itself to a legitimate file and spreads when that file is run or shared
- **Worm:** spreads by itself across a network, with no user action needed. Worms can spread extremely fast.
- **Trojan horse:** pretends to be something useful, like a free game or a cracked app, but carries something harmful inside
- **Ransomware:** encrypts your files and demands payment for the key
- **Spyware:** secretly watches what you do, like keystrokes, browsing and passwords
- **Adware:** shows unwanted ads, and is often bundled with spyware
- **Backdoor:** gives an attacker a secret way back into a system, skipping normal login
- **Rootkit:** hides deep in the operating system to give the attacker high-level access and hide other malware
- **Scareware:** uses fake warnings, like "Your PC is infected!", to scare users into installing something or paying

## Symptoms of an infection

Malware doesn't always announce itself. Signs to watch for:

- CPU usage much higher than normal
- The computer freezing, crashing or running slowly
- Slow web browsing
- Network connections the user can't explain
- Files changed or deleted
- Unknown processes or programs running
- Security tools being turned off by themselves
- Emails sent from your account that you didn't write

From a SOC point of view, the last few are the most interesting. Unexplained network connections, disabled antivirus and unknown processes are exactly the kind of events a SIEM can alert on.

## Social engineering

Social engineering attacks the person, not the computer. It tricks people into giving away information or doing something they shouldn't. It works because people want to be helpful, trust authority, and react quickly under pressure.

Common types:

- **Phishing:** fake emails that look like they come from a trusted source, asking you to click a link or open a file
- **Spear phishing:** phishing aimed at one specific person, using details about them to look believable
- **Whaling:** spear phishing aimed at senior executives
- **Vishing:** phishing by voice call
- **Smishing:** phishing by SMS
- **Pretexting:** the attacker invents a story, like "I'm from IT and I need your password to fix your account"
- **Quid pro quo:** offering something in exchange for information, like a free gift for "a quick survey"
- **Tailgating:** physically following an authorized person through a secure door

The best defense is awareness: slowing down, checking the sender, and never sharing passwords, no matter who asks.

## Methods of infiltration

### Denial of Service (DoS)

A DoS attack overwhelms a system with traffic or requests so it can't serve real users. It doesn't usually steal data. It attacks **availability**.

### Distributed Denial of Service (DDoS)

A DDoS attack does the same thing, but from many machines at once. Because the traffic comes from thousands of different places, it is much harder to block.

### Botnets

A botnet is a network of infected computers and devices, called **bots** or **zombies**, all controlled by one attacker through a **command and control (C2) server**. The owners usually have no idea their device is part of it.

Botnets are used for DDoS attacks, sending spam, and spreading more malware. Poorly secured IoT devices, like cameras with default passwords, are a favorite target.

### Password attacks

- **Brute force:** trying every possible combination until one works
- **Dictionary attack:** trying common words and leaked passwords from a list
- **Password spraying:** trying a few common passwords, like `Password123`, against many accounts, to avoid account lockouts
- **Rainbow tables:** precomputed tables used to reverse password hashes quickly
- **Traffic interception:** capturing passwords sent over the network without encryption

Defenses: long and unique passwords, a password manager, multi-factor authentication (MFA), account lockout policies, and never sending passwords over unencrypted connections.

## Why this matters for a SOC engineer

This is where the course connected most directly with SOC work:

- **Password spraying** shows up in logs as many failed logins across many accounts from the same source. That's the Windows Event ID 4625 I looked at in my home lab, at a much larger scale.
- **Brute force** shows up as many failed logins against one account, often followed by a success. That pattern is worth an alert by itself.
- **Botnet infections** often show up as a device regularly "calling home" to the same external IP. Regular, repeating connections are a classic sign of C2 traffic.
- **Phishing** is still the most common first step in real attacks, so email security alerts are a big part of a SOC analyst's day.

Knowing what each attack looks like in the logs is the first step towards detecting and automating the response to it, which is exactly where I want to go.

## Next

Cisco's Endpoint Security course: protecting the devices themselves.
