---
title: "Cyber Threat Management, Part 3: Network Security Testing and Threat Intelligence"
date: 2026-11-09 14:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, vulnerability-scanning, nmap, penetration-testing, siem, soar, threat-intelligence, mitre]
---

This part of Cyber Threat Management was about finding weaknesses before attackers do, through security testing, and about learning from what's happening to others, through threat intelligence.

## Security assessments

A **security assessment** is a planned check of how secure a network or system really is. It can be as simple as a vulnerability scan or as deep as a full penetration test.

### Vulnerability scanners

A **vulnerability scanner** checks systems for known weaknesses: missing patches, outdated software, weak settings, default passwords and open services. It compares what it finds against a database of known vulnerabilities and produces a report, usually with a severity score for each finding. Common scanners include **Nessus**, **OpenVAS** and **Qualys**.

### Types of scans

Scans can be grouped by what they look at:
- **network scans:** find live hosts, open ports and running services
- **host scans:** check individual systems for missing patches and bad configurations
- **application scans:** look for weaknesses in applications, especially web apps (like SQL injection and XSS)
- **wireless scans:** find access points, including rogue ones, and check wireless security settings
- **database scans:** check databases for weak settings and vulnerabilities

### Intrusive and credentialed scans

Two settings change how deep a scan goes:

- An **intrusive** scan actually tries to exploit a weakness to confirm it's real. It gives more certain results but can crash services, so it's used carefully, often outside business hours. A **non-intrusive** scan only looks and reports.
- A **credentialed** scan logs in to the system with an account, so it can see installed software, patch levels and settings from the inside. It's far more accurate. A **non-credentialed** scan only sees what an outsider can see, which is useful for knowing what an attacker would find, but it misses a lot.

## Command-line diagnostic utilities

Simple built-in commands are still some of the most useful testing tools:

- `ping`: is a host reachable?
- `tracert` (Windows) / `traceroute` (Linux): which path do packets take?
- `ipconfig` / `ip a`: what are this machine's network settings?
- `nslookup` / `dig`: does DNS resolve correctly, and to what?
- `netstat` / `ss`: which connections and listening ports are open?
- `arp -a`: which MAC addresses are linked to which IPs on the local network?

They're quick, available everywhere, and often enough to spot a problem before reaching for bigger tools.

## Security automation: SIEM and SOAR

- A **SIEM** collects and correlates logs from across the network and raises alerts. I covered it in my Network Defense posts.
- **SOAR** (Security Orchestration, Automation and Response) takes the next step: it **acts** on alerts automatically, using **playbooks**. For example, when a phishing alert arrives, a SOAR playbook can pull the email's links and attachments, check them against threat intelligence, block the sender, and open a ticket, all in seconds and without a person doing each step.

This is the part of security closest to my background. I've spent years building automations in tools like Zapier and n8n, and SOAR is the same idea applied to security. It's exactly where I want to focus.

## Network security testing techniques

### Operations security

**Operations security** covers the day-to-day practices that keep a network secure: change management, monitoring, patching, backups and access reviews. Testing is part of this: it checks whether those practices are actually working.

### Testing and evaluating network security

Testing should happen regularly, not just once. It's used during the **design** of a network (to check the plan), during **implementation** (to check it was built correctly), and during **operation** (to catch new weaknesses as things change).

### Types of network tests

The course listed several:
- **penetration testing:** simulating a real attack to see how far an attacker could get
- **network scanning:** finding hosts, open ports and services
- **vulnerability scanning:** finding known weaknesses
- **password cracking:** testing how strong users' passwords really are
- **log review:** checking logs for signs of problems or attacks
- **integrity checkers:** detecting unexpected changes to important files
- **virus detection:** scanning for malware

### Applying network test results

Test results are only useful if they lead to action. They're used to define what needs fixing and in what order, to measure progress over time, and to check how well the organization's security posture matches its policies.

## Network testing tools

- **Nmap** is the best-known network scanner. It finds hosts, open ports, running services and even operating systems. **Zenmap** is its graphical interface.

  ```bash
  nmap -sV -p 1-1000 192.168.1.0/24
  ```

  This scans ports 1 to 1000 on every host in the 192.168.1.0/24 network. `-sV` asks Nmap to identify which service and version is running on each open port, which shows whether outdated, vulnerable software is exposed.

- **SuperScan** is an older, free Windows tool for port scanning and basic host discovery.
- A **SIEM** is also a testing aid: after a test, you can check whether the SIEM actually detected and alerted on the test activity. If it didn't, there's a gap in monitoring.

