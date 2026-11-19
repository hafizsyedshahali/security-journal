---
title: "Cyber Security 101, Part 4: Networking Essentials and Core Protocols"
date: 2026-11-13 21:00:00 +0500
categories: [Daily Log, Cyber Security 101]
tags: [networking, dhcp, arp, dns, http, email-protocols, tryhackme]
---

I covered most of this in the Cisco networking courses, so these two rooms worked as a fast revision with a security lens. The focus was on what each protocol does, which port it uses, and what it looks like when you watch it on the wire.

## DHCP: getting an address automatically

When a device joins a network, it needs an IP address, a subnet mask, a default gateway and a DNS server. **DHCP (Dynamic Host Configuration Protocol)** hands these out automatically. It uses **UDP**: the server listens on **port 67** and the client uses **port 68**.

The exchange is called **DORA**:

1. **Discover:** the new device broadcasts "is there a DHCP server here?"
2. **Offer:** the server replies with an available IP address.
3. **Request:** the client asks to use that address.
4. **Acknowledge:** the server confirms, and the address is leased for a set time.

Because the client accepts the first offer it gets, a rogue DHCP server can hand out a fake gateway or DNS server. That's why switches support DHCP snooping.

## ARP: from IP address to MAC address

IP addresses work at **layer 3**, but on a local network frames are delivered using **MAC addresses** at **layer 2**. **ARP (Address Resolution Protocol)** bridges the two:

1. A device broadcasts an **ARP request**: "Who has 192.168.1.1? Tell 192.168.1.20."
2. The owner replies with an **ARP reply** containing its MAC address.
3. The answer is stored in the **ARP cache** for a while.

ARP has no authentication, which is what makes ARP spoofing possible.

## ICMP: troubleshooting the network

**ICMP (Internet Control Message Protocol)** carries error and diagnostic messages. Two tools use it:

- **ping** sends an **Echo Request (type 8)** and expects an **Echo Reply (type 0)**. It tells you whether a host is reachable and the round-trip time.
- **traceroute** (`tracert` on Windows) finds each router on the path. It sends packets with a small **TTL** (time to live), starting at 1. Each router lowers the TTL by one, and when it reaches zero the router sends back an ICMP **Time Exceeded** message, revealing itself.

## Routing

**Routing** is how packets find their way between networks. Routers keep routing tables and use protocols to share routes:

- **OSPF:** routers share the state of their links and build a full map of the network.
- **EIGRP:** a Cisco protocol that picks routes based on bandwidth and delay.
- **BGP:** the protocol that connects the networks of the internet together.
- **RIP:** an old, simple protocol that picks the route with the fewest hops.

## NAT: sharing one public address

There aren't enough IPv4 addresses for every device. **NAT (Network Address Translation)** lets many devices with private addresses (like `192.168.x.x`) share one public IP. The router keeps a translation table that maps each internal connection to a port on the public address, so replies come back to the right device.

## DNS: remembering addresses

People remember names, computers use numbers. **DNS (Domain Name System)** translates one into the other. It mainly uses **UDP port 53** (TCP 53 for large responses and zone transfers).

Common record types:

| Record | Holds |
|---|---|
| **A** | an IPv4 address |
| **AAAA** | an IPv6 address |
| **CNAME** | an alias pointing to another name |
| **MX** | the mail server for a domain |
| **TXT** | free text, used for things like SPF and domain verification |

You can query DNS yourself:

```bash
nslookup example.com
nslookup -type=MX example.com
```

DNS is one of the most useful log sources in a SOC. Malware has to look up its command-and-control domain, so a machine resolving a strange new domain is often the first sign of trouble.

## WHOIS

**WHOIS** shows who registered a domain, when, through which registrar, and when it expires (personal details are often hidden for privacy). For an analyst, a domain registered two days ago that suddenly appears in your email traffic deserves a closer look.

## HTTP(S): accessing the web

**HTTP** is how browsers talk to web servers, on **TCP port 80**. **HTTPS** is the encrypted version on **port 443**. The main request methods:

- **GET:** fetch something, like a page
- **POST:** send data, like a login form
- **PUT:** create or replace something on the server
- **DELETE:** remove something

I'll go deeper into HTTP messages in the web post later this week.

## Transferring files and email

| Protocol | Job | Port |
|---|---|---|
| **FTP** | transferring files | TCP 21 (control) and 20 (data) |
| **SMTP** | **sending** email between servers | TCP 25 |
| **POP3** | **receiving** email by downloading it, usually removing it from the server | TCP 110 |
| **IMAP** | **syncing** email, so it stays on the server and looks the same on every device | TCP 143 |

All four were designed long ago and send everything, including passwords, in **cleartext**. Anyone who can capture the traffic can read it. That's the reason for the secure versions in the next post.

## Famous ports

| Port | Protocol |
|---|---|
| 20/21 | FTP |
| 22 | SSH |
| 23 | Telnet |
| 25 | SMTP |
| 53 | DNS |
| 67/68 | DHCP |
| 80 | HTTP |
| 110 | POP3 |
| 143 | IMAP |
| 443 | HTTPS |
| 3389 | RDP |

## Why this matters for a SOC engineer

Every alert eventually comes down to traffic: an IP, a port and a protocol. Knowing what's normal (DNS on 53, web on 443) is what lets you notice what isn't, like DNS requests going to an outside server instead of the company's own, or a workstation suddenly sending SMTP traffic.

## Questions I should be able to answer

- Explain DORA. Which ports does DHCP use?
- What does ARP do, and why is it easy to abuse?
- How does traceroute use the TTL field?
- What problem does NAT solve?
- What are A, AAAA, CNAME, MX and TXT records?
- What's the difference between SMTP, POP3 and IMAP?
- Why are FTP, SMTP, POP3 and IMAP unsafe on their own?

## Next

Tomorrow: the secure versions of these protocols. TLS, HTTPS, SSH, SFTP, FTPS and VPNs.
