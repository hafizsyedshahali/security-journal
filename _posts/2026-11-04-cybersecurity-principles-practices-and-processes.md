---
title: "Endpoint Security, Part 12: Cybersecurity Principles, Practices and Processes"
date: 2026-11-04 21:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, cia-triad, mccumber-cube, hashing, hmac, data-states, security-policies]
---

The last section of the Endpoint Security course went back to the basics: the principles behind everything I've studied so far. I saw the McCumber Cube in Introduction to Cybersecurity, but this time it went deeper, especially on how to actually protect data in each state.

## The three dimensions

The **cybersecurity cube**, also called the **McCumber Cube**, looks at protecting information from three angles at once.

The first is the **security principles**, what we're protecting for: confidentiality, integrity and availability, the CIA triad.

The second is the **states of data**, where the data is: being processed, sitting in storage, or moving across a network (transmission).

The third is the **safeguards**, how we protect it: people (awareness and training), technology, and policies and practices.

The idea is that every piece of data needs protecting in every state, using all three kinds of safeguards. Encrypting a database doesn't help much if the same data is emailed around in plain text.

## Confidentiality and data privacy

Confidentiality means only the right people can see the data. The main ways to get it are encryption, authentication (proving who you are) and access control (deciding what each person can see).

Protecting **data privacy** is closely related. It's about how personal data is collected, used and shared. Companies classify data (public, internal, confidential, restricted) so they know how carefully to handle each type, and laws like the EU's GDPR set rules they have to follow.

## Integrity

Integrity means the data is accurate and hasn't been changed by anyone who shouldn't change it.

### Hashing

A **hash** is a fixed-length fingerprint calculated from a file. Change even one character in the file and the hash comes out completely different. So if you hash a file today and again next month and the two hashes match, you know it hasn't changed.

```bash
sha256sum invoice.pdf
```

On Windows PowerShell the equivalent is `Get-FileHash invoice.pdf`. Software download pages often publish the hash so you can check your download wasn't tampered with. Older algorithms like MD5 and SHA-1 are now considered weak; SHA-256 is the usual choice.

### HMAC

A plain hash proves a file hasn't changed, but an attacker who changes the file can also just calculate a new hash. **HMAC** (hash-based message authentication code) fixes that by mixing a secret key into the hash. Only someone who knows the key can produce the right value, so an HMAC proves both that the data wasn't changed and that it came from someone who has the key.

```bash
openssl dgst -sha256 -hmac "mysecretkey" invoice.pdf
```

## Availability

Availability means the data and systems are there when people need them. The course listed seven ways to make sure of that:

1. **Equipment maintenance**: keep hardware in good shape and replace it before it fails
2. **OS and software updates and patches**: fix the bugs that cause crashes and outages
3. **Backup testing**: a backup you've never restored from is just a hope. Test that restores actually work.
4. **Disaster planning**: decide in advance what happens if a site goes down
5. **New technology implementations**: add things like redundancy and load balancing as the systems grow
6. **Activity monitoring**: watch systems so problems are spotted early
7. **Availability testing**: test that failover and recovery plans actually work

## Recovering after an attack

This part was hands-on. The labs walked through recovering files after an attack, using hashing and HMAC to check that files hadn't been changed, and using the OpenSSL tool to work with encrypted data: finding encrypted account credentials, uploading and downloading data, and decrypting the contents of a sensitive file.

Decrypting a file with OpenSSL looks like this:

```bash
openssl enc -d -aes-256-cbc -pbkdf2 -in secret.enc -out secret.txt
```

`-d` means decrypt, `aes-256-cbc` is the encryption algorithm, `-pbkdf2` is how the password is turned into a key, and `-in`/`-out` are the input and output files. It asks for the password and writes the readable file.

The bigger lesson was that good backups are what make recovery possible. A common rule is 3-2-1: three copies of your data, on two different types of storage, with one kept off-site.

## Data at rest

Data at rest is data in storage. The course covered the main types of storage:

