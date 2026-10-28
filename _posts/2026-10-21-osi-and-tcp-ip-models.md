---
title: "The OSI and TCP/IP Models"
date: 2026-10-21 22:00:00 +0500
categories: [Daily Log]
tags: [networking, osi-model, tcp-ip, encapsulation]
---

Networking has a lot of moving parts. To make sense of them, people split the work into layers. Each layer has one job and only talks to the layer above and below it. There are two models everyone uses: the OSI model and the TCP/IP model.

## Why layers help

Layers make networking easier to build and easier to fix.

- Different companies can build different parts. A browser maker doesn't need to know anything about cables.
- When something breaks, you can check one layer at a time instead of guessing.

## The OSI model: 7 layers

From the bottom up:

| # | Layer | What it does | Examples |
|---|---|---|---|
| 1 | Physical | Sends raw bits as signals | Cables, Wi-Fi radio, fiber |
| 2 | Data Link | Moves frames inside one local network | Ethernet, MAC addresses, switches |
| 3 | Network | Moves packets between networks | IP addresses, routers |
| 4 | Transport | Delivers data to the right application | TCP, UDP, port numbers |
| 5 | Session | Starts, manages and ends conversations | Session setup and teardown |
| 6 | Presentation | Formats, compresses and encrypts data | Encoding, TLS encryption |
| 7 | Application | What the user's apps use | HTTP, DNS, SMTP, SSH |

A common way to remember the order from the top down: **"All People Seem To Need Data Processing."**

## The TCP/IP model: 4 layers

The TCP/IP model is the one the internet actually runs on. It's simpler and merges some OSI layers:

| TCP/IP layer | Matches OSI layers |
|---|---|
| Application | 5, 6 and 7 |
| Transport | 4 |
| Internet | 3 |
| Network Access | 1 and 2 |

In real life, people mix the two. Engineers say things like "that's a Layer 2 problem" or "a Layer 7 firewall" using OSI numbers, even though the traffic itself follows TCP/IP.

## Encapsulation: wrapping the data

When I send something, it travels down the layers on my device. Each layer adds its own header, like putting a letter in an envelope, and then that envelope in a bigger box.

1. **Application:** the data itself, for example a web request
2. **Transport:** adds a TCP or UDP header with port numbers. Now it is a **segment**.
3. **Network:** adds an IP header with source and destination IP. Now it is a **packet**.
4. **Data Link:** adds an Ethernet header with MAC addresses, and a trailer for error checking. Now it is a **frame**.
5. **Physical:** turns the frame into **bits** on the wire or in the air.

These names (data, segment, packet, frame, bits) are called **PDUs**, Protocol Data Units.

On the other side, the receiving device does the opposite. Each layer reads and removes its own header and passes the rest up. This is **de-encapsulation**.

One detail that clicked for me: as a packet travels across the internet, the **IP addresses stay the same** from start to end, but the **MAC addresses change at every router**, because each router builds a new frame for the next local link.

## Protocols and standards

A protocol is a set of rules both sides agree on. Without shared rules, devices from different companies couldn't talk to each other. Groups like the IEEE and IETF write these open standards, which is why a Dell laptop, an iPhone and a Cisco router can all work together.

## Using the layers to troubleshoot

A simple bottom-up check:

1. **Layer 1:** is the cable plugged in, is Wi-Fi connected?
2. **Layer 2:** is the device connected to the switch, is it on the right network?
3. **Layer 3:** does it have a valid IP address, can it ping the gateway?
4. **Layer 4:** is the right port open?
5. **Layer 7:** is the application or service itself working?

## Why this matters for a SOC engineer

Security tools are described by the layer they work at:

- A traditional firewall filters on Layer 3 and 4 (IP addresses and ports).
- A web application firewall (WAF) looks at Layer 7 (the actual HTTP requests).
- Attacks are described the same way: ARP spoofing is a Layer 2 attack, a SYN flood is Layer 4, and SQL injection is Layer 7.

When I read an alert, knowing the layer tells me which logs to check: switch logs for Layer 2, firewall logs for Layer 3 and 4, and web server or proxy logs for Layer 7.

## Next

Tomorrow: cables, Ethernet frames, MAC addresses and how switches decide where to send data.
