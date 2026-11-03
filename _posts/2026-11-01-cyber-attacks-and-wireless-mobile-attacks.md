---
title: "Endpoint Security, Part 3: Cyber Attacks, Wireless and Mobile Attacks"
date: 2026-11-01 14:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, logic-bomb, dns, layer-2, mitm, zero-day, keylogger, wireless, bluetooth, mobile-security]
---

Today I continued the Endpoint Security course. Yesterday was about tricking people. Today was about attacking the technology itself: hidden code, DNS, the local network, unknown software flaws, and then wireless and mobile devices.

## Logic bombs

A **logic bomb** is malicious code hidden inside a normal program. It does nothing until a condition is met, then it "goes off."

It has two parts: a **trigger** (a date, or an event like "my account was deleted") and a **payload** (the damage, like deleting a database). A simple example of what one could look like:

```python
# Hidden inside a normal payroll script
if "ahmed.k" not in active_employee_list():
    delete_all_records("payroll_database")
```

As long as this employee is active, nothing happens. The day his account is removed, the payroll data is deleted.

Logic bombs are dangerous because they sit inside **trusted** code, so antivirus rarely catches them, and they're often planted by insiders who expect to be fired. Defenses: **code reviews**, **separation of duties** (one person can't write, approve and deploy code alone), monitoring changes to scripts, and backups.

## DNS attacks

DNS is the internet's phone book: it turns names like `google.com` into IP addresses. Almost every connection starts with a DNS lookup, so whoever controls DNS controls where users go.

- **Domain reputation:** domains build a reputation over time. Security tools block domains known for spam or malware, so attackers keep registering **fresh** domains. That's why a brand-new domain in an email link is a warning sign.
- **DNS spoofing (cache poisoning):** the attacker gets fake records into a DNS server's cache (its short-term memory of answers). Users who type the correct address are sent to the attacker's IP. *Defense: DNSSEC, which digitally signs DNS records.*
- **Domain hijacking:** the attacker takes over the whole domain, usually by stealing the login at the **registrar** (where the domain was bought). *Defense: MFA and "registrar lock" on domain accounts.*
- **URL redirection:** a link starts with a trusted site but forwards the user somewhere else, like `https://trusted-site.com/redirect?url=https://evil-site.com`. This weakness is called an **open redirect**.

## Layer 2 attacks

Layer 2 is where switches work and devices are identified by **MAC addresses**. Layer 2 protocols trust everyone on the local network, and attackers abuse that:

