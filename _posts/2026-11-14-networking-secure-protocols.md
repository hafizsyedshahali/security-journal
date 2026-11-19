---
title: "Cyber Security 101, Part 5: Secure Protocols (TLS, HTTPS, SSH, VPN)"
date: 2026-11-14 14:00:00 +0500
categories: [Daily Log, Cyber Security 101]
tags: [tls, https, ssh, sftp, ftps, vpn, tryhackme]
---

Yesterday's protocols (HTTP, FTP, SMTP, POP3, IMAP) all send data in cleartext. This room showed how the same jobs are done securely, and almost all of it comes down to one building block: **TLS**.

## TLS: the layer that secures the others

**TLS (Transport Layer Security)** is the protocol that adds encryption on top of an ordinary connection. It replaced the older **SSL**, which is now considered broken. TLS gives three things:

- **confidentiality:** the traffic is encrypted, so someone capturing it sees only noise
- **integrity:** any change to the data in transit is detected
- **authentication:** the server proves its identity with a **certificate**

### Certificates and trust

A server's certificate says "this public key belongs to example.com" and is signed by a **Certificate Authority (CA)**. Your browser and operating system come with a list of trusted CAs. If the signature checks out, the browser trusts the site. If the certificate is expired, self-signed or for a different name, you get a warning.

Let's Encrypt made free certificates normal, which is a big reason most of the web now uses HTTPS.

### The handshake, simply

1. The client says hello and lists the TLS versions and ciphers it supports.
2. The server picks the settings and sends its certificate.
3. The client checks the certificate against its trusted CAs.
4. Both sides agree on a shared session key (using key exchange methods covered in the cryptography post).
5. From then on, all data is encrypted with that session key.

## HTTPS

**HTTPS** is simply **HTTP over TLS**, on **TCP port 443** instead of 80. The HTTP messages are exactly the same; they're just encrypted inside the TLS connection. The padlock in the browser means the connection is encrypted and the certificate is valid. It does **not** mean the site is honest: phishing sites can and do have valid certificates.

## Securing email: SMTPS, POP3S, IMAPS

The email protocols get the same treatment:

| Cleartext | Secure | Port |
|---|---|---|
| SMTP (25) | **SMTPS** | 465 (587 is also used with STARTTLS) |
| POP3 (110) | **POP3S** | 995 |
| IMAP (143) | **IMAPS** | 993 |

**STARTTLS** is a different approach: the connection starts in cleartext on the normal port, and the client then asks to upgrade it to TLS.

## SSH

**SSH (Secure Shell)** replaced **Telnet**, which sent everything, including passwords, in cleartext. SSH runs on **TCP port 22** and provides:

- an encrypted remote command line
- authentication with passwords or, better, **key pairs**
- **port forwarding (tunnelling)**, which carries other traffic through the encrypted connection

## SFTP vs FTPS

The names look almost the same, but they're different:

| | SFTP | FTPS |
|---|---|---|
| Built on | **SSH** | **FTP + TLS** |
| Port | 22 | 990 (implicit), or 21 with an upgrade |
| Certificates | not needed, uses SSH keys | needs a TLS certificate |
| Firewall-friendly | yes, one port | harder, uses separate data connections |

Both encrypt file transfers. SFTP is usually simpler to run, because it reuses the SSH service that's often already there.

## VPN

A **VPN (Virtual Private Network)** creates an encrypted **tunnel** between two points over the internet:

- **remote access VPN:** an employee working from home connects to the company network as if they were in the office
- **site-to-site VPN:** two offices connect their networks over the internet

Common technologies include **IPsec**, **OpenVPN** and **WireGuard**. TryHackMe itself uses an OpenVPN connection to put your machine on the same network as the lab targets.

A VPN protects traffic between the two ends of the tunnel. It does not make a user anonymous, and it doesn't protect a device that's already compromised.

## Why this matters for a SOC engineer

Encryption is good for privacy but hides content from defenders too. A SOC often can't read HTTPS traffic, so it relies on what's still visible: the destination IP, the **SNI** (the server name sent during the TLS handshake), certificate details, timing and amount of data. And seeing cleartext protocols like Telnet or plain FTP on a network is itself a finding worth reporting.

## Questions I should be able to answer

- What three things does TLS provide?
- What is a Certificate Authority, and what happens when a certificate isn't trusted?
- Does the browser padlock mean a site is safe? Why not?
- What are the ports for HTTPS, SMTPS, POP3S, IMAPS and SSH?
- What is STARTTLS?
- What's the difference between SFTP and FTPS?
- What's the difference between a remote access VPN and a site-to-site VPN?

## Next

Tonight: watching traffic for real with Wireshark and tcpdump.
