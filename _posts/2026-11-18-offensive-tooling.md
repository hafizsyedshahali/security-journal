---
title: "Cyber Security 101, Part 14: Offensive Tooling (Hydra, Gobuster, Nikto)"
date: 2026-11-18 21:00:00 +0500
categories: [Daily Log, Cyber Security 101]
tags: [hydra, gobuster, nikto, enumeration, tryhackme]
---

This room was a set of command-line tools attackers use early in an attack: guessing passwords, finding hidden pages, and scanning web servers for known issues. I'm learning them so I can recognise what they look like from the defender's side, which is where I keep the focus in this post.

## Hydra: online password guessing

**Hydra** is a brute-force tool that tries many username and password combinations against a live service. Unlike John the Ripper, which cracks hashes offline, Hydra attacks the service directly over the network.

- **Features:** it supports many protocols, including SSH, FTP, RDP, and HTTP login forms, and can run many attempts in parallel.
- **Usage:**

```bash
# SSH
hydra -l admin -P rockyou.txt ssh://10.10.10.5

# HTTP POST login form
hydra -l admin -P rockyou.txt 10.10.10.5 http-post-form \
  "/login:username=^USER^&password=^PASS^:Invalid"
```

- `-l` is a single username (`-L` for a list)
- `-P` is a password list (`-p` for a single password)
- for web forms, `^USER^` and `^PASS^` are placeholders, and the last part is the text that appears on a **failed** login, so Hydra can tell success from failure

**Kali Hydra:** Hydra comes pre-installed on Kali Linux along with wordlists like rockyou.txt.

**What it looks like to a defender:** Hydra is loud. It generates many **failed login attempts** from one source in a very short time. On SSH that's a flood of "Failed password" lines in the auth log; on a web app it's many POST requests to the login page. This is exactly what account lockouts, rate limiting and brute-force alerts are built to catch.

## Gobuster: finding hidden content

**Gobuster** discovers things that aren't linked anywhere, by trying names from a wordlist and seeing what exists. It has three main use cases.

### Setup

Gobuster needs a target and a wordlist (SecLists is the common source). The mode is chosen with the first argument: `dir`, `dns` or `vhost`.

### Use case 1: directory and file enumeration

```bash
gobuster dir -u http://10.10.10.5 -w wordlist.txt
gobuster dir -u http://10.10.10.5 -w wordlist.txt -x php,txt,html
```

It requests `http://10.10.10.5/NAME` for each word and reports the status code. A `200` means the page exists; `403` means it exists but is forbidden. `-x` adds file extensions to try. This is how hidden admin panels and backup files get found.

### Use case 2: subdomain enumeration

```bash
gobuster dns -d example.com -w subdomains.txt
```

It tries `NAME.example.com` for each word and reports which resolve, finding subdomains like `dev.example.com` or `vpn.example.com` that aren't advertised.

### Use case 3: vhost enumeration

```bash
gobuster vhost -u http://10.10.10.5 -w subdomains.txt
```

**Virtual hosts** are different sites served from the same IP, chosen by the `Host` header. Vhost enumeration finds sites that only respond to a particular Host value, which directory scanning would miss.

**What it looks like to a defender:** a burst of requests for hundreds of non-existent paths, which shows up as a wall of **404s** in web logs from one source. That pattern is a strong sign someone is enumerating the server.

## Nikto: web server scanning

**Nikto** scans a web server for known problems: outdated software, dangerous default files, misconfigurations and missing security headers.

```bash
nikto -h http://10.10.10.5
```

It's fast but noisy, testing thousands of known issues, so it's easy to detect. It's best thought of as a quick first look that flags obvious issues to investigate further.

## A walkthrough room: putting tools together

The path included a guided room (the "ToolsRus" style box) that chains these together, which is the real lesson: tools are used in sequence, not alone.

1. **Nmap** to find open ports and services.
2. **Gobuster** to discover hidden directories on the web server.
3. **Nikto** to scan a directory it found for known issues.
4. **Hydra** to brute-force a login page that was discovered.
5. **Metasploit** (tomorrow's topic) to exploit a service whose version was identified.

Each tool's output feeds the next. From the defender's side, this same sequence appears across the logs as a story: a port scan, then a flood of 404s, then many failed logins, then an exploit attempt. Seeing those stages together is far more telling than any one alert alone.

## Why this matters for a SOC engineer

Every tool here leaves a recognisable trace: Hydra's failed logins, Gobuster's 404 storms, Nikto's and Nmap's distinctive requests. A SOC analyst who knows the offensive tools can look at a pile of alerts and say "this is enumeration, this is brute force, and they're the same actor working through the stages of an attack." That's the connection I most want to build.

## Questions I should be able to answer

- How is Hydra different from John the Ripper?
- In Hydra's http-post-form attack, what is the last field for?
- What are Gobuster's three modes, and what does each find?
- What is a virtual host, and why does vhost enumeration find sites directory scanning misses?
- What does each of these tools look like in web or auth logs?
- Why are tools used in sequence rather than alone?

## Next

Tomorrow: Metasploit, the framework that ties scanning and exploitation together.
