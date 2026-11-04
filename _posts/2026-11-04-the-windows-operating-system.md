---
title: "Endpoint Security, Part 9: The Windows Operating System"
date: 2026-11-04 11:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, windows, registry, event-viewer, ntfs, boot-process]
---

Today is the last day of the Endpoint Security course, and there's a lot left, so I'm writing four shorter posts instead of two long ones. This first one is about Windows.

I've used Windows my whole life, but this section made me look at it differently. The question wasn't "how do I use it" but "where would an attacker hide, and where would I look for them?"

## From DOS to today

Before Windows there was DOS, the Disk Operating System. It was text only: no mouse, no windows, just commands like `dir` and `cd`. Early versions of Windows actually ran on top of DOS. Modern Windows (XP, 7, 10, 11) is built on the Windows NT family instead, and comes in Home, Pro and Enterprise editions, plus a separate Windows Server line.

The graphical side (desktop, Start menu, taskbar, File Explorer) is what most people see. But the command line never went away. Command Prompt and PowerShell are still there, and as a defender I'll be using them a lot.

## Where Windows is usually weak

The course listed the mistakes that keep showing up on real machines:

- no antivirus, or one that's switched off or out of date
- unknown or unmanaged services running in the background that nobody has checked
- no encryption, so a stolen laptop means stolen data
- no security policy for passwords, lockouts or logging
- the firewall turned off or badly configured
- file and share permissions that let everyone read everything
- weak passwords, or none at all
- people logging in as Administrator for everyday work

The last one stuck with me. If you browse the web as an admin and pick up malware, the malware gets admin rights too. Using a normal account for daily work and admin only when needed fixes a lot of problems at once.

## How Windows is built

The **Hardware Abstraction Layer (HAL)** sits between the hardware and the kernel. Its job is to hide the differences between hardware, so Windows can run on many different machines without the kernel needing to know the details of each one.

Code in Windows runs in one of two modes. Normal apps like a browser run in **user mode**. Each app gets its own private memory and limited access, so if it crashes, only that app closes. The kernel and most drivers run in **kernel mode**, with full access to hardware and memory. A crash there can take down the whole system, which is the famous blue screen. It also explains why kernel-level malware like rootkits is so dangerous: it runs with the same power as Windows itself.

## File systems

A file system decides how files are stored on a disk. My notes list four: exFAT, HFS+, EXT and NTFS. One correction to my own notes here: I wrote them all under "Windows file system," but only exFAT and NTFS (and the older FAT32) are actually Windows file systems. HFS+ is Apple's older system and EXT is Linux's. The course just compares them together.

- **exFAT** is simple and works almost everywhere, which is why USB drives and camera cards use it. But it has no file permissions, so anyone can read anything on it.
- **NTFS** is what Windows uses for its main drive. It supports permissions, encryption and journaling. Journaling means it writes down changes before making them, so it can recover cleanly after a crash or power cut.

## Alternate Data Streams

This was new to me. On NTFS, a file can carry extra hidden data called an **Alternate Data Stream (ADS)**. It doesn't show up in normal folder listings and doesn't change the file size you see in Explorer.

```
echo hidden text > report.txt:secret.txt
dir /r
```

The first command hides some text in a stream attached to `report.txt`. A normal `dir` only shows `report.txt`. Adding `/r` reveals the hidden stream.

Windows uses this for good reasons too. When you download a file, Windows adds a stream called `Zone.Identifier`, which is how it knows to warn you that the file came from the internet. But attackers can also hide malware or stolen data in a stream, so it's worth knowing that it exists.

## How Windows boots

On older machines, the **BIOS** starts first. It runs a quick hardware check (POST), reads the Master Boot Record on the disk, and hands over to the Windows Boot Manager, which loads the kernel.

Newer machines use **UEFI** instead. It's faster, supports much bigger disks, and has **Secure Boot**, which only allows boot code that's been signed by a trusted party. That matters because some malware, called bootkits, tries to load before Windows even starts, where antivirus can't see it. Secure Boot is designed to stop that.

## Startup and shutdown

Once the kernel is loaded, Windows starts its services and you log in. Programs can start automatically from a few places: the Startup folder, certain registry keys, and services. Attackers use exactly these places so their malware comes back after every reboot. This is called **persistence**.

The `msconfig` tool shows a lot of this. Its tabs are General (normal or diagnostic startup), Boot (including Safe Mode, which loads only the bare minimum and is useful for removing malware), Services, Startup (which now just points to Task Manager) and Tools.

On shutdown, Windows closes apps first, then background processes, then kernel processes, saving data along the way. Holding the power button skips all that and can corrupt files.

## Processes, threads and services

