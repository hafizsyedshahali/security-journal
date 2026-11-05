---
title: "Network Defense, Part 1: Assets, Defense in Depth, Hardening and Resilience"
date: 2026-11-05 14:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, network-defense, asset-management, defense-in-depth, hardening, high-availability, iot]
---

Today I started Cisco's **Network Defense** course, the next one in the Junior Cybersecurity Analyst path. Endpoint Security was mostly about attacks. This course is about the defender's side: knowing what you have, protecting it in layers, hardening the network, and making sure things keep running when something breaks.

I covered a lot this morning, so this post is on the longer side.

## Assets, vulnerabilities and threats

Everything in network defense starts with three questions. What are we protecting (the **assets**)? Where are we weak (the **vulnerabilities**)? And what could hurt us (the **threats**)? You can't answer the second and third questions properly until you've answered the first. A company can't protect a server it doesn't know exists.

## Identifying assets

The first job is building a full list of everything on the network: computers, servers, network devices, software, data and services. In real companies this is harder than it sounds, because of laptops, phones, cloud services and devices people plug in without asking. Tools that scan the network and keep an up-to-date inventory help a lot.

## Asset classification

Once you know what you have, you sort it by how important and sensitive it is, so the most valuable things get the most protection. The course gave four steps.

**Step 1: Decide the right category for each asset.** The four categories are:

- information assets, like databases, files, contracts and customer records
- software assets, like applications, operating systems and development tools
- physical assets, like servers, laptops, network equipment and buildings
- services, like power, internet connectivity and cloud services the business depends on

**Step 2: Find the owner.** Every piece of information and every application needs a named owner, someone responsible for it. That person decides who can access it and how well it needs to be protected. Without an owner, nobody feels responsible, and that's how things get missed.

**Step 3: Decide the criteria for classification.** The course listed five things to consider:

- confidentiality: how much damage would it cause if it leaked?
- value: how much is it worth to the business?
- time: some information becomes less sensitive over time, like quarterly results once they're published
- access rights: who needs to use it?
- destruction: how and when should it be destroyed when it's no longer needed?

**Step 4: Put a classification scheme in place.** This means using one consistent way of labeling information across the whole company, for example Public, Internal, Confidential and Restricted. When everyone uses the same labels, protection is applied the same way everywhere and monitoring becomes much easier.

## Asset standardization

Standardization means deciding which types of assets are allowed: specific models of laptops, approved operating systems, approved software. Fewer variations make it easier to patch, support and monitor everything. If every laptop runs the same build, one patch fixes all of them.

## The asset lifecycle

Every asset goes through five stages, and security matters at each one:

1. **Procurement:** buying it. Even here, you choose trusted suppliers and products that can be secured.
2. **Deployment:** setting it up with a secure configuration before it goes live.
3. **Utilization:** using it day to day, with monitoring and access control.
4. **Maintenance:** patching, updating and repairing it.
5. **Disposal:** retiring it safely. Hard drives need to be wiped or destroyed so old data doesn't leak.

Disposal is the one people forget. An old server sold without wiping its disks is a data breach waiting to happen.

## Identifying vulnerabilities and threats

After the assets, you look for weaknesses: unpatched software, weak configurations, default passwords, open ports and missing encryption. Vulnerability scanners like Nessus and OpenVAS help here, along with regular reviews and penetration tests.

Then you think about threats: who would attack this, and how? Threat intelligence from earlier courses (IOCs, shared indicators and the types of threat actors) feeds into this step.

## The security onion and the security artichoke

These two images describe how defense has changed.

The **security onion** is the older idea. The valuable data sits in the middle, protected by layers like an onion: the firewall, then the IPS, then the server's own protections, and so on. An attacker has to peel through every layer to reach the center.

The **security artichoke** describes today's reality. With cloud services, mobile devices and remote work, there isn't one clear outer layer anymore. Attackers don't need to peel through everything. Like pulling leaves off an artichoke, they can go after one exposed piece, like a phone, a cloud account or a home laptop, and work their way toward the data from there. Each "leaf" they pull off gets them closer.

The lesson for me: you can't just protect the edge of the network. Every piece needs its own protection.

## Defense in depth strategies

Defense in depth means using several layers of security, so if one fails, the others still protect the asset. The course listed five strategies:

- **Layering:** several different controls stacked together, so a single failure isn't enough. For example, a firewall, plus an IPS, plus antivirus on the server.
- **Limiting:** restricting access to only those who need it. This is least privilege, applied to people, devices and network traffic.
- **Diversity:** using different types of controls, or products from different vendors, so one trick doesn't get past all of them. If both your firewalls are from the same vendor, one vulnerability could break both.
- **Obscurity:** not giving away information that helps attackers. For example, error messages shouldn't show software versions, and devices shouldn't announce what they are.
- **Simplicity:** keeping the design as simple as possible. Complicated systems lead to mistakes and misconfigurations, and those become vulnerabilities.

