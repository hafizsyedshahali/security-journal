---
title: "Cables, Ethernet and How Switches Work"
date: 2026-10-22 22:00:00 +0500
categories: [Daily Log]
tags: [networking, ethernet, mac-address, switching]
---

This post covers the bottom two layers: the physical layer (cables and signals) and the data link layer (Ethernet, MAC addresses and switches). This is where data actually moves inside a local network.

## Network media

Data has to travel over something. There are three main options.

### Copper

- Carries data as electrical signals.
- The most common type in offices is **UTP** (Unshielded Twisted Pair). The wires are twisted in pairs to reduce interference.
- Categories like **Cat 5e** and **Cat 6** support different speeds. Cat 6 is common in new offices.
- Copper is cheap and easy to install, but it is limited to about 100 meters and can pick up electrical noise.

### Fiber optic

- Carries data as pulses of light through glass.
- **Single-mode fiber** uses a laser and can go many kilometers. It's used between buildings and by internet providers.
- **Multimode fiber** uses LEDs and covers shorter distances, like inside a data center.
- Fiber is very fast and isn't affected by electrical interference, but it costs more.

### Wireless

- Carries data as radio waves.
- Very convenient, but the signal can be blocked by walls, it's shared with other users, and anyone nearby can try to listen. That's why wireless security matters so much.

## Ethernet

Ethernet is the standard almost every wired LAN uses. It works at Layers 1 and 2.

An **Ethernet frame** contains:
- **Destination MAC address:** who the frame is for
- **Source MAC address:** who sent it
- **Type:** what's inside, for example IPv4 or IPv6
- **Data:** the packet itself
- **FCS (Frame Check Sequence):** a check value. If the frame got damaged on the way, the receiver sees it and drops the frame.

## MAC addresses

A MAC address is the hardware address of a network card.

- It is **48 bits** long, written in hex, like `00:1A:2B:3C:4D:5E`.
- The first half is the **OUI**, which identifies the manufacturer. The second half is unique to that card.
- `FF:FF:FF:FF:FF:FF` is the **broadcast** address. A frame sent to it goes to every device on the LAN.

The difference between MAC and IP addresses finally made sense to me like this:
- The **MAC address** is like a person's name. It's used to deliver inside the local room.
- The **IP address** is like a postal address. It's used to find the right building anywhere in the world.

## Duplex

- **Half duplex:** only one side can talk at a time, like a walkie-talkie.
- **Full duplex:** both sides can send and receive at the same time, like a phone call.

Modern switches use full duplex, so collisions basically don't happen anymore. A duplex mismatch (one side half, the other full) is a classic cause of a slow connection.

## How a switch works

A switch is smarter than an old hub. A hub sent every frame out of every port. A switch learns where devices are and sends frames only where they need to go.

It does this with a **MAC address table**:

1. **Learn:** when a frame arrives, the switch looks at the **source** MAC address and writes down which port it came from.
2. **Forward:** it looks at the **destination** MAC address. If it knows the port, it sends the frame only out of that port.
3. **Flood:** if it doesn't know the destination yet, or the frame is a broadcast, it sends it out of every port except the one it came in on.

Entries in the table expire after a few minutes if a device goes quiet, so the table stays up to date.

On a Cisco switch you can see this table with `show mac address-table`.

## Why this matters for a SOC engineer

Layer 2 attacks are real and often missed because they happen inside the network:

- **MAC flooding:** an attacker sends thousands of frames with fake source MACs to fill the switch's table. When it's full, some switches start flooding all traffic to every port, so the attacker can see other people's data.
- **MAC spoofing:** a device copies the MAC address of a trusted device to get past simple filters.
- Physical access matters too. An unused, active network port in a meeting room is an open door.

Defenses include **port security** on switches (limiting how many MAC addresses a port can learn), turning off unused ports, and **802.1X** so a device must log in before it gets network access.

The MAC address table is also useful during an investigation. If I know a suspicious device's MAC address, the switch tells me exactly which port, and so which desk or room, it's plugged into.

## Next

Tomorrow: subnetting, step by step.
