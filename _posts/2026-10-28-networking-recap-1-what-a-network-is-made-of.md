---
title: "Networking Recap 1: What a Network Is Made Of"
date: 2026-10-28 06:00:00 +0500
categories: [Networking Recap]
tags: [networking, lan, wan, network-design]
---

Over the last few weeks I finished Cisco's networking courses. Before moving on to cloud, I want to write down everything I learned in one place. This is the first post in a short recap series. Writing it out is also my revision.

This post is about the basics: what a network is, what it's made of, and how it is designed.

## What a network is

A network is two or more devices connected so they can share data. That's it. My phone talking to my home router is a network. The internet is just a huge network of networks.

Networks come in different sizes:

- **LAN (Local Area Network):** a network in one place, like a home, an office or a school. It is usually owned and managed by one person or one company.
- **WAN (Wide Area Network):** connects LANs that are far apart, like offices in different cities. WAN links are usually rented from a service provider.
- **The internet:** millions of networks connected together around the world.
- **Intranet and extranet:** an intranet is a private network only for people inside a company. An extranet gives limited access to outside partners, like suppliers.

## The three building blocks

Every network, small or big, is built from three kinds of things.

**1. End devices.** These are the devices people actually use: laptops, phones, servers, printers, cameras. Data starts and ends at an end device. They are also called hosts.

**2. Intermediary devices.** These sit in the middle and move data around:
- **Switch:** connects devices inside the same LAN
- **Router:** connects different networks and decides where traffic goes next
- **Wireless access point:** lets devices join the network without a cable
- **Firewall:** checks traffic and blocks what isn't allowed

**3. Media.** This is the path the data travels on:
- **Copper cable:** carries electrical signals
- **Fiber optic cable:** carries light, very fast and over long distances
- **Wireless:** carries radio waves through the air

## Who serves whom

There are two common ways devices share work:

- **Client-server:** a server provides a service (a website, email, files) and clients ask for it. Most of the internet works this way.
- **Peer-to-peer:** every device is equal and can both ask and serve. It is simple but hard to manage and secure when it grows.

## Topologies

A topology is the layout of a network.

- The **physical topology** shows where devices and cables actually are.
- The **logical topology** shows how data flows and which addresses are used.

Today almost every LAN uses a **star** topology: every device connects to a central switch. If one cable breaks, only that one device is affected.

## Designing a network in layers

Small networks can be one switch and one router. Bigger networks are designed in layers so they are easier to grow and fix:

- **Access layer:** where users and devices connect, like the switch on each office floor
- **Distribution layer:** connects the access switches and applies rules about who can talk to whom
- **Core layer:** the fast backbone that connects everything and links to the outside world

In smaller companies the core and distribution layers are often merged into one. This is called a **collapsed core**.

## What makes a network reliable

Cisco describes four things a good network needs:

1. **Fault tolerance:** if one link or device fails, traffic can take another path.
2. **Scalability:** you can add more users and devices without redesigning everything.
3. **Quality of Service (QoS):** important traffic, like voice calls, gets priority over less urgent traffic, like downloads.
4. **Security:** protecting the network and its data.

Security itself is often explained with the **CIA triad**:
- **Confidentiality:** only the right people can see the data
- **Integrity:** the data isn't changed without permission
- **Availability:** the network and data are there when people need them

## Why this matters for a SOC engineer

When an alert comes in, the first questions are always about the network: Which device is this? Is it an end device or a server? Which part of the network is it in? Is this traffic staying inside the LAN or going out to the internet?

Knowing the layers also helps with investigations. Access switches show which port and room a device is connected to. The firewall and core show traffic leaving the company. And the CIA triad is the simplest way to explain the impact of an incident: was data seen, changed, or made unavailable?

## Next in this series

The OSI and TCP/IP models, and how data is wrapped and unwrapped as it moves through a network.
