---
title: "Looking Back: My Junior Cybersecurity Analyst Journey So Far"
date: 2026-11-11 21:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, career-change, learning-journey, soc, reflection]
---

A few weeks ago I started this journal with one goal: write every day about what I study as I move from AI automation into cybersecurity. I've now finished every course in Cisco's Junior Cybersecurity Analyst Career Path, and with the last posts from it written up, this felt like the right moment to stop and look back before moving on to the next stage.

This post isn't about a new topic. It's about how it went, what I learned, and what comes next.

## Where I started

My background is in AI automation and data. I've built workflows in Zapier and n8n, pipelines in Databricks, dashboards in Power BI, and worked on information security tasks across business systems. I knew a fair amount about building things. I knew much less about how they get attacked and defended.

The goal is a **SOC Engineer** role, not just an analyst role, because I want to combine security with what I already do well: automation. My mentor, who leads information security at a large company, gave me a clear order to follow (hardware and IT basics, then networking, then cloud, then security) and two pieces of advice that shaped all of this: write a blog post every night about what I studied, and keep applying for jobs even when the odds feel low.

## What I covered

Before this blog, I went through A+ and Network+ training material to build the basics. Then, in roughly the order I studied them:

- **Networking:** the OSI and TCP/IP models, cables and switching, subnetting, routing, IPv4 and IPv6, ARP, DNS, DHCP, TCP and UDP, and basic Cisco IOS
- **Cloud:** AWS Cloud Practitioner Essentials, including the shared responsibility model, VPCs, IAM and CloudTrail
- **Introduction to Cybersecurity:** the CIA triad, the McCumber Cube, attackers, malware and social engineering
- **Endpoint Security:** threats and vulnerabilities, deception, network and application attacks, how attackers abuse IP, TCP, ARP, DNS and DHCP, network defenses, Windows and Linux security
- **Network Defense:** defense in depth, access control and AAA, ACLs, firewalls and zone-based policy firewalls, cloud security, cryptography, and security monitoring with Security Onion, Snort and SIEMs
- **Cyber Threat Management:** governance and laws, security frameworks, vulnerability assessment and CVSS, risk management, digital forensics, the kill chain, and incident response

Along the way I earned the course certificates and the Junior Cybersecurity Analyst Career Path certificate from Cisco Networking Academy.

## How I studied

My method was simple. I watched and read each section, wrote handwritten notes in a notebook (mostly just headings and key terms), and then turned those notes into a post here. Writing the posts was where the real learning happened. A heading like "ARP cache poisoning" in my notebook doesn't mean much until I have to explain step by step how it works and why a switch feature like Dynamic ARP Inspection stops it.

Some days I covered a lot and the posts were long. Some days less. I didn't manage a perfect one-post-every-night rhythm, and some days I had to catch up on writing after studying. But I kept going, and the blog now holds everything I've learned in one place.

## What clicked

A few things changed how I think:

- **Most attacks abuse trust, not genius.** ARP accepts any reply, DHCP trusts the first server, IP doesn't check source addresses, and people trust an urgent email from "the CEO." Once I saw that pattern, a lot of attacks made sense.
- **Defense is layers, not a wall.** No single tool stops everything. Firewalls, IPS, endpoint protection, logging, training and good processes all cover each other's gaps.
- **Logs are everything.** Almost every topic ended with the same question: what would this look like in the logs? Event IDs, syslog, DNS logs, NetFlow, firewall logs. That's the raw material a SOC works with.
- **Security is also people and process.** Governance, policies, risk management and incident response felt dry at first, but they're what turn technical controls into an organization that can actually respond when something goes wrong.

## What was hard

Some parts took real effort. Subnetting and wildcard masks needed practice before they became natural. Cryptography had a lot of moving parts until I separated what each tool is for: encryption for confidentiality, hashing for integrity, signatures and HMACs for authentication. And the volume itself was a challenge: there's a lot of material, and it's easy to rush through videos without really understanding them. Writing these posts was what stopped me from doing that.

## Where my automation background fits

The more I learned, the more I saw where automation fits in. SOCs deal with huge numbers of alerts, and much of the work is repetitive: enriching an IP address with threat intelligence, checking a file hash, opening a ticket, isolating a machine. That's exactly what SOAR platforms and automation are for, and it's the kind of work I've been doing for years in other areas. That's the direction I want to grow in: security operations plus automation.

## What's next

The courses gave me the foundation. Now I need hands-on practice:

1. **TryHackMe SOC Level 1:** practical work with SIEMs, log analysis, network traffic analysis, phishing analysis and incident response, in realistic labs
2. **Building out my home lab:** more practice with real tools, logs and detections
3. **Security automation projects:** applying my automation background to security tasks and sharing them on GitHub
4. **Keep applying,** as my mentor advised, and keep improving with every application and interview
5. **A certification exam:** I'm still deciding which one makes the most sense as the next step

And I'll keep writing here every day.

## A thank you

Thanks to my mentor for the direction and for pushing me to write publicly, and to everyone who has read along. If you're also moving into cybersecurity from another field: start with the fundamentals, write down what you learn, and don't worry about how slow it feels. It adds up.
