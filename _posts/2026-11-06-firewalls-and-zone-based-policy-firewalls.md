---
title: "Network Defense, Part 3: Firewalls and Zone-Based Policy Firewalls"
date: 2026-11-06 14:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, firewalls, zpf, dmz, network-design, cisco-ios]
---

Firewalls came up in Endpoint Security, so the first part of this section was a quick refresher. The new part was the **zone-based policy firewall (ZPF)**: how it works and how to actually configure one on a Cisco router.

## Firewall basics, briefly

A firewall controls which traffic can pass between networks, based on rules.

Its three **properties**: it has to resist attacks itself, it has to be the only way traffic can pass between the networks, and it enforces the organization's access policy.

Its **benefits**: it keeps sensitive systems hidden from untrusted users, cleans up protocol flows, blocks malicious traffic, and puts most of the security rules in one place instead of on every device.

Its **limitations**: a misconfigured firewall causes serious problems and can become a single point of failure, some applications don't work well through firewalls, users may find ways around it, it can slow the network down, and unauthorized traffic can be hidden inside allowed traffic.

## Types of firewalls

- **Packet filtering (stateless):** checks each packet on its own, using addresses, protocol and ports. Fast and simple, but doesn't remember connections. Router ACLs work this way.
- **Stateful:** keeps track of connections, and only lets in packets that belong to a conversation that was allowed. This is the most common type.
- **Application gateway (proxy):** sits in the middle and inspects traffic up to the application layer. Thorough, but slower.
- **Next-generation firewall (NGFW):** a stateful firewall plus application awareness, a built-in IPS, URL filtering and malware protection.

## Firewalls in network design

### Common security architectures

- **Public and private:** the simplest design. Traffic from the trusted inside (private) to the internet (public) is allowed. Traffic from the internet to the inside is blocked, unless it's a reply to something the inside started.
- **Demilitarized zone (DMZ):** a third zone for servers the public needs to reach, like web and email servers. The internet can reach specific services in the DMZ, but the DMZ can't freely reach the inside. If a public server is hacked, the attacker is still kept away from the internal network.
- **Zone-based policy firewall:** the network is split into as many zones as needed (inside, outside, DMZ, guest and so on), and rules are written for traffic between each pair of zones.

### Layered defense

A firewall shouldn't be the only line of defense. A **layered defense** combines firewalls at the edge and between internal zones with other controls: IPS, host-based firewalls and antivirus on endpoints, access control, and monitoring. If one layer misses something, the next can still catch it. It's defense in depth again, applied to network design.

## Zone-based policy firewalls (ZPF)

### What it is

On a Cisco router, a ZPF lets you group interfaces into **zones** and then write policies for traffic moving **between** zones. Instead of attaching separate ACLs to every interface, you think in terms of "what can go from INSIDE to OUTSIDE?" and "what can go from OUTSIDE to the DMZ?"

### Benefits

- It doesn't depend on ACLs, so policies are separate and easier to manage
- It blocks traffic between zones by default, so nothing passes unless a policy allows it
- Policies are easy to read and troubleshoot
- One policy can apply to many interfaces in the same zone
- It supports many zones, which fits networks with lots of segments

### Designing a ZPF

The design comes before the configuration, and has four steps:

1. **Decide the zones.** Group the network by security level, like inside, outside, DMZ and guest.
2. **Decide the policies between zones.** For each pair of zones, decide which traffic is allowed and in which direction. For example, inside to outside is allowed for web traffic, but outside to inside is not.
3. **Design the physical setup.** Plan which interfaces and devices sit in which zone, and where traffic flows.
4. **Identify any smaller groups within zones** and merge their traffic needs, so the policies cover everyone correctly.

### ZPF actions

When traffic matches a policy, the ZPF takes one of three actions:

- **Inspect:** allow the traffic and track it like a stateful firewall, so replies are automatically allowed back. This is the action used most.
- **Drop:** block the traffic (optionally logging it).
- **Pass:** allow the traffic in one direction only, without tracking. Replies aren't automatically allowed, so a separate policy is needed for the return direction.

### Rules for transit traffic

Transit traffic is traffic passing *through* the router from one interface to another. The rules:

- Both interfaces in the **same zone**: the traffic passes.
- Interfaces in **different zones** with a policy for that zone pair: the policy decides.
- Interfaces in **different zones** with no policy: the traffic is dropped.
- One interface in a zone and the other in **no zone**: the traffic is dropped.
- Neither interface in any zone: the traffic passes normally (any regular ACLs still apply).

Traffic to or from the router itself belongs to a special zone called the **self zone**, which is allowed by default unless you set a policy for it.

## Configuring a ZPF

The course broke configuration into clear steps. Here's the full example of letting the inside network browse the web and ping out.

**Step 1: Create the zones.**

```
zone security INSIDE
zone security OUTSIDE
```

**Step 2: Identify the traffic** with a class map.

```
class-map type inspect match-any INSIDE-PROTOCOLS
 match protocol http
 match protocol https
 match protocol dns
 match protocol icmp
```

`match-any` means traffic matching any of these protocols belongs to this class.

**Step 3: Define the action** with a policy map.

```
policy-map type inspect INSIDE-TO-OUTSIDE
 class type inspect INSIDE-PROTOCOLS
  inspect
```

Traffic in this class gets inspected, so replies will be allowed back automatically.

**Step 4: Create a zone pair and attach the policy.**

```
zone-pair security IN-TO-OUT source INSIDE destination OUTSIDE
 service-policy type inspect INSIDE-TO-OUTSIDE
```

This says: for traffic going from INSIDE to OUTSIDE, apply this policy.

**Step 5: Assign the zones to interfaces.**

```
interface GigabitEthernet0/0
 zone-member security INSIDE
interface GigabitEthernet0/1
 zone-member security OUTSIDE
```

**Step 6: Verify it.**

```
show zone security
show zone-pair security
show policy-map type inspect zone-pair sessions
```

These show the zones and which interfaces are in them, the zone pairs and their policies, and the live sessions being inspected. That last one is the most useful for checking that traffic is really flowing the way you expect.

I went through these steps in the syntax checker activity too, typing each command in order.

### Configuration considerations

A few things to keep in mind:
- An interface can belong to only **one** zone.
- Once an interface is in a zone, it can only talk to interfaces in other zones if there's a policy for that zone pair.
- Don't mix ZPF with the older Cisco firewall feature (CBAC) on the same interface.
- Traffic to and from the router itself goes through the self zone, so management access needs its own thinking.
- Adding an interface to a zone without the matching policies can suddenly cut off traffic, so changes should be planned.

## Why this matters for a SOC engineer

Firewalls are one of the biggest sources of logs a SOC sees. Knowing how zones and policies work explains why traffic was allowed or dropped, and spotting allowed traffic that *shouldn't* be allowed is part of finding misconfigurations before attackers do. The ZPF way of thinking (zones and the traffic allowed between them) also matches how modern firewalls from other vendors are set up.

## Questions I should be able to answer

- What's the difference between the public/private, DMZ and ZPF designs?
- What are the three ZPF actions, and how is inspect different from pass?
- What happens to traffic between two zones with no policy?
- What is the self zone?
- What are the configuration steps for a ZPF, in order?
- Why can an interface only be in one zone?

## Next

Tonight: cloud security, covering virtualization, cloud models, the top cloud threats and the 14 domains of cloud security.
