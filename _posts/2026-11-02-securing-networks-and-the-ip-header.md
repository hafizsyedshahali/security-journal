---
title: "Endpoint Security, Part 5: Securing Networks, Threat Actors and the IP Header"
date: 2026-11-02 14:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, network-security, data-loss, risk, threat-actors, ipv4, ipv6, packet-header]
---

Today I moved into the **network security** part of the course. It starts with the big questions (why networks need protecting, how data leaks, who attacks us) and then goes back to the foundation: the **IP packet header**. Many network attacks abuse header fields, so I wanted to understand every one of them before tonight's post on IP and TCP attacks.

## Why networks need securing

My notes list five points:

1. **Networks are targets.** Anything holding valuable data or running an important service is a target, big or small. Many attacks are automated scans that hit anyone with a weakness.
2. **Any connected device could be the source.** A phishing-infected laptop, a printer with a default password, or a smart camera can be the way in. Once inside, attackers move to other devices. This is called **lateral movement**.
3. **The reasons are serious:** protecting data, keeping services running, avoiding financial loss and legal fines (like under the EU's GDPR), and protecting reputation.
4. **Attack vectors** (the paths attackers use) can be **external** (from the internet) or **internal** (from inside, like an infected USB drive or a misbehaving contractor). Internal attacks can do more damage because insiders already have access.
5. **Data loss** (also called **data exfiltration**) is one of the biggest worries.

## How data leaks out

| Data loss vector | How it happens | Key control |
|---|---|---|
| **Email / social networking** | Files sent to the wrong person or a personal email; oversharing online | Email DLP, training |
| **Unencrypted devices** | A lost or stolen laptop or phone is readable by anyone | Full-disk encryption (BitLocker, FileVault) |
| **Cloud storage** | Company files on personal Dropbox or Drive; weak cloud passwords | Approved services only, MFA |
| **Removable media** | Data copied to a USB drive and carried out | Restrict USB ports, encrypted company drives |
| **Hard copy** | Printouts left on desks or thrown away unshredded | Shredding, clean desk policy |
| **Improper access control** | People can reach data they don't need | Least privilege, regular access reviews |

**DLP (Data Loss Prevention)** tools watch for sensitive data leaving through these channels.

## Threat, vulnerability and risk

These three terms come up in every security conversation (and interview):

| Term | Meaning | Example |
|---|---|---|
| **Threat** | A potential danger | A ransomware group |
| **Vulnerability** | A weakness that can be exploited | An unpatched VPN server |
| **Risk** | How likely the threat uses the weakness, and how bad it would be | High, if that server holds all customer data |

A simple way to remember it: **risk = likelihood × impact**. The same bug is low risk on an empty test server and high risk on the payment database.

Two related terms: an **exploit** is the actual tool or method that uses a vulnerability, and the **attack surface** is every point where an attacker could get in. Closing unused ports and removing unused software shrinks it.

Organizations handle a risk in four ways: **avoid** it (stop the risky activity), **reduce** it (patch, add MFA), **share** it (cyber insurance or an outside provider), or **retain** it (accept a small risk).

## Hacker vs threat actor

A **hacker** is someone with strong technical skill. Hackers can be **white hat** (ethical, with permission), **gray hat** (no permission, but may report what they find) or **black hat** (malicious).

A **threat actor** is anyone who causes or tries to cause harm, skilled or not. An insider stealing printouts is a threat actor, but not a hacker. A white hat penetration tester is a hacker, but not a threat actor.

## How threat actors have evolved

| Threat actor | Skill | Motivation |
|---|---|---|
| **Script kiddies** | Low. They use tools made by others | Fun, curiosity, showing off |
| **Vulnerability brokers** | High. Usually gray hats who find flaws | Bug bounty rewards, or selling flaws |
| **Hacktivists** | Medium to high | Political or social causes (leaks, defacements, DDoS) |
| **Cybercriminals** | Medium to high | Money: ransomware, fraud, selling data. Many run like businesses, even "Ransomware-as-a-Service" |
| **State-sponsored** | Very high | National interests: spying, stealing secrets, attacking infrastructure. Behind most APTs |

Script kiddies are still dangerous, because the tools they borrow are powerful.

## Threat indicators and sharing

**Indicators of Compromise (IOCs)** are the traces an attack leaves: malware hashes, bad IPs and domains, strange registry changes. A related idea is **Indicators of Attack (IOAs)**, which focus on *behavior* (like "a program is encrypting hundreds of files quickly") instead of specific artifacts. IOAs are harder for attackers to change than a hash or an IP.

No one sees every threat alone, so organizations **share** indicators. **CISA** runs Automated Indicator Sharing, industry groups called **ISACs** share within sectors like banking, and campaigns like **Cybersecurity Awareness Month** (every October) build public awareness.

## Attacking the foundation: the IPv4 header

Every IP packet has a **header** (control information) and **data** (the content). Think of an envelope: the header is the writing on the outside, the data is the letter inside. IP was designed for a small, trusted network decades ago, so **nothing in the header is verified**. That one fact explains many attacks.

The IPv4 header is usually **20 bytes**:

```
+-------+-------+---------------+-------------------------------+
|Version|  IHL  |      DS       |         Total Length          |
+-------+-------+---------------+-----+-------------------------+
|         Identification        |Flags|     Fragment Offset     |
+---------------+---------------+-----+-------------------------+
|      TTL      |   Protocol    |        Header Checksum        |
+---------------+---------------+-------------------------------+
|                    Source IPv4 Address                        |
+---------------------------------------------------------------+
|                  Destination IPv4 Address                     |
+---------------------------------------------------------------+
|                    Options and Padding                        |
+---------------------------------------------------------------+
```

Field by field:

- **Version (4 bits):** always 4 (binary `0100`) for IPv4. The receiver reads this first to know how to read the rest.
- **Internet Header Length – IHL (4 bits):** the length of the header in 4-byte units. The minimum is 5, which means 5 × 4 = 20 bytes; the maximum is 15 (60 bytes).
- **Differentiated Services – DS (8 bits):** the packet's **priority** for QoS (Quality of Service), so things like voice calls go first when the network is busy. It used to be called Type of Service.
- **Total Length (16 bits):** the size of the whole packet, header plus data, up to 65,535 bytes.
- **Identification, Flags and Fragment Offset (16 + 3 + 13 bits):** used when a packet is too big for a link (bigger than its **MTU**, usually 1,500 bytes on Ethernet) and must be split into **fragments**. Identification marks which pieces belong together. Flags include **DF** (Don't Fragment) and **MF** (More Fragments follow). Fragment Offset says where each piece fits.
- **Time to Live – TTL (8 bits):** a counter that stops packets looping forever. Each router subtracts 1. At 0, the packet is dropped and an ICMP "Time Exceeded" message goes back to the sender. Common starting values are 64 (Linux/macOS) and 128 (Windows).
- **Protocol (8 bits):** what's inside: **1 = ICMP, 6 = TCP, 17 = UDP**.
- **Header Checksum (16 bits):** checks the header for transmission errors. Routers recalculate it at every hop because the TTL changes. It provides **no security**.
- **Source IPv4 Address (32 bits):** the sender. **Not verified**, so attackers can fake it. This is called **IP spoofing**.
- **Destination IPv4 Address (32 bits):** the receiver.
- **Options and Padding:** rarely used extras (like source routing, which most firewalls block) and padding to finish on a 4-byte boundary.

### How attackers use these fields

- **Source address → spoofing**, the basis of many DoS and amplification attacks
- **TTL → mapping networks.** `traceroute` sends packets with TTL 1, 2, 3 and so on. Each router that drops one replies, revealing the path. Attackers use the same trick.
- **Fragmentation → evasion.** An attack can be split across fragments to slip past security devices, or overlapping fragments can crash systems.

## The IPv6 header

IPv6 simplified the header to a **fixed 40 bytes** with eight fields:

- **Version:** always 6
- **Traffic Class:** priority, the same job as DS in IPv4
- **Flow Label (20 bits):** marks packets of the same flow (like one video call) so routers treat them the same way. IPv4 has nothing like it.
- **Payload Length:** size of the data only (the header is always 40 bytes)
- **Next Header:** what comes next (TCP, UDP or an extension header). Same job as Protocol.
- **Hop Limit:** same job as TTL, with a more accurate name
- **Source and Destination Addresses:** 128 bits each

| | IPv4 | IPv6 |
|---|---|---|
| Header size | 20–60 bytes | Fixed 40 bytes |
| Addresses | 32 bits | 128 bits |
| Hop counter | TTL | Hop Limit |
| Checksum | Yes | No (faster routing) |
| Routers fragment? | Yes | No, only the sender can |

One misconception I want to remember: **IPv6 isn't automatically more secure.** It can still be spoofed and scanned, and since it's often enabled by default, unmonitored IPv6 traffic can be a blind spot.

## Why this matters for a SOC engineer

- **Threat, vulnerability and risk** are in nearly every incident report and interview.
- **The type of threat actor** affects how serious an alert is: a noisy script kiddie scan versus a quiet state-sponsored intrusion.
- **Data loss vectors** map straight to DLP alerts: big uploads to personal cloud storage, files copied to USB.
- **Packet headers** are exactly what Wireshark shows. A private source IP arriving from the internet, an odd TTL or strange fragmentation are all things to notice.

## Questions I should be able to answer

- Explain threat, vulnerability and risk with one example.
- Name the six data loss vectors.
- Hacker vs threat actor?
- What does TTL do, and how does traceroute use it?
- Why is IP spoofing possible?
- Three differences between IPv4 and IPv6 headers?

## Next

Tonight: how attackers abuse IP, ICMP, TCP and UDP, including spoofing, SYN floods and amplification attacks.