- **MAC address spoofing:** copying another device's MAC address. On Linux it takes three commands (turn the interface off, set a new address, turn it on again), which shows why MAC filtering alone is weak.
- **ARP spoofing:** sending fake ARP messages saying "I am the router," so traffic goes to the attacker first. (I'll go through it step by step in a later post.)
- **MAC flooding:** sending thousands of fake MAC addresses until the switch's MAC table (the **CAM table**) is full. The switch then sends frames out of all ports, like an old hub, and the attacker can capture other people's traffic.

Switch defenses: **port security** against flooding and spoofing, **Dynamic ARP Inspection** against ARP spoofing, and **DHCP snooping** against rogue DHCP servers.

## Man-in-the-middle and man-in-the-mobile

- **Man-in-the-middle (MitM):** the attacker secretly sits between two parties who think they're talking directly. They can read, change or inject traffic. Common ways in: a fake Wi-Fi hotspot, ARP spoofing or DNS spoofing. *Defense: encryption (HTTPS, VPN), and never clicking through certificate warnings.*
- **Man-in-the-mobile (MitMo):** the same idea through malware on a phone. Since many services send one-time codes by SMS, malware that reads SMS can steal them. The mobile version of the **ZeuS** banking malware did exactly this: it tricked users into installing a fake "security app" that forwarded their bank codes. *Defense: official app stores only, and authenticator apps instead of SMS codes.*

## Zero-day attacks

A **zero-day** is a flaw the vendor doesn't know about yet, or hasn't fixed. The vendor has had "zero days" to fix it when attacks begin.

The life of a vulnerability: flaw exists → attacker finds it → attacks start → vendor learns → patch released → users install it. Systems stay exposed until the patch is actually **installed**, not just released.

Zero-days are dangerous because there's no patch and antivirus has no signature for them. Defense relies on **behavior monitoring** (like a PDF reader suddenly opening a command prompt), **least privilege**, **network segmentation** and patching fast once a fix appears.

## Keyloggers

A **keylogger** records every key pressed: passwords, card numbers, messages.

- **Software keylogger:** a hidden program, usually installed by malware
- **Hardware keylogger:** a small device between the keyboard and computer

Defenses: endpoint protection, checking shared computers for unknown devices, **MFA** (a captured password isn't enough), and password managers (passwords aren't typed).

## Wireless and mobile attacks

Wireless signals don't stop at walls, so an attacker doesn't need to be inside the building, just close enough.

### Grayware and SMiShing

- **Grayware:** apps that aren't clearly malware but behave badly, like a flashlight app asking for your contacts and location, or apps that track you and show aggressive ads. *Check permissions before installing.*
- **SMiShing:** phishing by SMS. *"Your parcel is on hold. Pay the delivery fee here."* People trust texts more than emails, and short links hide the real address.

### Rogue access points

A **rogue AP** is a wireless access point connected without permission. It can be innocent (an employee adds their own router for better signal) or malicious. The malicious version that copies a real network's name is an **evil twin**. Users connect to it, and the attacker sits in the middle of their traffic.

*Defense:* wireless intrusion prevention systems (WIPS), regular wireless scans, port security, and a VPN on public Wi-Fi.

### Radio frequency jamming

Flooding Wi-Fi frequencies with radio noise so devices can't communicate. It's a wireless denial of service. It can also happen accidentally from microwaves or cordless phones on the busy 2.4 GHz band. Unauthorized jamming is illegal in many countries.

### Bluejacking and bluesnarfing

| | Bluejacking | Bluesnarfing |
|---|---|---|
| **What it does** | Sends unwanted messages to nearby Bluetooth devices | **Steals** data (contacts, photos, emails) over Bluetooth |
| **Severity** | Annoying | Serious data theft |

The way I remember it: *jacking* sends junk, *snarfing* snatches data. Defense: turn Bluetooth off when not needed, stay non-discoverable, and keep devices updated.

### Attacks against Wi-Fi protocols

| Standard | Status |
|---|---|
| **WEP** (1999) | Broken, cracked in minutes |
| **WPA** (2003) | Outdated |
| **WPA2** (2004) | OK with a strong password |
| **WPA3** (2018) | Current best |

Common attacks: cracking WEP; capturing the WPA2 **four-way handshake** (the messages exchanged when a device joins) and guessing the password offline; **KRACK** (2017), a WPA2 flaw fixed with updates; guessing the **WPS** PIN; and **deauthentication attacks** that kick devices off with fake disconnect messages.

### Wi-Fi and mobile defense

- WPA3, or WPA2 with AES; never WEP
- A long, unique Wi-Fi password, WPS turned off, router admin password changed and firmware updated
- Guest network for visitors and smart devices
- Apps only from official stores, permissions checked, phones updated, screen lock and remote wipe on
- In companies: WPA2/WPA3-Enterprise with individual logins, and Mobile Device Management (MDM)

## Why this matters for a SOC engineer

- **DNS logs** are gold. Lookups for newly registered or low-reputation domains are strong signals.
- **Zero-days** can't be caught by signatures, so detection depends on behavior.
- **Layer 2 attacks** show up as switch alerts, like one port suddenly learning hundreds of MAC addresses.
- **Rogue APs** can be found with WIPS alerts and by checking for unknown devices on switch ports.
- **Script changes** by an employee who is about to leave deserve a second look.

## Questions I should be able to answer

- What are the two parts of a logic bomb?
- DNS spoofing vs domain hijacking: what's the difference?
- What happens to a switch during MAC flooding?
- Why is a zero-day so hard to defend against?
- What is an evil twin?
- Bluejacking vs bluesnarfing?

## Next

Tonight: application attacks (XSS, SQL injection, buffer overflows and more), email and browser attacks, and newer threats like supply chain attacks and adversarial AI.