Obscurity should never be the main defense, though. Hiding something isn't the same as securing it, as I learned with SSID cloaking.

## Cybersecurity operations management

### Configuration management

Configuration management means knowing and controlling exactly how every system is set up. It includes:

- a **baseline configuration**, the approved, secure starting setup for each type of device
- **change control**, so changes are requested, approved, tested and recorded instead of made casually
- up-to-date **documentation**, like network diagrams, IP addressing plans and standard naming for devices

If something breaks or gets hacked, you can compare the device against its baseline and see exactly what changed.

### Log files

Logs are the record of what happened on a system. The course described their full lifecycle:

**Generating → Transmitting → Storing → Analyzing → Disposing**

First, systems **generate** log entries. Then the logs are **transmitted** to a central place, ideally over a secure channel. They're **stored** safely, protected from being changed or deleted, for as long as policy or law requires. They're **analyzed**, by people or by a SIEM, to find problems and attacks. Finally, when they're no longer needed, they're **disposed of** securely.

### Operating system and application logs

There are two main sources. **Operating system logs** include Windows Event Logs and Linux syslog. They record logins, system errors, service changes and similar events. **Application security logs** come from things like web servers, databases, firewalls and antivirus. They record who accessed what, blocked attacks and errors inside the application. Together, they give a full picture of what happened.

### Protocol analyzers

A **protocol analyzer**, like Wireshark, captures network traffic and decodes it so you can read every packet. The course listed what they're used for:

- traffic logging
- troubleshooting network problems
- detecting misuse of the network by internal or external users
- detecting network intrusion attempts
- isolating systems that have been exploited

## Security policies, regulations and standards

### Business policies

Business policies set the rules for the whole organization. There are three types:

- **Company policies** set the rules of conduct and the responsibilities of both employees and the employer.
- **Employee policies** cover things like working hours, pay, leave, training and performance reviews. They're often explained during onboarding.
- **Security policies** set the security rules: how systems and data must be protected, and what's expected of everyone.

### BYOD policies

**BYOD (Bring Your Own Device)** means employees use their own phones and laptops for work. It's convenient, but the company doesn't fully control those devices. A BYOD policy should say who can use their own devices, which devices are allowed, what they can access, what security is required (screen lock, encryption, updates), and whether the company can remotely wipe work data if the device is lost.

### Regulatory and standard compliance

Many organizations must follow laws and industry standards. Common ones are **GDPR** (personal data in the EU), **HIPAA** (health data in the US), **PCI DSS** (anyone handling payment cards), **SOX** (financial reporting for US public companies) and **ISO 27001** (an international standard for managing information security). Breaking them can mean heavy fines, so security policies are often built around them.

## Physical security

Network defense also means protecting the actual buildings and equipment. The course covered:

- **Fencing and physical barriers:** fences, gates, walls and bollards (short, strong posts that stop vehicles). Taller fences, especially with barbed wire on top, stop more determined intruders.
- **Biometrics:** fingerprint, face, iris or palm scanners for entering secure areas.
- **Badges and access logs:** each person badges in, and the system records who entered where and when. These logs are useful in investigations.
- **Surveillance:** security guards, CCTV cameras, motion sensors and alarms.

## Application security

### Secure development

Security has to be part of building an application from the start, not something added at the end. That means thinking about threats during design, writing secure code, testing it properly, and keeping it patched after release.

### Secure coding techniques

These include validating all input, handling errors without revealing internal details, using parameterized queries for databases, not hard-coding passwords in the code, reusing trusted, well-tested code libraries, and using **obfuscation** (making code harder to read) where it makes sense.

### Input validation and validation rules

**Input validation** means checking that data is what the application expects before using it. It stops many attacks, like SQL injection. The course listed common validation rules:

- **size:** is the input the right length?
- **format:** does it match the expected pattern, like a date or an email address?
- **consistency:** do related fields make sense together? A birth date can't be after the account creation date, for example.
- **range:** is the value within allowed limits, like an age between 0 and 120?
- **check digit:** an extra digit calculated from the other digits, used to catch typing mistakes in things like card or account numbers

### Integrity checks

My notes list five methods for checking that data and applications haven't been changed:

- **Checksums:** a simple value calculated from the data. If the data changes, the checksum changes. Good for catching accidental errors.
- **Hash functions:** like SHA-256, which give a unique fingerprint and are much harder to fake than a simple checksum.
- **Version control:** tools like Git track every change, who made it and when, so unauthorized changes stand out and can be undone.
- **Backups:** if data is damaged or changed, a known-good copy can be restored.
- **Authorization:** only people with the right permissions can change data in the first place.