Other common tools include Metasploit (exploitation), Wireshark (packet analysis) and password crackers like John the Ripper.

> Scanning or testing networks without written permission is illegal.

## Penetration testing

A **penetration test** (pen test) is an authorized, simulated attack. It shows not just *that* a weakness exists, but what an attacker could actually achieve with it.

### Black box, gray box and white box testing

- **Black box:** the testers get no information in advance, just like a real outside attacker. Most realistic, but slower.
- **Gray box:** the testers get some information, like a normal user account or a network diagram. This simulates an attacker who has some inside knowledge.
- **White box:** the testers get full information: network diagrams, source code, credentials. This is the most thorough and finds the most issues in the time available.

### The four phases of a penetration test

1. **Planning:** agree on the scope, rules and goals in writing. What can be tested, when, and what's off-limits.
2. **Discovery:** gather information and scan for weaknesses.
3. **Attack:** try to exploit the weaknesses, gain access, escalate privileges and move further in.
4. **Reporting:** document everything found, how serious it is, and how to fix it.

### Exercise types

Organizations also run team exercises:
- the **red team** plays the attacker
- the **blue team** defends (this is the SOC's role)
- the **purple team** combines both, with attackers and defenders working together so each attack is used to improve detection right away
- a **white team** often referees and sets the rules

### Packet analyzers and their output

During testing (and investigations), a **packet analyzer** like Wireshark or tcpdump captures traffic, and a **protocol analyzer** decodes it into readable fields: source and destination addresses, ports, protocol, flags and payload. Reading that output shows exactly what a test (or an attacker) sent, and how the target responded.

## Threat intelligence

**Threat intelligence** is information about current threats: who's attacking, how, and what signs they leave. It lets an organization prepare for attacks it hasn't seen yet.

### Information sources: network intelligence communities

- **SANS:** a major security training organization. It runs the **Internet Storm Center**, which tracks threats daily, and publishes newsletters and research.
- **MITRE:** maintains the **CVE** list of publicly known vulnerabilities and the **ATT&CK** framework of attacker techniques.
- **FIRST** (Forum of Incident Response and Security Teams): a global community of incident response teams. It also maintains **CVSS**, the vulnerability scoring system.
- **SecurityNewsWire:** a security news site that collects alerts, news and vulnerability information.
- **(ISC)²:** a professional organization known for certifications like CISSP, which also offers training and resources.
- **CIS** (Center for Internet Security): publishes the CIS Controls and secure configuration benchmarks, and runs the **MS-ISAC** for US state and local governments.

### Threat intelligence services

- **Cisco Talos:** one of the largest commercial threat intelligence teams. Its data powers Cisco's security products, and it publishes research and reputation data.
- **FireEye:** a well-known security company famous for its threat research and incident response. (Its products are now part of **Trellix**, and its Mandiant division is now part of Google.)
- **Automated Indicator Sharing (AIS):** CISA's free, real-time system for sharing threat indicators between organizations, which I wrote about in my Endpoint Security posts.
- **CVE database:** the public list of known vulnerabilities. Each gets an ID like `CVE-2021-44228` (Log4Shell), so everyone refers to the same issue the same way.

### Threat intelligence communication standards

For intelligence to be shared automatically between tools, it needs common formats:
- **STIX** (Structured Threat Information Expression): a standard format for describing threats, indicators and attacker behavior
- **TAXII** (Trusted Automated Exchange of Intelligence Information): the protocol for sending STIX data between systems
- **CybOX:** an older standard for describing observable events, now merged into STIX

### Threat intelligence platforms

A **threat intelligence platform (TIP)** collects intelligence from many feeds, removes duplicates, scores it, and pushes it to security tools like the SIEM and firewalls. **MISP** and **OpenCTI** are well-known open-source examples.

## Why this matters for a SOC engineer

Vulnerability scan results tell a SOC which systems are most at risk, which helps prioritize alerts. Pen tests and purple team exercises check whether the SOC actually detects attacks. And threat intelligence feeds the SIEM's detections every day. SOAR, meanwhile, is where my automation experience can make a real difference.

## Questions I should be able to answer

- What's the difference between an intrusive and a non-intrusive scan? Credentialed vs non-credentialed?
- What does SOAR add on top of a SIEM?
- What does `nmap -sV` do?
- Black box vs gray box vs white box testing?
- What are the four phases of a penetration test?
- What do red, blue and purple teams do?
- Name some threat intelligence sources and services.
- What are STIX and TAXII?

## Next

Endpoint vulnerability assessment: profiling networks and servers, and how vulnerabilities are scored with CVSS.
