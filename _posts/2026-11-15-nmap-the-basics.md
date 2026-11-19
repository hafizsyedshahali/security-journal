---
title: "Cyber Security 101, Part 7: Nmap Basics"
date: 2026-11-15 14:00:00 +0500
categories: [Daily Log, Cyber Security 101]
tags: [nmap, scanning, network-discovery, tryhackme]
---

**Nmap** (Network Mapper) answers two questions about a network: which hosts are up, and what are they running? Admins use it to inventory their own networks, penetration testers use it as a first step, and defenders need to recognise what a scan looks like in their logs.

One rule before anything else: only scan networks you own or have written permission to test. In TryHackMe, that's the lab machines.

## Telling Nmap what to scan

```bash
nmap 10.10.10.5            # one host
nmap 10.10.10.0/24         # a whole subnet (256 addresses)
nmap 10.10.10.1-20         # a range
nmap -iL targets.txt       # a list from a file
nmap -sL 10.10.10.0/24     # just list targets, don't scan them
```

## Discovering live hosts

Before scanning ports, it's useful to know which machines are actually up. `-sn` does host discovery only, without a port scan:

```bash
nmap -sn 10.10.10.0/24
```

How Nmap checks depends on where you are:

- **On the same local network:** it sends **ARP** requests, because any live device must answer ARP.
- **Across networks:** it uses **ICMP** echo requests, **TCP** packets to common ports (like 80 and 443), and sometimes **UDP**. Many firewalls block ping, so relying on ICMP alone misses hosts.

## Port scanning

A port can be **open** (a service is listening), **closed** (the host answered but nothing is listening) or **filtered** (no answer, usually because of a firewall).

The main scan types:

| Scan | Flag | How it works |
|---|---|---|
| **TCP connect** | `-sT` | completes the full TCP three-way handshake. Works without admin rights, but is easy to log. |
| **SYN ("half-open")** | `-sS` | sends a SYN; a SYN-ACK means open, and Nmap then sends a RST instead of completing the handshake. The default when run with admin rights. |
| **UDP** | `-sU` | sends UDP packets. Slower, because closed and filtered ports are harder to tell apart. |

Choosing ports:

```bash
nmap -p 22,80,443 10.10.10.5   # specific ports
nmap -p- 10.10.10.5            # all 65,535 ports
nmap -F 10.10.10.5             # the 100 most common ports
```

By default, Nmap scans the 1,000 most common ports.

## Version and OS detection

Knowing that port 80 is open isn't enough. You want to know which web server and which version, because vulnerabilities are tied to versions.

```bash
nmap -sV 10.10.10.5   # detect service versions
nmap -O 10.10.10.5    # guess the operating system
nmap -A 10.10.10.5    # OS detection, versions, default scripts and traceroute together
```

`-sV` might show, for example, that port 22 runs a specific OpenSSH version. That version can then be checked against known vulnerabilities, which connects to the vulnerability scanning and CVSS topics later in the path.

## Timing: how fast is fast?

Nmap has six timing templates, from `-T0` to `-T5`:

| Template | Name | Use |
|---|---|---|
| `-T0` | paranoid | extremely slow, to avoid detection |
| `-T1` | sneaky | very slow |
| `-T2` | polite | slow, uses less bandwidth |
| `-T3` | normal | the default |
| `-T4` | aggressive | faster, common in labs and CTFs |
| `-T5` | insane | fastest, may miss results or overload weak networks |

Faster isn't always better. Fast scans are noisy, and on unstable networks they can miss open ports.

## Output: what you see and what you save

```bash
nmap -v 10.10.10.5                 # more detail while it runs (-vv for even more)
nmap -oN scan.txt 10.10.10.5       # normal text output
nmap -oX scan.xml 10.10.10.5       # XML, good for other tools
nmap -oG scan.gnmap 10.10.10.5     # "grepable" format
nmap -oA scan 10.10.10.5           # all three formats at once
```

Saving results matters. In a real assessment, the scan output is evidence you'll come back to, and XML output can be fed into other tools or scripts.

## Common options in one place

| Option | Meaning |
|---|---|
| `-sn` | host discovery only |
| `-sT` / `-sS` / `-sU` | connect, SYN and UDP scans |
| `-p`, `-p-`, `-F` | choose ports |
| `-sV` | service versions |
| `-O` | OS detection |
| `-A` | aggressive: OS, versions, scripts, traceroute |
| `-T0` to `-T5` | timing |
| `-Pn` | skip host discovery and treat the host as up |
| `-n` | no DNS resolution |
| `-oN`, `-oX`, `-oG`, `-oA` | save output |

## What a scan looks like to a defender

This is the part most relevant to me. From the defender's side, a port scan usually shows up as:

- one source IP sending connection attempts to **many ports** or **many hosts** in a short time
- lots of **SYN packets** followed by **RST** packets, with few completed connections
- IDS alerts like "possible port scan", and firewall logs full of denied connections

A scan by itself isn't an attack, and internet-facing servers are scanned constantly. But a scan from **inside** the network, from a normal workstation, is very suspicious, because it suggests someone is mapping the network after getting in.

## Questions I should be able to answer

- What does `-sn` do, and how does Nmap find live hosts on a local network?
- What do open, closed and filtered mean?
- What's the difference between a connect scan and a SYN scan?
- Why are UDP scans slow?
- What do `-sV`, `-O` and `-A` add?
- What are the timing templates, and what's the trade-off with faster scans?
- What does a port scan look like in logs and network traffic?

## Next

Tonight: cryptography. Symmetric and asymmetric encryption, RSA, Diffie-Hellman, certificates and PGP.
