---
title: "Cybersecurity Foundations, Part 1: Data, Privacy, the McCumber Cube and Attackers"
date: 2026-10-30 12:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, privacy, mccumber-cube, threat-actors]
---

Today I went through my notes from Cisco's Introduction to Cybersecurity, the first course in my Security+ phase. There was a lot in it, so I'm splitting it into two posts. This one is about data, privacy and the people behind attacks. The next one is about the attacks themselves.

## What cybersecurity is

Cybersecurity is the ongoing effort to protect networked systems and data from unauthorized use or harm. It works at three levels:

- **Personal:** protecting your own identity, devices and data
- **Organizational:** protecting a company's systems, data and reputation
- **National:** protecting a country's critical infrastructure, its economy and its people

## Your identity: online and offline

Everyone has two identities.

- **Offline identity:** the person friends and family know: name, age, address
- **Online identity:** how you appear to others on the internet. This should reveal as little as possible about your real self.

A simple but useful lesson was about **usernames**. A username should not give away personal information like your full name, birth year or city. Something like `ali_1999_lahore` tells an attacker three facts before they even start.

## Your data tells a story

Almost everything we do creates data: messages, photos, location history, purchases, medical records, school results, even the steps counted by a fitness app.

Each piece looks harmless on its own. Put together, the data shows **your behaviour**: where you go, what you buy, who you talk to and when. Companies feed this data into **predictive models** to guess what you will do next, for advertising and much more.

The phrase from my notes that stayed with me: **privacy is the price we pay for digital convenience.** Free apps and services are often paid for with our data.

## What happens when data leaks

The potential harms of a data leak include:

- Identity theft and fraud
- Financial loss
- Blackmail or embarrassment
- Fake accounts created in your name
- Data that, once it leaks, can never be fully taken back

## Types of organizational data

Organizations hold several kinds of valuable data:

- **Transactional data:** records of sales, payments and other business activity
- **Intellectual property:** patents, trade secrets, designs and source code. Losing this can destroy a company's advantage.
- **Financial data:** income statements, balance sheets, cash flow

The **Internet of Things (IoT)** adds even more. Sensors, cameras and smart devices in factories, hospitals and homes collect huge amounts of data, and every connected device is one more thing that has to be secured.

## The McCumber Cube

This was the most useful model in the course. The McCumber Cube is a way to think about protecting information from three angles at once. Picture a cube with three sides:

**1. Security principles (what we protect for)**
- **Confidentiality:** only authorized people can see the data
- **Integrity:** the data is accurate and not changed without permission
- **Availability:** the data is there when authorized people need it

**2. States of data (where the data is)**
- **At rest:** stored on a disk, in a database or in the cloud
- **In transit:** moving across a network
- **In process:** being used or changed by a program

**3. Safeguards (how we protect it)**
- **Awareness, training and education:** people knowing what to do
- **Technology:** firewalls, encryption, antivirus and similar tools
- **Policies and procedures:** written rules and steps everyone follows

The idea is that every piece of data needs protection in every state, using all three kinds of safeguards. Encrypting data at rest does nothing if the same data travels unencrypted over the network.

## Consequences of a security breach

A breach hurts in more ways than just the stolen data:

- **Reputation damage:** customers stop trusting the company
- **Vandalism:** defaced websites or deleted data
- **Theft:** customer data, money or intellectual property
- **Lost revenue:** systems down, fines, legal costs
- **Damaged intellectual property:** competitors may gain what took years to build

## Types of attackers

- **Amateurs (script kiddies):** little skill, often use tools and scripts written by others. Still dangerous because the tools are powerful.
- **Hackers**, grouped by intent:
  - **White hat:** ethical hackers who break in with permission to find weaknesses
  - **Gray hat:** find weaknesses without permission, then may report them or not
  - **Black hat:** break in for personal or financial gain, or to cause harm
- **Organized groups:** cybercriminals working like businesses, hacktivists pushing a political or social cause, and state-sponsored attackers working for a government

Attacks can also come from **inside** an organization, from employees or contractors, on purpose or by accident.

## Cyberwarfare

Cyberwarfare is when one nation attacks another nation's networks and systems. It can **destabilize a nation** without a single soldier crossing a border.

The well-known example is **Stuxnet**, malware built to damage centrifuges in Iran's nuclear program by sending them false commands while showing operators normal readings.

Effects of cyberwarfare can include:
- Stolen defense and technology secrets
- Damage to power grids, water systems and other critical infrastructure
- Disrupted economies
- People losing trust in their own government

## Why this matters for a SOC engineer

- The **McCumber Cube** is a simple checklist for any incident: which principle was hit, which state was the data in, and which safeguard failed?
- Knowing the **type of attacker** helps judge an alert. A noisy scan from a script kiddie looks very different from a quiet, patient state-sponsored intrusion.
- Insider threats are a reminder that not every alert comes from outside the firewall.

## Next

Part 2 tonight: malware types, the symptoms of an attack, social engineering, DoS, DDoS, botnets and password attacks.
