---
title: "Endpoint Security, Part 11: Defending Systems and Devices"
date: 2026-11-04 18:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, endpoint-protection, patch-management, hids, host-firewall, iptables, macos-security, application-security]
---

After Windows and Linux, the course moved on to actually protecting them. This section pulled together a lot of things I've seen in earlier posts (antivirus, firewalls, IPS) but this time from the point of view of a single device.

## Securing the operating system

Securing an operating system starts with a clean, known setup: install only what's needed, remove what isn't, patch everything, use strong accounts, and turn on encryption and logging. The course gave four points to remember:

1. **Watch out for rogue antivirus products.** These are fake security programs that pop up saying "Your PC is infected!" and push you to install or pay for a "fix." The fix is the malware.
2. **Fileless attacks are hard to detect and remove.** Instead of dropping a file on disk, they run in memory and use tools that are already on the system, like PowerShell or WMI. With no file to scan, normal antivirus often misses them. This is sometimes called "living off the land."
3. **Scripts can be malware too.** A PowerShell script, a batch file or an Office macro can do just as much damage as an .exe.
4. **Always remove unapproved software.** Every extra program is something else that can be exploited, and nobody is patching it.

## Patch management

Most attacks use vulnerabilities that already have a fix. The problem is that the fix was never installed. Patch management is the process that makes sure it is: find out which patches are needed, test them so they don't break anything, roll them out, and then check they were actually installed everywhere. In companies this is done centrally with tools like WSUS or Intune for Windows, instead of trusting every user to click "update."

## Endpoint security tools

The course listed the main tools that protect a single device:

- a **host-based firewall**, which controls traffic in and out of that one machine
- **HIDS** (host-based intrusion detection), which watches the device and alerts on suspicious activity
- **HIPS** (host-based intrusion prevention), which can also block it
- **EDR** (endpoint detection and response), which records what happens on the device so an analyst can investigate and respond, for example by isolating the machine from the network
- **DLP** (data loss prevention), which stops sensitive data from leaving the device. I wrote "DLS" in my notes, but the correct term is DLP.
- an **NGFW** (next-generation firewall), which protects the network the device sits on

## Encryption and boot integrity

**Host encryption** protects data if a device is lost or stolen. Windows has BitLocker for whole drives (and BitLocker To Go for USB drives), macOS has FileVault, and Linux has LUKS. Without the key, the disk is just noise.

**Boot integrity** makes sure nothing was tampered with before the operating system starts. UEFI Secure Boot only allows signed boot code. Measured Boot goes further: it records each step of the startup in a hardware chip called the **TPM** (Trusted Platform Module), so the system can later prove it started cleanly.

## Apple's security features

The course also covered what Apple builds into its devices:

- **Security-focused hardware**: Apple chips include a separate, isolated processor called the Secure Enclave that handles encryption keys
- **Encrypted storage**: data is encrypted by default, and FileVault encrypts the whole Mac disk
- **Secure Boot**: only trusted, signed software can start the device
- **Secure biometric data**: Touch ID and Face ID data stays inside the Secure Enclave and never leaves the device
- **Find My Mac**: locate a lost Mac, lock it, or wipe it remotely
- **XProtect**: built-in antivirus that checks apps against known malware signatures
- **Malware Removal Tool**: Apple's built-in tool that removes known malware it finds (newer macOS versions handle this through XProtect)
- **Gatekeeper**: by default only allows apps from the App Store or from identified developers whose apps Apple has checked

As a Mac user, I hadn't realized how many of these were running in the background.

## Physical protection and password recovery

Security isn't only software. Laptops can be locked to desks with cable locks, server rooms should be locked and logged, and devices should be asset-tagged so they can be tracked. A screen lock that kicks in after a few minutes matters too, since an unlocked, unattended laptop needs no hacking at all.

When someone forgets a password, there has to be a safe way to recover. Usually an admin resets it after checking who the person is. With encrypted disks, the recovery key becomes critical. If the BitLocker recovery key is lost along with the password, the data is gone for good. That's why companies store recovery keys centrally.

