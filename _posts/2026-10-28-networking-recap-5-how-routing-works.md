---
title: "Networking Recap 5: How Routers Decide Where Packets Go"
date: 2026-10-28 10:00:00 +0500
categories: [Networking Recap]
tags: [networking, routing, default-gateway, nat]
---

A switch moves data inside one network. A router moves data between networks. This post is about how that decision is made, first on my own laptop and then on the router.

## Step 1: my laptop's decision

Before sending anything, my laptop asks one question: **is the destination on my own network or not?**

It compares the destination IP with its own IP and subnet mask.

- **Same network:** it sends the frame directly. It uses ARP to find the destination's MAC address.
- **Different network:** it sends the frame to its **default gateway**, which is the router. It uses ARP to find the router's MAC address, not the final destination's.

Example: my laptop is `192.168.1.10/24` and the gateway is `192.168.1.1`.
- Sending to `192.168.1.20`: same network, deliver directly.
- Sending to `8.8.8.8`: different network, hand it to `192.168.1.1`.

Without a default gateway, a device can only talk to its own subnet. That is why "I can print but I can't open websites" often means a wrong or missing gateway.

## Step 2: the router's decision

When a packet arrives, the router:

1. Reads the **destination IP address**
2. Looks it up in its **routing table**
3. Picks the best matching route
4. Lowers the **TTL** (time to live) by 1. If TTL reaches 0, the packet is dropped. This stops packets from looping forever.
5. Builds a **new frame** with new MAC addresses for the next link and sends it out

The IP addresses stay the same the whole way. The MAC addresses change at every router.

## The routing table

A routing table is a list of networks the router knows and how to reach them. Routes come from three places:

- **Directly connected:** networks on the router's own interfaces. The router knows these as soon as the interface has an IP and is up.
- **Static routes:** added by hand by an administrator. Simple and predictable, but they don't adjust if a link fails.
- **Dynamic routes:** learned automatically from other routers using routing protocols like **OSPF**. Better for bigger networks because they adjust to changes.

On a Cisco router, the routing table is shown with `show ip route`.

## The default route

A router can't know every network in the world. So it has a **default route**, written `0.0.0.0/0`. It means "if nothing else matches, send it here". For a home or small office, the default route points to the internet provider.

## Longest prefix match

Sometimes more than one route matches. The router picks the **most specific** one, the route with the longest prefix.

Example: a packet for `10.1.5.20`
- Route A: `10.0.0.0/8`
- Route B: `10.1.5.0/24`

Both match, but `/24` is more specific than `/8`, so the router uses **Route B**. The default route `/0` is the least specific, so it is only used when nothing else matches.

## NAT at the edge

Most homes and offices use private addresses inside. The router at the edge uses **NAT** to swap the private source address for its single public address when traffic goes to the internet, and swaps it back for the replies. This is how many devices share one public IP.

## Testing the path

- `ping` checks if the destination is reachable
- `traceroute` (`tracert` on Windows) shows every router hop on the way, using the TTL trick
- `ipconfig` (Windows) or `ip addr` / `ifconfig` (Linux and Mac) shows my own IP, mask and gateway

## Why this matters for a SOC engineer

- **Segmentation:** routers and firewalls between subnets are where you stop an attacker moving from a user laptop to a database server. Knowing the routing tells me which paths are even possible.
- **Unexpected paths:** traffic suddenly taking a different route, or a new default gateway on a network, can mean misconfiguration or an attack. A rogue DHCP server handing out a fake gateway is one example.
- **NAT and investigations:** the public IP in an external alert may belong to hundreds of devices. To find the real machine, you need the NAT logs from the edge device, matched by time and port.
- **TTL values** in logs can give hints about the sending operating system and how many hops away it is.

## Next in this series

The last recap post: wireless networks and how to secure a home or small office network.