- **DAS** (direct-attached storage): a drive connected directly to one computer, like its internal disk or an external USB drive
- **RAID** (redundant array of independent disks): several disks working together, either for speed or so the data survives if one disk fails. RAID 1, for example, keeps an exact copy on a second disk.
- **NAS** (network-attached storage): a storage device on the network that many users can reach, usually for shared files
- **SAN** (storage area network): a dedicated, high-speed network of storage that servers use as if it were their own disks
- **Cloud storage**: storage run by a provider like AWS or Google, reached over the internet

Protecting stored data is harder than it sounds. There are usually several copies in different places (including backups), each needs protecting, encryption keys have to be managed safely, and someone with physical access can simply take a drive.

## Data in transit

There are three ways data moves around: a **sneakernet** (literally carrying it on a USB drive or disk), **wired networks** and **wireless networks**.

The challenges match the CIA triad. Confidentiality in transit is about stopping people from reading data as it moves, mainly with encryption like TLS and VPNs. Integrity in transit is about making sure data isn't changed on the way, using hashes and message authentication. Availability in transit is about making sure the data actually gets there, despite things like DoS attacks or a jammed wireless signal.

## Data in process

Data in process is data being used: entered, changed, calculated or displayed. This is where things like bad input, software bugs and injection attacks can corrupt it. Good input validation, careful error handling and access controls protect data while it's being worked on.

## Cybersecurity countermeasures

Countermeasures are the tools and rules we use to protect data. On the technology side, the course split them into software and hardware.

Software-based technologies include software firewalls, network and port scanners like Nmap (to see what's open), protocol analyzers like Wireshark (to inspect traffic), vulnerability scanners like Nessus or OpenVAS (to find known weaknesses), and host-based IDS.

Hardware-based technologies include firewall appliances, proxy servers (which sit between users and the internet), hardware-based access control (like badge readers and dedicated security devices), and network switches, which can enforce things like port security and separate networks into VLANs.

## Policies

Technology alone isn't enough. Organizations need written policies so everyone knows the rules. The course listed six common ones:

- **Identification and authentication policies**: who can access what, and how they prove who they are
- **Password policies**: length, complexity, how often to change, and what happens after failed attempts
- **Acceptable use policies (AUP)**: what employees can and can't do with company systems and the internet
- **Remote access policies**: how people can connect from outside, for example only through the company VPN
- **Network maintenance policies**: how and when systems are updated and maintained
- **Incident handling policies**: what to do when something goes wrong, and who is responsible

## Standards, guidelines and procedures

Policies are supported by three other kinds of documents, and the difference between them is easy to mix up:

- A **policy** says what must be done and why. Example: "All laptops must be encrypted."
- A **standard** sets the specific, mandatory rule. Example: "Laptops must use BitLocker with AES-256."
- A **guideline** is a recommendation, not a requirement. Example: "Consider using a passphrase instead of a short password."
- A **procedure** gives the exact steps. Example: "Step 1: open BitLocker settings. Step 2: ..."

## Why this matters for a SOC engineer

The CIA triad and the McCumber Cube are a simple way to think about any incident: which principle was hit, what state was the data in, and which safeguard failed? Hashes are something I'll use constantly, to check files and look up malware. And incident handling policies are basically the rulebook a SOC works by.

## Wrapping up Endpoint Security

That finishes the Endpoint Security course. Looking back over the last few days, it covered threats and the people behind them, social engineering, attacks on networks and applications, how to defend networks, Windows and Linux, protecting devices, and finally the principles that tie it all together. It was a lot, and writing these posts helped me understand it much better than just watching the videos.

## Questions I should be able to answer

- What are the three dimensions of the cybersecurity cube?
- What's the difference between a hash and an HMAC?
- Name some ways to make sure systems stay available.
- DAS vs NAS vs SAN?
- What are the challenges of protecting data in transit?
- What's the difference between a policy, a standard, a guideline and a procedure?

## Next

Cisco's Network Defense course, the next step in the path.
