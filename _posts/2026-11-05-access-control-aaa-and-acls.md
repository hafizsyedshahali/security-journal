---
title: "Network Defense, Part 2: Access Control, AAA and ACLs"
date: 2026-11-05 21:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, access-control, aaa, zero-trust, mfa, rbac, acl, wildcard-mask, cisco-ios]
---

The second half of today was about access control: deciding who can get into what, keeping a record of what they did, and then enforcing it on the network with access control lists (ACLs). I touched on AAA and ACLs in my Endpoint Security posts, but this section went much deeper, and the ACL part was properly hands-on.

## Three kinds of access control

Access control comes in three forms, and a good setup uses all of them.

**Physical access control** stops people from physically reaching things: locks, fences, badge readers, guards, mantraps and cameras.

**Logical access control** (also called technical) uses technology to control access: passwords, encryption, firewalls, ACLs, biometrics and smart cards.

**Administrative access control** is the policies and procedures behind everything: who gets access and why, background checks, security training, and rules about how access is requested and removed.

## AAA: authentication, authorization, accounting

Access control is built around AAA. **Authentication** asks "who are you?" **Authorization** asks "what are you allowed to do?" **Accounting** asks "what did you actually do?" The easy way I remember it is a bank card: the PIN proves it's you, your daily limit controls how much you can take out, and your statement records every withdrawal.

## Identification

Before authentication comes **identification**: claiming an identity, usually with a username or an ID number. Identification is just the claim. Authentication is proving it. Typing "hafiz" is identification; typing the right password is authentication.

## Federated identity management

**Federated identity** means one identity works across different organizations or services that trust each other. "Sign in with Google" or "Sign in with Microsoft" on another website is the everyday example. Inside companies, it lets employees log in once and use many applications (**single sign-on**). It's built on standards like **SAML**, **OAuth** and **OpenID Connect**.

The upside is fewer passwords and central control. The risk is that if that one identity is stolen, the attacker gets into everything it's connected to. That's why federated accounts need strong protection, especially MFA.

## Authentication methods and MFA

There are three main ways to prove who you are:

- **something you know:** a password, PIN or security question
- **something you have:** a phone app, a hardware key, or a smart card
- **something you are:** a fingerprint, face or iris (biometrics)

Some systems also check **somewhere you are** (location) or **something you do** (like typing pattern).

**Multi-factor authentication (MFA)** uses two or more *different* types. A password plus an app code is MFA. A password plus a security question is not, because both are "something you know." MFA stops most attacks that rely on stolen passwords, which is why it's one of the most recommended controls everywhere.

## Authorization and accountability

Once a user is authenticated, **authorization** decides what they can do: which files they can open, which systems they can log into, and sometimes when. A payroll clerk might only be allowed to access the payroll system during office hours.

**Accountability** means every action can be traced back to a specific person. That only works if everyone has their own account (no shared logins) and actions are logged. If five people share one admin account, there's no way to tell who deleted the database.

## Zero trust

The old idea was "trust everything inside the network." **Zero trust** says **never trust, always verify**. Every user, device and request has to prove itself, every time, whether it comes from inside or outside the network. Access is given only for what's needed, and is checked continuously.

This fits today's world of cloud services, remote work and personal devices, where there's no clear "inside" anymore. It's the same lesson as the security artichoke from this morning's post.

## Access control models

These are different ways of deciding who gets access:

- **Discretionary Access Control (DAC):** the owner of a file decides who can use it. Normal Windows and Linux file sharing works this way. It's flexible, but users can make poor choices.
- **Mandatory Access Control (MAC):** the system decides, based on labels. Data gets a classification (like Secret) and users get a clearance. You can only read data at or below your clearance. Used in military and government.
- **Role-Based Access Control (RBAC):** access is tied to job roles. Everyone in the "Finance" role gets the same permissions. When someone changes jobs, you just change their role. Most companies use this.
- **Attribute-Based Access Control (ABAC):** decisions use several attributes together, like the user's department, the device, the location and the time. For example, "managers can view reports, but only from a company laptop during work hours."
- **Rule-based access control:** access follows set rules, like a firewall rule that blocks a port.
- **Time-based access control:** access is only allowed at certain times.

## NAC systems

**Network Access Control (NAC)** checks a device before letting it onto the network. Is antivirus running? Is it patched? Is it a company device? Devices that pass get normal access. Devices that fail are blocked or put on a restricted network until they're fixed. Cisco's product for this is called **ISE** (Identity Services Engine).