## Anti-malware protection

Endpoints are where most attacks start, and email is still the most common delivery method. The course showed how a large share of all email traffic is spam, and part of that spam carries malicious links or attachments. So protecting endpoints happens in two layers.

**On the host:**
- antivirus/antimalware software, which detects malware by known signatures, suspicious characteristics (heuristics) or suspicious behavior
- a host-based firewall
- host-based security suites, which bundle antivirus, firewall, anti-phishing and other protections into one product

**On the network:**
- **AMP** (Advanced Malware Protection), which detects malware and keeps tracking files so you can see where a bad one spread
- **ESA** (Email Security Appliance), which filters spam, phishing and malicious attachments before they reach inboxes
- **WSA** (Web Security Appliance), which blocks malicious websites
- **NAC** (Network Admission Control), which checks that a device meets the security rules (antivirus running, patches installed) before letting it onto the network

## Host-based firewalls

Every operating system has its own firewall:

- **Windows Defender Firewall** on Windows
- **iptables** on Linux, which filters traffic using chains of rules, mainly INPUT (traffic coming in), OUTPUT (going out) and FORWARD (passing through)
- **nftables**, the newer replacement for iptables, with a simpler, more consistent syntax
- **TCP Wrappers**, an older Linux method that allows or denies access to certain services using the files `/etc/hosts.allow` and `/etc/hosts.deny`. Many newer distributions no longer use it.

A simple iptables example that only allows SSH from my lab network:

```bash
sudo iptables -A INPUT -p tcp --dport 22 -s 192.168.56.0/24 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j DROP
```

The first rule accepts SSH (TCP port 22) from the 192.168.56.x network. The second drops SSH from everywhere else. Order matters here, just like with ACLs: the first matching rule wins.

## How HIDS works

A HIDS runs on the device itself and watches things a network sensor can't see: changes to important files, the registry, running processes and local logs. It can spot problems in two main ways. **Anomaly-based** detection learns what normal looks like on that machine and alerts when something is different. **Policy-based** detection alerts when a written rule is broken, for example "no program may change files in the system folder."

Some well-known HIDS products are OSSEC, Wazuh (which grew out of OSSEC), Tripwire and AIDE. Cisco's AMP covers some of this too.

## Application security

The last part of this section was about protecting applications by reducing the **attack surface**: all the ways an attacker could get in. The course splits it into three:

- the **network attack surface**: open ports, exposed services and network protocols
- the **software attack surface**: the applications themselves, their code and web interfaces
- the **human attack surface**: people, who can be tricked or make mistakes

Two ways to shrink it:

**Application blocklists and allowlists.** A blocklist names programs that aren't allowed to run. An allowlist does the opposite: only named programs are allowed, and everything else is blocked. Allowlisting is much stronger, because new malware isn't on anyone's blocklist yet. It's just harder to manage.

**System-based sandboxing.** A sandbox runs a program in an isolated space, so even if it's malicious it can't reach the rest of the system. Browsers sandbox each tab, macOS sandboxes App Store apps, and Windows has Windows Sandbox for testing suspicious files. Malware analysis tools like Cuckoo use the same idea to safely watch what a file does.

## Why this matters for a SOC engineer

EDR and HIDS alerts are a big part of what lands in a SOC queue, so I need to understand what they're watching and why they fire. Fileless attacks are a good reminder that "no file found" doesn't mean "nothing happened." And tools like Wazuh and iptables are things I can actually set up and practice with at home.

## Questions I should be able to answer

- What is a fileless attack, and why is it hard to detect?
- What are the steps of patch management?
- What do HIDS, HIPS, EDR and DLP each do?
- What does the TPM do in Measured Boot?
- What is Gatekeeper?
- What does NAC check before letting a device on the network?
- Anomaly-based vs policy-based HIDS detection?
- Why is an allowlist stronger than a blocklist?

## Next

The last post of the course: the core principles of cybersecurity, including the CIA triad, the cybersecurity cube, the states of data, countermeasures and policies.