A **process** is a running program. A **thread** is the part of it that actually runs instructions, and one process can have many threads. A **service** is a program that runs in the background, usually from boot, without anyone logging in. Windows Update is one example.

One thing to remember for SOC work: malware often pretends to be a normal process. A real `svchost.exe` lives in `C:\Windows\System32`. If one is running from a Downloads folder, something is wrong.

Each process gets its own private memory space. To work with things like files or registry keys, it opens **handles**, which are basically references to those objects. A tool called Process Explorer can show you every handle a process has open. It's handy for finding out which program is locking a file.

## The registry

The registry is a big database of settings for Windows, its users and its apps. You can open it with `regedit`. It has five main sections, called hives:

- **HKCU** (HKEY_CURRENT_USER): settings for whoever is logged in right now
- **HKU** (HKEY_USERS): settings for every user profile on the machine
- **HKCR** (HKEY_CLASSES_ROOT): file associations, like which program opens a PDF
- **HKLM** (HKEY_LOCAL_MACHINE): settings for the whole computer
- **HKCC** (HKEY_CURRENT_CONFIG): the current hardware profile

The part that matters most for security is the Run keys:

```
HKCU\Software\Microsoft\Windows\CurrentVersion\Run
HKLM\Software\Microsoft\Windows\CurrentVersion\Run
```

Anything listed there starts automatically when a user logs in. If I'm checking a suspicious machine, this is one of the first places I'd look.

## Managing and monitoring Windows

- **Run as Administrator** and **UAC**: admin tasks need extra rights, and User Account Control asks before a program gets them.
- **Local users and domains**: a local account only exists on one computer. In companies, computers join a domain managed by **Active Directory**, so one account works everywhere and rules can be pushed to every machine from one place.
- **WMI** (Windows Management Instrumentation) lets admins check and change settings on local or remote machines through scripts. Attackers like it for the same reason.
- **The `net` command** handles users, groups, shares and services from the command line. `net user` lists accounts, `net localgroup administrators` shows who has admin rights, `net share` lists shared folders, `net use` connects to one, and `net start`/`net stop` control services. Attackers run these same commands after they break in to learn about the system, so seeing them on a normal user's laptop can be an early warning.
- **Task Manager** and **Resource Monitor** show what's running, how much CPU, memory, disk and network each process uses, and what starts at boot. Resource Monitor is especially useful for finding which process is talking to the network.

## Networking and Windows Server

Windows shares folders over **SMB**, and you reach a share with a path like `\\fileserver\finance`. Windows also creates hidden admin shares like `C$` and `ADMIN$`. Attackers who steal admin credentials use these to move from one machine to another.

**Windows Server** adds the roles a company network runs on: Active Directory, DNS, DHCP, file sharing and the IIS web server.

## Windows security tools

`netstat` shows network connections and listening ports. The version I'll use most is:

```
netstat -abno
```

`-a` shows everything, `-b` shows which program owns each connection, `-n` shows numbers instead of names, and `-o` shows the process ID. If I see something like this:

```
TCP  192.168.1.10:51432  185.220.101.5:4444  ESTABLISHED  6120
```

it means process 6120 has an open connection to an outside IP on port 4444, a port often used by attack tools. The next step would be to look up PID 6120 in Task Manager.

**Event Viewer** holds the Windows logs: Application, Security, Setup and System. The Security log is the important one. I already know some event IDs from my home lab: 4624 is a successful logon, 4625 a failed one, 4720 means a new user account was created, and 4688 means a new process started.

The rest of the built-in tools:

- **Windows Update** keeps things patched. In companies, updates are usually tested first and then pushed out centrally.
- **Local Security Policy** (`secpol.msc`) sets password rules, locks accounts after too many failed attempts, and decides what gets logged.
- **Windows Defender** is the built-in antivirus.
- **Windows Defender Firewall** filters traffic in and out, with separate profiles for domain, private and public networks. The public profile is the strictest, for places like café Wi-Fi.

## Why this matters for a SOC engineer

Most company laptops run Windows, so this is where a lot of alerts will come from. The places attackers use to stay hidden (Run keys, services, startup folders, WMI, ADS) are the places I need to know how to check. And event IDs like 4624, 4625 and 4688 are the building blocks of most Windows detection rules.

## Questions I should be able to answer

- What's the difference between user mode and kernel mode?
- Why is NTFS better than exFAT for a system drive?
- What is an Alternate Data Stream, and why would an attacker use one?
- What does Secure Boot protect against?
- Which registry keys are used for persistence?
- What does `netstat -abno` show?

## Next

Linux: why it matters in a SOC, the shell, the file system, logs and hardening.