## Privileged accounts

**Privileged accounts** are the most powerful accounts: domain admins, root on Linux, and service accounts that applications use. They're the top target for attackers, because one stolen admin account can mean the whole network.

Good practice:
- admins use a normal account for daily work and a separate admin account only when needed
- privileged passwords are stored in a secure vault and changed regularly
- privileged access is given only for as long as it's needed
- everything done with these accounts is logged and reviewed

This is the job of **Privileged Access Management (PAM)** tools.

## File access control

File permissions decide who can read, change or run files. On Windows, NTFS permissions include Read, Write, Modify and Full Control, and can be set for users and groups. On Linux, it's read, write and execute for the owner, the group and everyone else, which I covered in my Linux post. The rule is the same everywhere: give the minimum access people need.

## Account policies in Windows

Windows lets admins set account rules in Local Security Policy (or Group Policy for a whole domain).

**Password policy** includes:
- password history: how many old passwords can't be reused
- maximum password age: how long before a password must be changed
- minimum password age: stops people from changing it several times in a row to get back to their old one
- minimum password length
- complexity requirements: a mix of uppercase, lowercase, numbers and symbols

**Account lockout policy** includes:
- lockout threshold: how many failed attempts before the account locks
- lockout duration: how long it stays locked
- reset counter after: how long before the failed-attempt count goes back to zero

Lockout is what stops brute-force guessing. Failed logins show up as Event ID 4625, which I already know from my home lab, and an account lockout as Event ID 4740.

## Authentication management

Managing authentication well means making strong security practical for people: password managers, so users don't reuse passwords; single sign-on, so they don't need dozens of them; MFA; and clear processes for resetting passwords and removing access when someone leaves.

## HMAC and hash functions in access control

The course also brought cryptography into access control. A **hash function** turns data into a fixed-length fingerprint, and it's how systems store passwords. Instead of saving your real password, the system saves its hash. When you log in, it hashes what you typed and compares the two.

**HMAC** adds a secret key to the hash, which proves a message wasn't changed *and* that it came from someone who knows the key. It's used to protect login tokens and messages between systems. I'll go deeper into both in my cryptography post.

## Authentication protocols and technologies

The common ones are:

- **Kerberos:** Windows domains use it. After you log in once, you get "tickets" that prove who you are to other services, so your password isn't sent around the network.
- **LDAP:** used to look up users and groups in directories like Active Directory.
- **RADIUS** and **TACACS+:** protocols for central AAA servers, which I compared in my Endpoint Security posts.
- **802.1X with EAP:** network-level authentication for Wi-Fi and wired ports.
- **SAML, OAuth and OpenID Connect:** used for federated identity and single sign-on.
- **PAP and CHAP:** older protocols. PAP sends passwords in plain text, which is unsafe. CHAP never sends the password itself.

## Access control strategies

The main principles that tie this together:

- **Least privilege:** give only the access needed for the job, nothing more
- **Need to know:** even with high clearance, you only see what your task requires
- **Separation of duties:** split sensitive tasks between people, so one person can't, for example, both create and approve a payment
- **Implicit deny:** if access isn't specifically allowed, it's blocked
- **Regular access reviews:** remove access people no longer need, especially after job changes

## How AAA works in practice

AAA can run **locally** on each router or switch, with user accounts stored on the device itself. That's fine for one or two devices, but it doesn't scale. In real networks, devices use **server-based AAA**, where a central server (RADIUS or TACACS+) holds all the accounts.

The flow looks like this: a user tries to log in to a router, the router passes the username and password to the AAA server, the server checks them and replies accept or reject, and the router lets the user in or not.

**AAA accounting logs** record what users did. They typically include who logged in, when the session started and stopped, which commands were run (with TACACS+), and how much data was used. A start record is written when the session begins and a stop record when it ends. For an investigation, these logs answer exactly who changed what on which device.

## Access control lists

This was the most "engineering" part of the day: how to write ACLs, where to put them, and how to use them to stop real attacks.

### What an ACL is

An **access control list (ACL)** is an ordered list of permit and deny statements on a router or firewall. Each statement (called an **ACE**, access control entry) checks packets against conditions like source address, destination address, protocol and port.

Three rules decide how it works:
1. The router checks the statements from top to bottom.
2. The first statement that matches decides what happens, and the router stops checking.
3. If nothing matches, the packet is dropped, because every ACL ends with an invisible **implicit deny**.