### Other practices and managing application threats

Other good practices include code signing (so users can verify who published the software), testing before release (including fuzzing, which throws random data at an app to see if it breaks), running apps with the least privilege they need, and using a web application firewall.

Managing threats to applications means keeping an inventory of all applications, patching them, removing ones that aren't used, monitoring their logs, and limiting who can access them.

## Network hardening: services and protocols

**Hardening** means removing anything that isn't needed and securing what's left. The course went through common network services.

**Network and routing services:**

- **DHCP:** a rogue DHCP server can hand out fake settings. Use DHCP snooping on switches so only the real server is trusted.
- **DNS:** can be poisoned or used for tunneling. Use DNSSEC, don't run open resolvers, and monitor DNS logs.
- **ICMP:** useful for troubleshooting, but abused for scanning and floods. Filter it at the network edge and block risky types like redirects.
- **RIP** (Routing Information Protocol): an older routing protocol that shares routes between routers. Without authentication, an attacker could send fake routes. Use RIPv2 with authentication, or a more modern protocol.
- **NTP:** keeps clocks in sync. Use NTP authentication so attackers can't feed devices the wrong time, and don't expose NTP servers to the internet.

**Telnet, SSH and SCP:**

**Telnet** gives remote command-line access but sends everything, including passwords, in plain text. Anyone capturing the traffic can read it. **SSH** does the same job with encryption, so it should always replace Telnet. **SCP** (Secure Copy) copies files over SSH, so file transfers are encrypted too, unlike plain FTP.

**Secure protocols:**

The general rule is to replace insecure protocols with their secure versions:

| Insecure | Secure replacement |
|---|---|
| Telnet | SSH |
| FTP | SFTP or SCP |
| HTTP | HTTPS |
| SNMPv1/v2c | SNMPv3 |
| LDAP | LDAPS |
| POP3/IMAP without encryption | POP3/IMAP over TLS |

## Network hardening: segmentation

**Segmentation** means splitting the network into separate parts, so a problem in one part can't easily spread to the rest.

- **VLANs** (Virtual Local Area Networks) divide one physical switch network into separate logical networks. For example, HR, finance, guests and IoT devices can each have their own VLAN, and traffic between them has to go through a router or firewall where it can be controlled.
- A **DMZ** is a separate zone for servers the public needs to reach, like web servers, keeping them away from the internal network. I covered this in more detail in my Endpoint Security posts.

## Hardening wireless and mobile devices

For wireless security, the main steps are using WPA3 (or WPA2 with AES), using WPA3-Enterprise with 802.1X in companies, and scanning regularly for rogue access points.

**Hardening a wireless router:** change the default admin password, update the firmware, turn off WPS, turn off remote management, use a strong Wi-Fi password, and set up a separate guest network.

### Authentication

**Authentication protocols** are the methods devices use to prove who they are. Older ones like PAP send passwords in plain text, which is unsafe. CHAP is better because it never sends the actual password. **EAP**, used with 802.1X, supports stronger methods like certificates.

- **Mutual authentication** means both sides prove their identity to each other: the user to the network, and the network to the user. This stops evil twin attacks, because a fake access point can't prove it's the real network.
- **Authentication methods** fall into three types: something you know (a password or PIN), something you have (a phone or security key) and something you are (a fingerprint or face). Using two or more of these together is **multi-factor authentication**.

### Mobile devices

- **Mobile Device Management (MDM)** lets the IT team manage company phones and tablets from one place: enforcing screen locks and encryption, pushing updates, controlling which apps can be installed, and wiping a lost device remotely.
- **Mobile device protection** on the device itself means a strong screen lock, encryption, regular updates, installing apps only from official stores, and not jailbreaking or rooting the phone, which removes its built-in protections.
- **GPS tracking** helps find lost or stolen devices. It's also used for geofencing, where a device's features change based on its location. But tracking also raises privacy questions, so it should be covered by policy.

## Cybersecurity resilience

Resilience is about keeping systems running even when something fails. This was the longest part of today's notes.

**High availability** means a system is designed to stay up almost all the time. The well-known target is **five nines**, or 99.999% uptime, which allows only about 5 minutes of downtime in a whole year.

A **single point of failure** is any one component that, if it fails, brings the whole system down: one power supply, one switch, one internet link. Finding and removing these is the first step toward high availability.

**N+1 redundancy** means having one more component than you need. If a data center needs three cooling units (N), you install four (N+1), so one can fail without causing a problem.

**RAID** (Redundant Array of Independent Disks) combines several disks for speed, protection or both. It works using three techniques: **striping** spreads data across disks for speed, **mirroring** keeps an exact copy on another disk, and **parity** stores extra information that can rebuild a failed disk. RAID 0 is striping only (fast but no protection), RAID 1 is mirroring, RAID 5 uses striping with parity, and RAID 10 combines mirroring and striping. One thing to remember: RAID protects against a disk failing, but it isn't a backup. If a file is deleted or encrypted by ransomware, RAID copies that change too.

