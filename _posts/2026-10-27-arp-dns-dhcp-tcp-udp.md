---
title: "How Devices Find Each Other: ARP, DNS, DHCP, TCP and UDP"
date: 2026-10-27 22:00:00 +0500
categories: [Daily Log]
tags: [networking, arp, dns, dhcp, tcp, udp]
---

Today was about the services that work quietly in the background every time a device joins a network or opens a website.

## ARP: from IP address to MAC address

Inside a local network, devices actually deliver frames using MAC addresses, not IP addresses. So when my laptop wants to send data to 192.168.1.20, it first needs that device's MAC address.

ARP (Address Resolution Protocol) solves this:
- My laptop sends a broadcast: "Who has 192.168.1.20?"
- Only that device replies: "That's me, here is my MAC address."
- My laptop saves the answer in its ARP table, so it doesn't have to ask every time.

You can see the ARP table with `arp -a` on Windows and Mac, or `ip neigh` on Linux.

IPv6 doesn't use ARP. It uses Neighbor Discovery instead.

**Security angle:** ARP has no authentication. Any device can reply, even with a fake answer. This is called ARP spoofing or ARP poisoning, and it lets an attacker sit between two devices and read their traffic.

## DNS: from name to IP address

Humans remember names like github.com. Computers need IP addresses. DNS (Domain Name System) translates one into the other.

When I type a website name, my device asks a DNS server, gets the IP address back, and then connects. DNS mostly uses UDP port 53. It switches to TCP port 53 for large responses and zone transfers. You can test it with `nslookup github.com`.

**Security angle:** DNS logs are very useful in a SOC. Malware often calls out to strange domains, and DNS can even be abused to sneak data out (DNS tunneling).

## DHCP: getting an address automatically

When a device joins a network, it usually doesn't have an IP address yet. DHCP gives it one, along with the subnet mask, default gateway and DNS server.

The process has four steps, easy to remember as **DORA**:
1. **Discover:** the device asks "Is there a DHCP server here?"
2. **Offer:** the server offers an address
3. **Request:** the device asks for that address
4. **Acknowledge:** the server confirms

The address is given for a limited time, called a lease. DHCP uses UDP: the server listens on port 67 and the client on port 68.

**Security angle:** a fake (rogue) DHCP server could hand out a wrong default gateway and send all traffic through an attacker.

## The transport layer: TCP and UDP

IP gets the packet to the right device. The transport layer gets the data to the right application on that device, using port numbers.

### TCP: reliable

TCP is used when every byte must arrive correctly, like web pages, email and file transfers.

- **Three-way handshake** to start a connection: SYN → SYN-ACK → ACK
- **Sequence numbers** so data can be put back in the right order
- **Acknowledgments** so the sender knows what arrived, and **retransmission** if something is lost
- **Flow control** with a window size, so a fast sender doesn't overload a slow receiver
- The connection is closed cleanly with FIN and ACK messages

### UDP: fast

UDP sends data without a handshake and without checking if it arrived. Less reliable, but much faster and lighter. It's used where speed matters more than perfection: DNS, DHCP, voice calls, video streaming and online games.

## Port numbers

A port number tells the device which application the data is for. IP address + port is called a socket.

- **Well-known ports (0-1023):** 22 SSH, 23 Telnet, 25 SMTP, 53 DNS, 80 HTTP, 443 HTTPS
- **Registered ports (1024-49151):** used by specific applications
- **Dynamic ports (49152-65535):** temporary ports picked by my device for its side of a connection

You can see open connections and ports with `netstat -an`.

## Why this matters for a SOC engineer

Almost every security log has IP addresses, ports and protocols in it. Knowing these basics helps spot things that look wrong:
- Many SYN packets with no completed handshakes can mean a port scan
- A workstation talking on an unusual port can mean malware
- A strange domain in DNS logs can be the first sign of an infection
- Two different MAC addresses claiming the same IP can mean ARP spoofing