### Using ACLs to identify traffic

ACLs aren't only for blocking. They're also used to **identify** traffic for other features: choosing which addresses get translated by NAT, which traffic gets priority with QoS, which routes are shared, or which users can remotely manage the router.

### Packet filtering

When used for security, ACLs do **packet filtering**: looking at each packet and deciding whether to forward it or drop it. An ACL is applied to an interface in one direction:
- **inbound** ACLs check packets as they arrive, before the router decides where to send them
- **outbound** ACLs check packets just before they leave an interface

Each interface can have one ACL per direction per protocol (one for IPv4, one for IPv6).

### Numbered and named ACLs

On Cisco devices, ACLs can be identified by a number or a name.

**Standard ACLs** filter only by source IP address. Numbered standard ACLs use 1–99 or 1300–1999.

**Extended ACLs** filter by source and destination address, protocol and port, so they're much more precise. Numbered extended ACLs use 100–199 or 2000–2699.

**Named ACLs** use a descriptive name, like `BLOCK-GUEST-TO-SERVERS`, which is much easier to understand later. They're also easier to edit, since you can add or remove individual lines.

### Wildcard masks

ACLs use **wildcard masks** to say which bits of an address must match. It's the opposite of a subnet mask:
- a **0** bit means "this bit must match"
- a **1** bit means "ignore this bit"

#### Common types

- `0.0.0.0` matches one exact address. The keyword `host` does the same thing: `host 192.168.10.5`.
- `255.255.255.255` matches any address. The keyword `any` does the same thing.
- `0.0.0.255` matches a whole /24 subnet, like everything in 192.168.10.0–192.168.10.255.

#### Calculating a wildcard mask

The easy method: subtract the subnet mask from 255.255.255.255.

For a /26 network (subnet mask 255.255.255.192):
```
  255.255.255.255
- 255.255.255.192
= 0.0.0.63
```
So `192.168.10.0 0.0.0.63` matches 192.168.10.0 to 192.168.10.63.

