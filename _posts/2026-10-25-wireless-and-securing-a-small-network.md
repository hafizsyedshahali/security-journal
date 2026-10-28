---
title: "Wireless and Securing a Small Network"
date: 2026-10-25 22:00:00 +0500
categories: [Daily Log]
tags: [networking, wireless, wpa3, network-security]
---

Today's topic brought a lot of this week together with something most of us use every day: a home or small office wireless network, and how to secure it.

## One box, many jobs

The "Wi-Fi router" at home is actually several devices in one:

- **Router:** connects the home network to the internet provider
- **Switch:** the LAN ports on the back
- **Wireless access point:** creates the Wi-Fi network
- **DHCP server:** gives every device an IP address, mask, gateway and DNS server
- **NAT:** lets every device share one public IP address
- **Basic firewall:** blocks unwanted connections from the internet

Seeing it this way connected all the earlier topics for me. Almost everything I studied this week is running inside that one small box.

## How Wi-Fi works

- The network name is the **SSID**.
- Wi-Fi mainly uses two frequency bands:
  - **2.4 GHz:** longer range and goes through walls better, but slower and more crowded
  - **5 GHz:** faster and less crowded, but shorter range
  - Newer devices also support **6 GHz** (Wi-Fi 6E and Wi-Fi 7)
- Each band is split into **channels**. If many nearby networks use the same channel, they slow each other down.
- Wi-Fi is a **shared medium**. Everyone nearby is on the same air, which is why encryption matters so much.

## Wireless security standards

From weakest to strongest:

| Standard | Status |
|---|---|
| Open (no password) | Anyone can join and traffic isn't encrypted |
| WEP | Broken. Can be cracked in minutes. Never use it. |
| WPA | Outdated |
| WPA2 | Still common and acceptable with a strong password |
| WPA3 | Current best. Stronger protection against password guessing |

**WPA2/WPA3-Personal** uses one shared password for everyone. **WPA2/WPA3-Enterprise** gives each user their own login through a central server, which is what companies use.

## Securing a small network: my checklist

1. **Change the router's default admin password.** Default logins are public and well known. This is the single most important step.
2. **Use WPA3, or WPA2 if WPA3 isn't available,** with a long, unique Wi-Fi password.
3. **Turn off WPS.** The push-button or PIN setup is convenient but has known weaknesses.
4. **Update the router's firmware.** Old firmware has known vulnerabilities that attackers scan for.
5. **Use a guest network** for visitors and smart devices like TVs and cameras, so they are kept away from laptops and phones.
6. **Turn off remote management** unless it's really needed, so the admin page isn't reachable from the internet.
7. **Check connected devices now and then.** Unknown devices on the list are worth a look.

Two things that sound like security but aren't really:
- **Hiding the SSID:** the network still shows up to anyone with the right tools.
- **MAC address filtering:** MAC addresses can be copied easily, as I wrote in the Ethernet post.

They don't hurt, but they shouldn't replace a strong password and WPA3.

## Testing a small network

After setting it up, a simple check from a connected device:

1. `ipconfig` / `ip addr`: did I get an IP address, mask, gateway and DNS server from DHCP?
2. `ping` the gateway: is the local network working?
3. `ping 8.8.8.8`: is the internet reachable by IP?
4. `nslookup google.com`: is DNS working?

If step 3 works but step 4 fails, the problem is DNS, not the connection. Going layer by layer like this saves a lot of guessing.

## Why this matters for a SOC engineer

- **Default credentials** on routers, cameras and other devices are still one of the most common ways attackers get in. Botnets scan the internet for them all day.
- **Rogue access points:** a fake Wi-Fi network with a familiar name (an "evil twin") can trick users into connecting through an attacker.
- **Shadow IT:** an employee plugging their own Wi-Fi router into the office network can open a hole around the company's security.
- With remote work, a user's home network is now part of the company's attack surface. Basic home network security is company security.

## Next

Next I start Cisco's Networking Devices course, going deeper into switches, routers and IP addressing.
