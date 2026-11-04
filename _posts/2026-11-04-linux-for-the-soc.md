---
title: "Endpoint Security, Part 10: Linux for the SOC"
date: 2026-11-04 14:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, linux, bash, linux-logs, file-permissions, hardening, rootkits]
---

The second section today was Linux. I use Linux in my home lab and for some automation work, but mostly for running things, not for thinking about how to protect them. This section filled in a lot of gaps.

## Why Linux matters

Linux is an open-source operating system that Linus Torvalds started in 1991. Open source means anyone can read and change the code. It comes in many versions called distributions, like Ubuntu, Debian, Red Hat and Kali.

For security work it matters for a few reasons. Most servers on the internet and in the cloud run Linux. Almost everything can be done and automated from the command line. You get full control over the system. And there are distributions built specifically for security, like Kali Linux for penetration testing and Security Onion for network monitoring.

## Linux in the SOC

A lot of the tools a SOC uses run on Linux:

- packet capture software like Wireshark and tcpdump
- malware analysis tools like REMnux and Cuckoo Sandbox
- intrusion detection systems like Snort, Suricata and Zeek
- firewalls like iptables and nftables
- log managers like rsyslog and journald
- SIEM platforms like Elastic and Wazuh
- ticketing systems for tracking incidents, like TheHive

So even in a company full of Windows laptops, the analyst's own tools are often on Linux.

## Working in the shell

The shell is the program that reads your commands, and the most common one is bash. These are the basic commands I use all the time: `pwd` shows where I am, `ls -l` lists files with details, `cd` moves between folders, `cat` and `less` show a file, `cp`, `mv`, `rm` and `mkdir` copy, move, delete and create, `grep` searches for text, `man` shows the manual for a command, and `sudo` runs something with root (admin) rights.

## Everything is a text file

One idea the course stressed is how much of Linux is plain text. Configuration files, mostly under `/etc`, are text. Logs are text. That makes Linux easy to read and change with simple tools like nano, vi and grep. But it also means that if an attacker can edit the right text file in `/etc`, they can change how the whole system behaves. That's why those files need tight permissions.

## Servers and clients

On a Linux server, background services are called daemons. Each one listens on a port and answers clients. The SSH daemon listens on port 22, a web server on 80 and 443. To see which services are listening, I use:

```bash
ss -tulpn
```

This shows TCP and UDP ports that are listening, the numbers instead of names, and which process owns each one. Any port I don't recognize is worth a closer look.

## Running a server safely

Each service has its own config file, for example `/etc/ssh/sshd_config` for SSH. Hardening a server means making it harder to attack, and the basic steps are:

- keep the system updated
- remove or turn off services you don't need
- use SSH keys instead of passwords, and don't allow root to log in directly over SSH
- turn on a firewall
- use strong passwords and give users only the access they need
- set strict file permissions

Monitoring the service logs is the other half. Most logs live in `/var/log`. The one I'll look at most is the authentication log: `/var/log/auth.log` on Ubuntu and Debian, or `/var/log/secure` on Red Hat. It records logins, SSH attempts and sudo use. General system messages go to `/var/log/syslog` or `/var/log/messages`, kernel messages to `/var/log/kern.log`, boot and hardware messages to `/var/log/dmesg`, and web requests to the web server's own log, like `/var/log/apache2/access.log`. Newer systems also collect logs with systemd, which you read with `journalctl`.

## The Linux file system

I wrote "mention all" in my notes for this one, so here's the full list.

First, the types of file systems Linux works with:

- **ext2**: an older Linux file system with no journaling, still used on some small flash drives
- **ext3**: ext2 with journaling added, so it recovers better after a crash
- **ext4**: the current default on most distributions, faster and able to handle very large files and disks
- **NFS** (Network File System): lets a computer use files stored on another computer over the network
- **CDFS**: for CDs and DVDs
- **swap**: disk space used as extra memory when RAM runs out
- **HFS+** and **APFS**: Apple's older and current file systems, which Linux can also read
- **MBR** (Master Boot Record): not really a file system, but the first part of a disk that holds the partition table and the code that starts booting

