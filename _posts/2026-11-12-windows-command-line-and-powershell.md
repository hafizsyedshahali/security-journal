---
title: "Cyber Security 101, Part 2: Windows Command Line and PowerShell"
date: 2026-11-12 21:00:00 +0500
categories: [Daily Log, Cyber Security 101]
tags: [windows, powershell, cmd, netstat, tryhackme]
---

This afternoon was Linux. Tonight's part was Windows: the built-in security features from Windows Fundamentals Part 3, the classic command-line networking tools, and then PowerShell, which is where most serious Windows administration and investigation happens.

## Windows Fundamentals Part 3: built-in protection

Windows ships with several security features that an analyst should recognise:

- **Windows Update** patches vulnerabilities. Many real attacks succeed only because a patch was never installed.
- **Windows Security / Microsoft Defender** provides antivirus, firewall settings and device protection in one place.
- **Windows Defender Firewall** filters traffic with separate profiles for domain, private and public networks.
- **BitLocker** encrypts the whole drive, so a stolen laptop doesn't mean stolen data.
- **Volume Shadow Copy Service (VSS)** keeps snapshots of files for recovery. Ransomware often tries to delete these copies first, so deleting shadow copies is a strong warning sign in logs.

## Classic command-line tools

These run in Command Prompt (and also work in PowerShell). They're the first things I'd reach for to understand a machine's network situation.

| Command | What it shows | When it helps |
|---|---|---|
| `ipconfig /all` | IP address, subnet mask, gateway, DNS servers, MAC address, DHCP details | checking how a machine is configured |
| `ping example.com` | whether a host replies and how long it takes | basic "is it reachable" test |
| `tracert example.com` | each router hop on the way to a host | finding where a connection breaks |
| `nslookup example.com` | the IP a name resolves to, and which DNS server answered | checking DNS, or a suspicious domain |
| `netstat` | active network connections | seeing who the machine is talking to |

### netstat -abon

`netstat -abon` is the version worth remembering:

- **`-a`** shows all connections and listening ports
- **`-b`** shows the program that owns each connection (needs an admin prompt)
- **`-o`** shows the process ID (PID)
- **`-n`** shows addresses and ports as numbers, without slow name lookups

With this, you can spot something like an unknown program holding a connection to an external IP on an unusual port, and then take its PID to Task Manager or PowerShell to find out what it is.

## What PowerShell is

**PowerShell** is Microsoft's shell and scripting language, built on .NET. The key difference from Command Prompt is that PowerShell works with **objects**, not plain text. When a command returns a list of processes, each one is an object with properties (name, ID, CPU, path) that you can filter and sort directly.

## PowerShell basics

PowerShell commands are called **cmdlets** and follow a **Verb-Noun** pattern, which makes them easy to guess:

```powershell
Get-Help Get-Process        # how to use a cmdlet
Get-Command -Noun Service   # find cmdlets that work with services
Get-Alias                   # shortcuts, like ls for Get-ChildItem
```

`Get-Help` and `Get-Command` are the two I used most, because they let you find your way without memorising everything.

## Navigating the file system and working with files

```powershell
Get-ChildItem                  # list files (alias: ls, dir)
Set-Location C:\Users          # change folder (alias: cd)
New-Item -Path notes.txt -ItemType File
Copy-Item notes.txt backup.txt
Move-Item backup.txt C:\Temp\
Remove-Item notes.txt
Get-Content C:\Temp\backup.txt # read a file (alias: cat)
```

## Piping, filtering and sorting

The pipe `|` sends the output of one cmdlet into the next. Because PowerShell passes objects, you can filter on real properties:

```powershell
Get-ChildItem | Sort-Object Length -Descending
Get-ChildItem | Where-Object -Property Extension -eq ".ps1"
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
```

- **`Sort-Object`** orders results
- **`Where-Object`** keeps only items that match a condition (operators like `-eq`, `-ne`, `-gt`, `-lt`, `-like`)
- **`Select-Object`** picks properties or limits how many results come back
- **`Select-String`** searches inside files for text, like `grep` on Linux

## System and network information

```powershell
Get-ComputerInfo                 # OS, version, hardware details
Get-LocalUser                    # local accounts and whether they're enabled
Get-NetIPConfiguration           # network settings
Get-NetIPAddress                 # IP addresses on each interface
```

`Get-LocalUser` is a quick way to spot an unexpected account, which is a common sign of persistence.

## Real-time system analysis

```powershell
Get-Process                      # running processes
Get-Service                      # services and their status
Get-NetTCPConnection             # current TCP connections (like netstat, but as objects)
Get-FileHash .\file.exe          # SHA-256 hash of a file
```

`Get-FileHash` connects straight to SOC work: you hash a suspicious file and check the hash against threat intelligence, like VirusTotal, without ever opening the file.

## Scripting

PowerShell scripts are saved as `.ps1` files and can automate everything above: collecting logs from many machines, checking for a known bad hash, or building a quick report. `Invoke-Command` can run the same commands on remote computers.

Two security notes:

- The **execution policy** controls whether scripts can run. It's a safety setting, not a real security barrier, because it can be bypassed easily.
- Attackers love PowerShell for the same reason admins do: it's built in and powerful. That's why **PowerShell logging** (script block logging, Event ID 4104) is so valuable to a SOC.

## Why this matters for a SOC engineer

When an alert fires on a Windows machine, the first questions are usually: what's running, what's it connected to, which accounts exist, and is this file known to be bad? The commands in this post answer all four. And PowerShell is the natural tool for automating those checks, which is exactly where my automation background fits.

## Questions I should be able to answer

- What does each flag in `netstat -abon` do?
- What's the difference between `ping`, `tracert` and `nslookup`?
- How is PowerShell different from Command Prompt?
- What pattern do cmdlet names follow?
- How would you list the five processes using the most CPU?
- Why is deleting Volume Shadow Copies a warning sign?
- Why do both admins and attackers like PowerShell, and how does logging help?

## Next

Tomorrow: Active Directory, the system that manages users and computers in almost every company network.
