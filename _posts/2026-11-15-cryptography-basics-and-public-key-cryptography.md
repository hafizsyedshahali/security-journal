---
title: "Cyber Security 101, Part 8: Cryptography Basics and Public Key Cryptography"
date: 2026-11-15 21:00:00 +0500
categories: [Daily Log, Cyber Security 101]
tags: [cryptography, aes, rsa, diffie-hellman, pgp, tryhackme]
---

The Cisco Network Defense course gave me the theory of cryptography. These two TryHackMe rooms filled in the practical side: how the ciphers actually work, a bit of the maths behind them, and where public key cryptography shows up in everyday tools like SSH and email.

## Why cryptography matters: PCI DSS as an example

The room opened with a real requirement. **PCI DSS (Payment Card Industry Data Security Standard)** applies to any organisation that stores, processes or sends card data. Among other things, it requires card data to be **encrypted when stored** and **when sent over public networks**. So cryptography isn't optional: companies are required to use it, and audited on it.

## The basic vocabulary

- **Plaintext:** the original readable data.
- **Ciphertext:** the scrambled result after encryption.
- **Cipher:** the algorithm that does the encrypting and decrypting.
- **Key:** the secret value the cipher uses. The cipher can be public; the key must not be.
- **Encryption:** plaintext + key → ciphertext.
- **Decryption:** ciphertext + key → plaintext.

The flow is: plaintext → encryption (with a key) → ciphertext → sent or stored → decryption (with the right key) → plaintext again.

## Historical ciphers

- **Caesar cipher:** shift each letter by a fixed number. With a shift of 3, "HELLO" becomes "KHOOR". There are only 25 possible keys, so it can be broken by trying them all.
- **Vigenère cipher:** uses a keyword so that each letter is shifted by a different amount. Harder, but breakable with statistics.
- **Enigma:** the electro-mechanical machine used in the Second World War. Breaking it was a turning point in computing history.

They're all broken today, but they show the core idea that modern ciphers still follow: the security should depend on the key, not on keeping the method secret.

## Types of encryption

### Symmetric encryption

One **shared key** encrypts and decrypts.

- **DES:** an old standard with a **56-bit key**. Short enough to be broken by brute force in less than a day, so it's no longer secure. **3DES** applied it three times and has also been retired.
- **AES:** the current standard, with **128, 192 or 256-bit** keys. Fast and secure, used everywhere from Wi-Fi to disk encryption.

The weakness of symmetric encryption is **key distribution**: how do you get the shared key to the other person safely?

### Asymmetric encryption

A **key pair**: a **public key** you can share with anyone, and a **private key** you keep secret. What one key encrypts, only the other can decrypt. It's much slower than symmetric encryption, so in practice it's used to set up a session and exchange a symmetric key, which then does the bulk of the work.

## A little maths: XOR and modulo

Two operations come up again and again:

- **XOR (⊕):** compares two bits and outputs 1 if they're different, 0 if they're the same. Its useful property: `(A ⊕ K) ⊕ K = A`. XOR something with a key, XOR it again with the same key, and you get the original back. Many ciphers use XOR inside them.
- **Modulo (%):** the remainder after division. `25 % 5 = 0`, `23 % 6 = 5`. RSA relies on modular arithmetic with very large numbers.

## Public key cryptography

The room used a simple picture: a padlock. Anyone can have an open padlock (the **public key**) and lock a box with it. Only the person with the key to that padlock (the **private key**) can open it. That solves the key distribution problem: you can share the padlock with the whole world.

### RSA

**RSA** is built on a problem that's easy one way and very hard the other way: multiplying two large prime numbers is easy, but factoring the result back into those primes is practically impossible when the numbers are big enough.

The variables you meet in RSA, and in RSA challenges in CTFs:

- **p** and **q**: two large secret primes
- **n = p × q**: the modulus, part of the public key
- **e**: the public exponent (often 65537)
- **d**: the private exponent, calculated from p, q and e

The public key is (n, e) and the private key is (n, d). CTF challenges usually give you some of these values with a weakness, like small primes that can be factored, and ask you to recover the private key. Real RSA keys are 2048 bits or more.

### Diffie-Hellman key exchange

**Diffie-Hellman** lets two parties agree on a shared secret over a public channel without ever sending the secret itself. Each side picks a private number, sends a public value calculated from it, and combines the other side's public value with its own private number. Both end up with the same result, while someone watching only sees the public values. It's used inside TLS to create session keys.

### SSH keys

SSH uses public key cryptography for logins:

```bash
ssh-keygen -t ed25519
```

This creates a private key (for example `~/.ssh/id_ed25519`) and a public key (`id_ed25519.pub`). The public key goes in the server's `~/.ssh/authorized_keys` file. When you connect, the server checks that you hold the matching private key, without the private key ever leaving your machine. The private key must stay protected: anyone who copies it can log in as you, which is why it can also be protected with a passphrase.

### Digital signatures and certificates

A **digital signature** is created with the sender's **private key** and verified with their **public key**. It proves who sent something (authenticity) and that it wasn't changed (integrity).

A **certificate** binds a public key to an identity, like a domain name, and is signed by a trusted **Certificate Authority**. That's what makes HTTPS work, as covered in the secure protocols post.

### PGP and GPG

**PGP (Pretty Good Privacy)** encrypts and signs files and emails. **GPG (GNU Privacy Guard)** is the free, open-source implementation of the same standard (OpenPGP). You can use it to encrypt a file for someone with their public key, or sign a file so others can verify it came from you. Many software projects sign their releases with GPG so users can check the download wasn't tampered with.

## Why this matters for a SOC engineer

Cryptography is everywhere an analyst looks: expired or self-signed certificates on suspicious sites, SSH keys added to `authorized_keys` as a way to keep access, and ransomware that uses exactly these algorithms against its victims. Understanding the basics makes it much easier to tell what's normal from what's wrong.

## Questions I should be able to answer

- What does PCI DSS require regarding encryption?
- Define plaintext, ciphertext, cipher and key.
- Why is DES insecure, and what replaced it?
- What problem does asymmetric encryption solve, and why isn't it used for everything?
- What is special about XOR?
- What are p, q, n, e and d in RSA?
- How does Diffie-Hellman let two parties share a secret?
- How do SSH keys work, and which file holds authorised public keys?
- Which key creates a digital signature, and which one verifies it?

## Next

Tomorrow: hashing, password storage, and John the Ripper.
