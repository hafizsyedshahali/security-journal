---
title: "Subnetting, Step by Step"
date: 2026-10-23 22:00:00 +0500
categories: [Daily Log]
tags: [networking, ipv4, subnetting, cidr]
---

Subnetting was the topic that took me the longest to feel comfortable with. This post is my attempt to explain it simply, the way I wish someone had explained it to me.

## What a subnet mask does

An IPv4 address has 32 bits. The subnet mask splits those bits into two parts:

- The **network part:** which network the device is on
- The **host part:** which device it is on that network

Example: `192.168.1.10` with mask `255.255.255.0`

- `255` in the mask means "this part is the network"
- `0` means "this part is for hosts"
- So the network is `192.168.1.0`, and the host is `.10`

## CIDR notation

Writing `255.255.255.0` every time is long, so we count the network bits instead. `255.255.255.0` has 24 ones in binary, so we write **/24**.

| CIDR | Mask | Usable hosts |
|---|---|---|
| /24 | 255.255.255.0 | 254 |
| /25 | 255.255.255.128 | 126 |
| /26 | 255.255.255.192 | 62 |
| /27 | 255.255.255.224 | 30 |
| /28 | 255.255.255.240 | 14 |
| /30 | 255.255.255.252 | 2 |

## Two addresses you can't give to a device

In every subnet:
- The **first** address is the **network address**. It names the network itself.
- The **last** address is the **broadcast address**. Sending to it reaches every device on that subnet.

That's why the usable host count is always **2^(host bits) − 2**. A /24 has 8 host bits: 2^8 = 256, minus 2 = **254 usable**.

## Why we subnet at all

Instead of one big network, we split it into smaller ones:

- **Less broadcast noise:** broadcasts stay inside their own subnet
- **Better security:** different groups (staff, guests, servers, cameras) can be kept apart, with rules between them
- **Less waste:** each group gets about the size it needs

## The block size method

This is the trick that made it click for me.

**Step 1: find the "interesting" octet.** That's the octet in the mask that isn't 255 or 0.

**Step 2: block size = 256 − that number.**

**Step 3: subnets start at multiples of the block size.**

### Example: split 192.168.10.0/24 into /26 subnets

- A /26 mask is `255.255.255.192`. The interesting octet is **192**.
- Block size = 256 − 192 = **64**
- Subnets start at 0, 64, 128 and 192

| Subnet | Network address | Usable range | Broadcast |
|---|---|---|---|
| 1 | 192.168.10.0 | .1 – .62 | 192.168.10.63 |
| 2 | 192.168.10.64 | .65 – .126 | 192.168.10.127 |
| 3 | 192.168.10.128 | .129 – .190 | 192.168.10.191 |
| 4 | 192.168.10.192 | .193 – .254 | 192.168.10.255 |

Four subnets, 62 hosts each.

### Example: which subnet is 192.168.10.75/26 in?

- Block size is 64. Multiples of 64: 0, **64**, 128...
- 75 falls between 64 and 128.
- So the network is **192.168.10.64**, the broadcast is **192.168.10.127**, and usable hosts are .65 to .126.

## How many subnets, how many hosts

- Borrowing **n** bits from the host part gives **2^n subnets**.
- With **h** host bits left, each subnet has **2^h − 2 hosts**.

Going from /24 to /26 borrows 2 bits: 2^2 = **4 subnets**. That leaves 6 host bits: 2^6 − 2 = **62 hosts**. Same answer as the table.

## Special address ranges to remember

- **Private addresses** (used inside homes and companies, not routed on the internet):
  - `10.0.0.0/8`
  - `172.16.0.0/12`
  - `192.168.0.0/16`
- **Loopback:** `127.0.0.1` means "this device itself"
- **APIPA:** `169.254.x.x` means the device couldn't get an address from DHCP and gave itself one

## Why this matters for a SOC engineer

Subnets are everywhere in security work:

- Firewall rules and SIEM searches are written in CIDR, like "alert on any traffic from 10.20.0.0/16 to the internet on port 445". I need to read these instantly.
- Knowing the network layout tells me at a glance if an IP is a server, a user laptop, a guest device or something from outside.
- An internal IP talking to many other subnets it never usually talks to can be a sign of **lateral movement** after an attack.
- A user complaining of "no internet" with a `169.254.x.x` address points straight to a DHCP problem, not a security incident.

## Next

Tomorrow: how routers decide where to send packets.