Then the main folders. Everything starts at `/`, the root. Programs live in `/bin` and `/sbin`, and installed software in `/usr`. `/boot` holds the kernel and what's needed to start up. `/dev` has files that represent devices like disks. `/etc` has configuration files. `/home` has each user's personal folder, while the root user's folder is `/root`. `/var` holds data that changes, including the logs in `/var/log`. `/proc` shows live information about running processes. And `/tmp` is for temporary files, which also makes it a favorite place for attackers to drop their tools, since anyone can write there.

### Permissions

Every file has permissions for three groups: the owner, the file's group, and everyone else. Each can be allowed to read (r), write (w) or execute (x). Running `ls -l` shows something like this:

```
-rwxr-x--- 1 ali security 2048 Nov  4 10:00 scan.sh
```

The first `-` means it's a normal file (a `d` would mean a folder). Then `rwx` means the owner, ali, can read, write and run it. `r-x` means the security group can read and run it. `---` means nobody else can do anything.

As a number this is 750, because read is 4, write is 2 and execute is 1. So 4+2+1 = 7 for the owner, 4+1 = 5 for the group, and 0 for others. You'd set it with `chmod 750 scan.sh`.

Linux also has links. A symbolic link is like a Windows shortcut: a small file that points to another file.

## The GUI and installing software

Linux can have a full graphical desktop too. What it looks like depends on the desktop environment, usually GNOME (Ubuntu's default) or KDE. Still, for security work, most things happen in the terminal.

Software is installed with a package manager, which downloads it from trusted repositories. On Ubuntu:

```bash
sudo apt update && sudo apt upgrade
```

The first part refreshes the list of available packages, and the second installs any updates. Red Hat systems use `dnf` instead.

## Processes and forks

Every running program is a process with its own ID, the PID. `ps aux` lists them, `top` shows them live, and `kill` followed by a PID stops one.

A fork is when a process makes a copy of itself. The copy is called the child and gets its own PID. Web servers do this to handle many visitors at once. Malware can do it too, so that killing one copy doesn't stop it.

## Malware and rootkits on Linux

Linux desktops see less malware than Windows, but Linux servers are big targets. The Mirai botnet was built from Linux-based IoT devices, and hacked cloud servers are often used to mine cryptocurrency. The usual way in is something simple: weak SSH passwords, an unpatched service, or an admin panel left open to the internet.

To check for known rootkits, there are two common tools, chkrootkit and rkhunter:

```bash
sudo chkrootkit
```

One thing to keep in mind: a rootkit can lie to the system it's hiding on, so a clean scan isn't a full guarantee. If something seems off, it's better to check from a separate, trusted system.

## Piping commands

The pipe, `|`, sends the output of one command into the next. This is where Linux really shines for log analysis. For example:

```bash
grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | head
```

Reading it left to right: grep finds the failed SSH logins, awk pulls out the IP address from each line, sort and uniq count how many failures each IP has, the second sort puts the biggest numbers on top, and head shows the top ten. In one line, I get a list of who's trying hardest to brute-force the server. It's basically a tiny SIEM.

## Why this matters for a SOC engineer

Most of the tools I'm going to work with run on Linux, and so do most of the servers I'll be protecting. Knowing where the logs are, how permissions work, what a normal process list looks like, and how to chain commands together will save a lot of time during an investigation, especially when there's no fancy dashboard to lean on.

## Questions I should be able to answer

- Name some SOC tools that run on Linux.
- Where are login and SSH logs stored on Ubuntu and on Red Hat?
- What does `chmod 750` mean?
- What's the difference between ext3 and ext4?
- Why is `/tmp` interesting to attackers?
- What is a fork?
- What does a pipe do?

## Next

Defending systems and devices: patching, endpoint protection, host firewalls, HIDS, encryption and Apple's built-in security features.
