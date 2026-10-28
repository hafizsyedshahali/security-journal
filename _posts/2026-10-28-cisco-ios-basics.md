---
title: "First Steps with Cisco IOS: Configuring and Securing a Small Network"
date: 2026-10-28 11:30:00 +0500
categories: [Daily Log]
tags: [networking, cisco-ios, icmp, ping, traceroute]
---

Today I moved from theory to the command line. I learned how Cisco switches and routers are configured, how to secure them, and how to test a network with ping and traceroute.

## Cisco IOS modes

Cisco devices have different modes, and each one allows different commands. The prompt tells you where you are:

- `Switch>`: **User EXEC mode.** Only basic viewing commands.
- `Switch#`: **Privileged EXEC mode.** Full viewing access. You get here with `enable`.
- `Switch(config)#`: **Global configuration mode.** You get here with `configure terminal`.
- `Switch(config-if)#` and `Switch(config-line)#`: settings for one interface or one line.

`exit` goes back one level, and `end` goes straight back to privileged mode.

## Helpful navigation tricks

- `?` shows which commands are available at that point
- **Tab** completes a command
- Commands can be shortened, so `conf t` works for `configure terminal`

## Seeing device information

- `show running-config`: the settings the device is using right now
- `show startup-config`: the settings it will load after a restart
- `show version`: IOS version, uptime, hardware
- `show ip interface brief`: quick list of interfaces, their IP addresses and status

An important point: changes go into the running config first. If you don't save them with `copy running-config startup-config`, they are lost when the device restarts.

## Basic setup and securing a device

A new device has no password at all, so securing it is one of the first jobs:

    hostname SW1
    enable secret <strong-password>
    line console 0
     password <password>
     login
    line vty 0 15
     transport input ssh
    service password-encryption
    banner motd # Authorized access only #

- `hostname` gives the device a clear name
- `enable secret` protects privileged mode and stores the password as a hash
- The console and vty lines need passwords. vty lines are for remote access.
- **SSH instead of Telnet:** Telnet sends everything, including passwords, in plain text. SSH encrypts it.
- `service password-encryption` hides other passwords in the config, but it is weak encryption. It only stops someone reading them over your shoulder.
- A banner warns that only authorized users are allowed

## Giving the switch and router IP addresses

A switch is managed through a virtual interface:

    interface vlan 1
     ip address 192.168.1.2 255.255.255.0
     no shutdown
    ip default-gateway 192.168.1.1

Router interfaces are configured the same way, and they need `no shutdown` because they are off by default.

## Default gateway

The default gateway is the router's address on the local network. When a device needs to reach something outside its own network, it sends the traffic to the gateway. Without it, a device can only talk to its own subnet.

## ICMP, ping and traceroute

ICMP is the protocol devices use to report problems and test connections.

- **Ping** sends an ICMP echo request and waits for an echo reply. It tells you if a device is reachable and how long the round trip takes.
- Other ICMP messages tell you when something fails, for example "destination unreachable" or "time exceeded".
- **Traceroute** (`tracert` on Windows) shows every router on the path. It uses the TTL value: each router lowers TTL by 1, and when it reaches 0 the router sends back a "time exceeded" message. By starting with TTL 1, then 2, then 3, you get a list of every hop.

## Why this matters for a SOC engineer

- Network devices are targets too. Default or weak passwords and Telnet are real findings in security audits.
- `show running-config` is the first place to check if someone changed a device's settings.
- Ping and traceroute are the first tools to use when an alert says "host unreachable" or traffic is taking a strange path.
- ICMP can be abused as well: ping sweeps are used to find live hosts, which is often the first step of an attack.
