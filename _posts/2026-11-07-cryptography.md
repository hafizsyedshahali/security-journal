---
title: "Network Defense, Part 5: Cryptography, Hashing and Hiding Data"
date: 2026-11-07 14:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, cryptography, encryption, aes, rsa, diffie-hellman, hashing, hmac, salting, steganography]
---

Cryptography got its own post because there was a lot of it, and it's the foundation of almost every other security control. I'd heard most of these terms before, but this was the first time I understood how they actually fit together.

## Why cryptography matters

Cryptography protects three of the things I keep coming back to: **confidentiality** (only the right people can read data), **integrity** (data hasn't been changed) and **authentication** (proving who sent something). Different tools do different jobs: encryption gives confidentiality, hashing gives integrity, and digital signatures and HMACs give authentication.

## Data confidentiality and encryption

**Encryption** turns readable data (**plaintext**) into unreadable data (**ciphertext**) using an algorithm and a **key**. Only someone with the right key can turn it back. The algorithm itself is usually public. The security depends entirely on keeping the key secret.

## Symmetric encryption

**Symmetric encryption** uses **the same key** to encrypt and decrypt. It's fast, so it's used for large amounts of data, like encrypting a whole disk or a VPN connection.

The big problem is **sharing the key**. If I want to send you an encrypted file, I somehow have to get the key to you safely. If someone intercepts the key, they can read everything.

There are two kinds of symmetric ciphers:

- **Block ciphers** encrypt data in fixed-size chunks (blocks). **AES**, which uses 128-bit blocks and keys of 128, 192 or 256 bits, is the standard today. Older ones are DES (broken) and 3DES (being retired).
- **Stream ciphers** encrypt data one bit or byte at a time, as a continuous stream. They're fast and good for real-time data like voice. **ChaCha20** is a modern example. The old RC4 is broken and no longer used.

## Asymmetric encryption

**Asymmetric encryption** (also called public key cryptography) uses a **pair of keys**: a **public key** that anyone can have, and a **private key** that only the owner keeps. What one key encrypts, only the other can decrypt. It's much slower than symmetric encryption, but it solves the key-sharing problem. Common algorithms are **RSA** and **ECC** (elliptic curve cryptography).

The course showed how the same key pair can give three different protections, depending on which key you use.

### Asymmetric encryption for confidentiality

To send Ali a secret message, I encrypt it with **Ali's public key**. Only Ali's **private key** can decrypt it, so only Ali can read it. Anyone can encrypt a message for him, but only he can open it.

### Asymmetric encryption for authentication

To prove a message came from me, I encrypt it (or a fingerprint of it) with **my private key**. Anyone can decrypt it with my public key, so it's not secret. But since only I have my private key, a successful decryption proves it came from me. This is the idea behind **digital signatures**.

### Asymmetric encryption for integrity

A digital signature also proves the message wasn't changed. I hash the message and encrypt the hash with my private key. The receiver decrypts my signature to get my hash, hashes the message themselves, and compares the two. If they match, the message is exactly what I sent. If even one character changed, the hashes won't match.

In practice, systems combine both types: asymmetric encryption is used to safely exchange a symmetric key, and then the fast symmetric key encrypts the actual data. HTTPS works this way.

## Diffie-Hellman

**Diffie-Hellman (DH)** solves the key-sharing problem in a clever way. Two parties can agree on a shared secret key over a public, untrusted network, **without ever sending the key itself**.

The usual explanation is mixing paint. Both sides start with the same public color. Each adds their own secret color and sends the mix to the other. Each then adds their secret color to what they received. Both end up with the same final color, but someone watching only saw the mixes, and can't separate them back into the secret colors.

DH is used in VPNs (IPsec), TLS and SSH to create session keys. On its own it doesn't prove *who* you're talking to, so it's combined with authentication to stop man-in-the-middle attacks.

## The 7-Zip example

The course used **7-Zip** to show encryption in a familiar tool. When you create a password-protected 7z archive, 7-Zip encrypts the files with **AES-256**, a symmetric cipher. The password is turned into the key. It also has an option to encrypt the file names, so someone can't even see what's inside the archive without the password. The weak point is the password: a short one can be guessed, no matter how strong AES is.

## Obscuring data

Not all data protection is encryption. Sometimes you hide or disguise data instead.

### Data masking

**Data masking** replaces sensitive data with realistic but fake data, so it can be used safely for testing, training or support. Examples:
- showing a card number as `**** **** **** 4521`
- replacing real names with random fake names in a test database
- shuffling values between records so they look real but don't belong to anyone

The format stays the same, so applications still work, but the real data isn't exposed.

### Steganography

**Steganography** hides the *existence* of a message, not just its meaning. A secret message can be hidden inside an image, audio file or video. A common method changes the least significant bits of an image's pixels: the change is too small for the eye to notice, but the bits spell out the hidden data.

Encryption makes a message unreadable but obvious. Steganography makes it invisible. They can be combined: encrypt the message, then hide it.

**Social steganography** hides meaning in plain sight using shared context: inside jokes, song lyrics, references or code words that only certain people will understand. A post can look completely normal to everyone except the intended audience. Teenagers hiding messages from parents in their social media posts is the example often given.

**Detecting steganography** is called **steganalysis**. It includes comparing a suspicious file with the original, looking for unusual file sizes or statistical patterns in pixel data, and using tools built to spot common hiding methods. Attackers have used it to hide malware commands and stolen data inside images.

## Securing communications with hashing

### Cryptographic hash functions

A **hash function** takes any amount of data and produces a fixed-length value called a **hash** or **digest**. Good cryptographic hash functions have these properties:

- **one-way:** you can't work backwards from the hash to the original data
- **fixed length:** the output is always the same size, whether the input is one word or a whole movie
- **avalanche effect:** changing one character changes the whole hash completely
- **collision resistant:** it should be practically impossible to find two different inputs with the same hash

A quick example:

```bash
echo -n "hello" | sha256sum
echo -n "Hello" | sha256sum
```

Changing just one letter from lowercase to uppercase gives two completely different hashes.

### MD5 and SHA

- **MD5** gives a 128-bit hash. It's fast but **broken**: researchers can create collisions, so it shouldn't be used for security anymore. It still shows up for simple file checks.
- **SHA-1** gives a 160-bit hash. Also considered weak now, after practical collisions were shown.
- **SHA-2** (including SHA-256 and SHA-512) is the current standard.
- **SHA-3** is a newer family built differently, as a backup if SHA-2 is ever weakened.

### Origin authentication with HMAC

A plain hash proves data wasn't changed, but not *who* sent it. An attacker could change a file and simply calculate a new hash.

**HMAC** (hash-based message authentication code) fixes this by mixing a **secret key** into the hash. Only someone who has the key can produce the correct HMAC. So when the receiver checks it with the same key, a match proves two things: the message wasn't changed, and it came from someone who has the key. This is called **origin authentication**.

```bash
openssl dgst -sha256 -hmac "sharedsecret" report.pdf
```

HMAC is used in VPNs, API authentication and signed web tokens.

## Hashing passwords

Systems should never store real passwords. They store a **hash** of each password. When you log in, the system hashes what you typed and compares it with the stored hash. If a database is stolen, the attacker gets hashes, not passwords.

### Cracking hashes

Since hashes can't be reversed, attackers **guess** instead: they hash millions of possible passwords and see which ones match. Common methods:

- **dictionary attack:** trying common words and leaked passwords
- **brute force:** trying every combination
- **rainbow tables:** huge pre-computed tables of passwords and their hashes, so cracking becomes a quick lookup

Tools like **Hashcat** and **John the Ripper** do this very fast, especially with GPUs. Weak passwords fall in seconds.

### Hashing terminology

- **hash / digest:** the output of a hash function
- **collision:** two different inputs giving the same hash
- **salt:** random data added to a password before hashing
- **rainbow table:** a pre-computed list of passwords and their hashes
- **key stretching:** deliberately making hashing slow, so guessing takes much longer

### Salting

A **salt** is a random value, different for every user, that's added to the password before it's hashed. The salt is stored next to the hash. It isn't secret.

Salting fixes two problems:
1. **Rainbow tables stop working**, because they'd have to be rebuilt for every possible salt.
2. **Identical passwords get different hashes.** Without salt, two users with the password "Summer2026" would have the same hash, and cracking one cracks both. With different salts, their hashes look completely different.

### Implementing salting

In practice, you don't build salting yourself. You use password hashing algorithms designed for it, which add a salt automatically and are deliberately slow: **bcrypt**, **scrypt**, **Argon2** or **PBKDF2**. Here's a small Python example with bcrypt:

```python
import bcrypt

password = b"Summer2026!"
hashed = bcrypt.hashpw(password, bcrypt.gensalt())
print(hashed)

print(bcrypt.checkpw(b"Summer2026!", hashed))   # True
print(bcrypt.checkpw(b"wrongpass", hashed))     # False
```

`gensalt()` creates a new random salt, and the salt is stored inside the output, so `checkpw` can use it when verifying. Running the first part twice gives two different hashes for the same password, which is exactly what salting is supposed to do.

The wrong way would be storing plain SHA-256 of passwords with no salt: fast to compute means fast to crack.

## Why this matters for a SOC engineer

File hashes are one of the most common things a SOC works with: checking a suspicious file's hash against VirusTotal or threat intel feeds is a daily task. Encrypted traffic is everywhere, which is why so much detection now relies on metadata (who talked to whom, when, how much) instead of content. And knowing how password hashes are stored and cracked helps judge how bad a breach really is.

## Questions I should be able to answer

- Symmetric vs asymmetric encryption: pros, cons and examples?
- Block cipher vs stream cipher?
- Which key do you use for confidentiality, and which for a digital signature?
- How does Diffie-Hellman create a shared key without sending it?
- What's the difference between encryption, data masking and steganography?
- Why is MD5 no longer safe?
- What does HMAC add to a normal hash?
- What is a salt, and what two problems does it solve?

## Next

Tonight: the last part of the course, covering monitoring common protocols, types of network security data, logs, Security Onion, Snort rules and evaluating alerts.
