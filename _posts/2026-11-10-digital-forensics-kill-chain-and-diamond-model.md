---
title: "Cyber Threat Management, Part 6: Digital Forensics, the Cyber Kill Chain and the Diamond Model"
date: 2026-11-10 21:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, digital-forensics, chain-of-custody, mitre-attack, cyber-kill-chain, diamond-model, incident-analysis]
---

This was my favorite section of the course. It's about what happens after an attack is spotted: collecting evidence properly, and using models like the Cyber Kill Chain and the Diamond Model to understand what the attacker did and how to stop them next time.

## Digital forensics

**Digital forensics** is the recovery and investigation of evidence from computers, networks and other digital devices. It answers questions like what happened, when, how, and who was involved, in a way that can stand up in court if needed.

Organizations need it for internal investigations (like an employee stealing data), for responding to attacks, and for legal cases.

## The digital forensics process

NIST describes four steps:

1. **Collection:** identify, label and gather data from possible sources, like hard drives, memory, logs and network captures, while preserving its integrity.
2. **Examination:** process the collected data to extract what's relevant, for example recovering deleted files or filtering huge logs down to the important entries.
3. **Analysis:** draw conclusions from the data: building a timeline, linking events together, and working out what actually happened.
4. **Reporting:** present the findings clearly: what was found, how it was found, what it means, and what should be done next.

## Types of evidence

- **Best evidence:** the original evidence itself, like the actual hard drive from a suspect's computer. Courts prefer it.
- **Corroborating evidence:** supports another piece of evidence. For example, firewall logs that show the same connection as the server's logs.
- **Indirect evidence** (circumstantial evidence): doesn't prove something directly but suggests it when combined with other facts. For example, a user logging in shortly before files were deleted.

## Evidence collection order

Some data disappears quickly, like what's in memory, which is lost when the computer is turned off. So evidence is collected from the **most volatile to the least volatile**. The usual order is:

1. **CPU registers and cache**
2. **memory (RAM), routing table, ARP cache, process table and kernel statistics**
3. **temporary file systems**
4. **non-volatile storage**, like hard drives
5. **remote logging and monitoring data**
6. **physical configuration and network topology**
7. **archived media**, like backups

That's why a common rule is: don't just switch off a compromised computer. You'd lose the memory, which may contain malware that never touched the disk.

### Collection priority

Investigators also have to balance volatility with practical concerns: how valuable each source is likely to be, how much effort it takes, and whether the system can be taken offline at all.

## Chain of custody

**Chain of custody** is the documented record of everyone who handled a piece of evidence, when, and what they did with it, from the moment it was collected. If there's a gap, a court may reject the evidence, because nobody can prove it wasn't tampered with.

## Data integrity and preservation

Evidence must not change. Investigators:
- use **write blockers**, devices that let them read a disk without being able to write to it
- make an exact **forensic copy** (image) and analyze the copy, never the original
- calculate a **hash** of the original and the copy, so they can prove later that nothing changed

```bash
sha256sum evidence_disk.img
```

If the hash is the same at the start and end of the investigation, the evidence is intact.

## Attack attribution

**Attribution** means working out who was behind an attack. It's hard: attackers hide behind compromised systems and VPNs, use common tools, and sometimes plant false clues. Analysts look at **TTPs** (tactics, techniques and procedures), the malware used, infrastructure and timing. Attribution matters most for law enforcement and governments. For most companies, understanding *how* the attack worked is more useful than knowing *who* did it.

## The MITRE ATT&CK framework

**MITRE ATT&CK** is a huge, free knowledge base of real attacker behavior, built from observed attacks. It's organized as:
- **tactics:** the attacker's goal at each stage, like initial access, persistence, privilege escalation, credential access, lateral movement and exfiltration (the enterprise matrix has 14 tactics)
- **techniques:** how they achieve that goal, each with an ID. For example, **T1566** is Phishing.
- **sub-techniques:** more specific versions, like T1566.001, spearphishing with an attachment

SOCs use ATT&CK to describe incidents in a common language, map their detections to see which techniques they can and can't catch, and plan what to improve.

## The Cyber Kill Chain

The **Cyber Kill Chain**, developed by Lockheed Martin, breaks an attack into seven steps. The idea is that if defenders break *any* link in the chain, the attack fails. For each step, the course looked at what the attacker does and how a SOC defends.