**Spanning Tree Protocol (STP)** is used when switches have redundant links between them for backup. Without STP, those extra links would create loops, and traffic would circle forever until the network collapses. STP blocks the extra links and only turns them on if the main link fails.

**Router redundancy** protects the default gateway. If the one router everyone uses fails, nobody can leave the network. **First Hop Redundancy Protocols**, like HSRP and VRRP, let two or more routers share one virtual gateway address, so a backup router takes over automatically.

**Location redundancy** means keeping copies of data and systems in different physical locations, so a fire or flood at one site doesn't take everything down. Data is copied between sites using **replication**, which comes in three types:

- **Synchronous replication:** data is written to both locations at the same moment. No data is lost if one site fails, but it needs a fast connection and works best over shorter distances.
- **Asynchronous replication:** data is written to the main site first and copied to the second site shortly after. It works over long distances, but the most recent changes might be lost if the main site fails.
- **Point-in-time replication:** copies are taken at set intervals, like snapshots. It's cheaper, but you can lose everything since the last snapshot.

**Resilient design** brings all of this together, along with **system and data backups**. Backups should be tested regularly, and at least one copy should be kept offline or off-site, so ransomware can't reach it.

**Designing high-availability systems** means removing single points of failure at every level: power, network, servers, storage and location.

**Power** is protected with **UPS** units (batteries that keep things running during short outages), **generators** for longer outages, and servers with dual power supplies connected to separate power sources.

**HVAC** (Heating, Ventilation and Air Conditioning) keeps equipment at the right temperature and humidity. Servers that overheat shut down or fail early, so cooling needs redundancy too.

Finally, **managing threats** to availability means monitoring all of this (power, temperature, hardware health, network links) and having a plan for what to do when something fails.

## Embedded and specialized systems

**Threats to key industry sectors:** critical sectors like energy, water, healthcare, manufacturing and transportation rely on industrial control systems such as **SCADA**. These systems were often built to be reliable, not secure, and attacks on them can affect real-world safety. The Stuxnet attack I wrote about earlier is an example.

**Embedded systems** are small computers built into devices to do one specific job, like the controller inside a printer, a car or a medical device. They're often hard to patch and may run old software for years.

**IoT** (Internet of Things) devices include smart cameras, thermostats, smart plugs and sensors. They often ship with default passwords, rarely get updates, and sit on the same network as everything else. The Mirai botnet was built from exactly these kinds of devices. They should be on their own network segment.

**VoIP equipment** (phones and systems that make calls over the network) can be attacked through eavesdropping on calls, toll fraud (attackers making expensive calls on your account), vishing and denial of service. Putting VoIP on its own VLAN and encrypting calls helps.

**Special-purpose embedded systems** include medical devices like insulin pumps and pacemakers, vehicles, drones, smart meters and aircraft systems. A security failure in these can put lives at risk.

**Deception technologies** are traps that fool attackers:

- a **honeypot** is a fake system that looks valuable but exists only to attract attackers and record what they do
- a **honeynet** is a whole fake network of honeypots
- **honeyfiles** and **honeytokens** are fake files or credentials that trigger an alert the moment anyone touches them
- a **DNS sinkhole** redirects requests for known-malicious domains to a safe address, cutting malware off from its command server

Since no real user should ever touch these, any activity on them is a strong sign of an attacker.

**Physical security with IoT devices:** many physical security tools are now IoT devices themselves, like smart cameras, smart locks and connected sensors. They make monitoring easier, but they need the same care as any other IoT device: changed default passwords, updates and their own network segment. Otherwise the camera meant to protect the building becomes the way in.

## Why this matters for a SOC engineer

A lot of this is the groundwork a SOC depends on. Asset inventories and classification tell analysts how important an alert is: a strange login on the payment database matters more than one on a test machine. The log lifecycle is basically what a SOC engineer builds and maintains. Configuration baselines make it possible to spot what an attacker changed. And deception technologies like honeytokens are a cheap, effective way to catch attackers early, before they reach anything valuable.

## Questions I should be able to answer

- What are the four steps of asset classification?
- What are the five stages of the asset lifecycle?
- What's the difference between the security onion and the security artichoke?
- What are the five defense in depth strategies?
- What are the stages of the log file lifecycle?
- Why should Telnet be replaced by SSH?
- What does mutual authentication protect against?
- What does N+1 redundancy mean? What's a single point of failure?
- Synchronous vs asynchronous replication?
- What is a honeypot, and why is any activity on it suspicious?

## Next

Tonight I'll write about whatever I cover in the rest of today's study.