For a range like 192.168.16.0 to 192.168.31.255 (that's 16 /24 networks, a /20):
```
  255.255.255.255
- 255.255.240.0
= 0.0.15.255
```
So `192.168.16.0 0.0.15.255` covers the whole range. This uses the same math as subnetting, which I practiced in my networking posts.

### Configuring a numbered standard ACL

The syntax is:

```
access-list <number> {permit | deny | remark} <source> [wildcard] [log]
```

Example: allow only the 192.168.10.0/24 network.

```
access-list 10 remark Allow only the admin LAN
access-list 10 permit 192.168.10.0 0.0.0.255
interface GigabitEthernet0/1
 ip access-group 10 out
```

The `remark` line is just a comment. The permit line allows the admin LAN, and everything else is denied by the implicit deny. `ip access-group 10 out` applies it to traffic leaving G0/1.

### Protocols and port numbers in extended ACLs

Extended ACLs can match protocols and ports. Ports can be written as numbers or names, so `eq 80` and `eq www` mean the same thing. Some common ones: 22 (SSH), 23 (Telnet), 25 (SMTP), 53 (DNS), 80 (HTTP), 443 (HTTPS).

```
access-list 110 permit tcp 192.168.10.0 0.0.0.255 any eq 443
access-list 110 permit udp 192.168.10.0 0.0.0.255 any eq 53
```

This lets the inside network use HTTPS and DNS.

### The `established` keyword

This is a simple trick for letting replies back in without letting new outside connections in.

```
access-list 120 permit tcp any 192.168.10.0 0.0.0.255 established
```

`established` only matches TCP packets that have the ACK or RST flag set, meaning they're part of a connection that already exists. So when an inside user opens a website, the replies come back in. But if someone on the internet tries to start a brand-new connection (a SYN with no ACK), it doesn't match and gets dropped. It's a basic form of what a stateful firewall does.

### Named extended ACLs

Named ACLs use a slightly different style. You first create the ACL, then add lines inside it:

```
ip access-list extended SURFING
 remark Allow web browsing from the inside LAN
 permit tcp 192.168.10.0 0.0.0.255 any eq 80
 permit tcp 192.168.10.0 0.0.0.255 any eq 443
ip access-list extended BROWSING
 remark Allow only return web traffic back in
 permit tcp any 192.168.10.0 0.0.0.255 established
interface GigabitEthernet0/0
 ip access-group SURFING in
 ip access-group BROWSING out
```

Here, G0/0 faces the inside LAN. SURFING checks traffic coming in from the LAN and only lets web traffic out. BROWSING checks traffic going back out to the LAN and only allows replies. The names make it obvious what each ACL does.

The course also had a syntax checker activity where I typed these commands myself, which helped a lot with remembering the order of each part.

### Where to place ACLs

Placement matters, because a badly placed ACL can block the wrong traffic or waste bandwidth.

- **Extended ACLs go close to the source** of the traffic being filtered. Since they're precise, you can drop unwanted traffic early, before it travels across the network.
- **Standard ACLs go close to the destination.** They only look at the source address, so if you put one near the source, it might block that source from reaching *everything*, not just the one destination you meant.

### Mitigating attacks with ACLs

#### Spoofing

Packets arriving from the internet should never have certain source addresses. An inbound ACL on the internet-facing interface can block:
- private addresses (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16)
- loopback addresses (127.0.0.0/8)
- 0.0.0.0/8 and multicast addresses as a source
- your own organization's public addresses (someone outside pretending to be you)

```
access-list 150 deny ip 10.0.0.0 0.255.255.255 any
access-list 150 deny ip 172.16.0.0 0.15.255.255 any
access-list 150 deny ip 192.168.0.0 0.0.255.255 any
access-list 150 deny ip 127.0.0.0 0.255.255.255 any
access-list 150 permit ip any any
```

#### Permitting necessary traffic through a firewall

On the edge, only allow what the business actually needs, like DNS, email (SMTP), web (HTTP/HTTPS) and SSH to specific servers, and deny the rest. For example, allowing the internet to reach only the public web server on port 443.

#### ICMP

Blocking all ICMP breaks useful things, so the usual approach is to allow only what's needed:
- **inbound:** echo-reply (replies to your own pings), unreachable, and packet-too-big (needed for path MTU discovery)
- **outbound:** echo (so you can ping out), parameter-problem and packet-too-big

Everything else, like redirects and timestamp requests from outside, is blocked.

#### SNMP

SNMP can reveal or even change device settings, so SNMP traffic from the internet should be explicitly denied at the edge. Management should only be allowed from specific internal management stations, and SNMPv3 should be used.

### IPv6 ACLs

IPv6 ACLs work like IPv4 extended named ACLs, with a few differences:

- they're **always named**, never numbered
- they use **prefix lengths** (like /64) instead of wildcard masks
- they're applied with `ipv6 traffic-filter` instead of `ip access-group`
- their implicit rules at the end are different: before the final implicit deny, they implicitly **permit neighbor discovery** messages (NS and NA). IPv6 needs these to work, the way IPv4 needs ARP.

Basic syntax:

```
ipv6 access-list NO-GUEST-TO-SERVERS
 deny ipv6 2001:db8:acad:20::/64 2001:db8:acad:10::/64
 permit ipv6 any any
interface GigabitEthernet0/1
 ipv6 traffic-filter NO-GUEST-TO-SERVERS in
```

This blocks the guest network (the :20 subnet) from reaching the servers (the :10 subnet) and allows everything else.

One thing to watch: if you add your own `deny ipv6 any any` at the end, you also block neighbor discovery and break IPv6 on that link. You'd need to permit ND messages explicitly first.

## Why this matters for a SOC engineer

Most real attacks involve stolen or misused accounts at some point. Failed logins, logins at strange hours, new admin accounts, and privileged accounts used from unusual machines are some of the most common alerts a SOC handles. On the network side, ACL logs (with the `log` keyword) show exactly what's being blocked, like scans and spoofed traffic, and knowing how ACLs are ordered and placed helps explain why some traffic got through. Anti-spoofing ACLs at the edge are one of the simplest, most effective controls a network can have.

## Questions I should be able to answer

- What are physical, logical and administrative access controls?
- What's the difference between identification and authentication?
- What counts as MFA, and what doesn't?
- What does zero trust mean?
- DAC vs MAC vs RBAC vs ABAC?
- What does NAC check?
- What's in a Windows password policy and account lockout policy?
- What's the difference between local and server-based AAA?
- How does a router process an ACL, and what is the implicit deny?
- Standard vs extended ACLs: what can each filter on, and where should each be placed?
- What wildcard mask matches a /26 network?
- What does the `established` keyword do?
- Which source addresses should an anti-spoofing ACL block?
- How are IPv6 ACLs different from IPv4 ACLs?

## Next

Tomorrow: firewalls and zone-based policy firewalls, and cloud security.