### 1. Reconnaissance

- **Adversary tactics:** research the target: employee names and emails from LinkedIn, the company website, public IP ranges, and scanning for open ports and services.
- **SOC defense:** watch for scanning activity in firewall and IDS logs, limit what's publicly shared, and detect browsing patterns typical of reconnaissance.

### 2. Weaponization

- **Adversary tactics:** build the attack tool, for example pairing an exploit with malware inside a document.
- **SOC defense:** this happens on the attacker's side, so it can't be seen directly. Defenders prepare instead: keep systems patched, use threat intelligence to learn about current malware, and analyze samples to build detections.

### 3. Delivery

- **Adversary tactics:** send the weapon to the target: phishing emails, malicious websites, infected USB drives.
- **SOC defense:** email and web filtering, user awareness training, and blocking known-bad domains and attachments. This is one of the best places to break the chain.

### 4. Exploitation

- **Adversary tactics:** trigger the exploit, using a vulnerability or tricking a user, to run code on the target.
- **SOC defense:** patching, endpoint protection and EDR, and least privilege so the exploit has less power.

### 5. Installation

- **Adversary tactics:** install malware or a backdoor so they can stay, often with persistence like registry Run keys or new services.
- **SOC defense:** HIDS and EDR alerts on new services, scheduled tasks and registry changes, and application allowlisting.

### 6. Command and Control (C2)

- **Adversary tactics:** the malware contacts the attacker's server for instructions, often over HTTPS or DNS to blend in.
- **SOC defense:** monitor outbound traffic for beaconing (regular, repeating connections), block known C2 domains and IPs, and use DNS monitoring to catch tunneling and DGAs.

### 7. Actions on Objectives

- **Adversary tactics:** do what they came for: steal data, encrypt files for ransom, or move to other systems.
- **SOC defense:** detect unusual data transfers and lateral movement, DLP, and a fast incident response to contain the damage.

The earlier in the chain an attack is stopped, the less damage it does.

## The Diamond Model of intrusion analysis

### Overview

The **Diamond Model** describes every intrusion event with four connected core features, drawn as the corners of a diamond:

- **Adversary:** the attacker, whether a person or group
- **Capability:** the tools and techniques used, like malware or an exploit
- **Infrastructure:** what the attacker used to deliver and control the attack, like IP addresses, domains and email accounts
- **Victim:** the target, whether a person, organization, system or data

Every event connects these four: an adversary uses a capability over infrastructure against a victim.

It also has **meta-features** that add context:
- **Timestamp:** when the event happened
- **Phase:** which stage of the attack it belongs to (like the kill chain stages)
- **Result:** whether it succeeded, failed or is unknown
- **Direction:** which way it went, like adversary to victim or victim to infrastructure
- **Methodology:** the general type of attack, like phishing or a port scan
- **Resources:** what was needed, like software, knowledge, money or access

### Pivoting across the Diamond Model

The model's real power is **pivoting**: starting from one known corner and using it to discover the others.

For example:
1. An analyst finds a malware sample on a victim's laptop (**capability**).
2. Analyzing it reveals the domain it contacts (**infrastructure**).
3. Searching DNS logs for that domain finds three other infected machines (**more victims**).
4. Threat intelligence on that domain links it to a known criminal group (**adversary**).

Each pivot reveals more of the attack. Combined with the kill chain, it gives a full picture of what happened and where to look next.

## Why this matters for a SOC engineer

This section is basically how incidents get investigated. Collecting evidence in the right order and keeping chain of custody makes investigations hold up. ATT&CK is the shared language for describing what attackers did and which detections a SOC has. The kill chain shows where to break an attack, and the Diamond Model shows how to turn one clue into the full picture.

## Questions I should be able to answer

- What are the four steps of the digital forensics process?
- Best vs corroborating vs indirect evidence?
- Why is evidence collected from most volatile to least volatile? Give the order.
- What is chain of custody, and why does it matter?
- How do hashes and write blockers protect evidence?
- What's the difference between a tactic and a technique in MITRE ATT&CK?
- Name the seven steps of the Cyber Kill Chain, with one defense for each.
- What are the four core features of the Diamond Model? What is pivoting?

## Next

Incident response and disaster recovery.
