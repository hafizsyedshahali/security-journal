---
title: "Cyber Security 101, Part 9: Hashing and John the Ripper"
date: 2026-11-16 14:00:00 +0500
categories: [Daily Log, Cyber Security 101]
tags: [hashing, passwords, john-the-ripper, ntlm, tryhackme]
---

Encryption is reversible: with the key, you get the original back. **Hashing** is one-way on purpose, and that's exactly why it's used for passwords and for checking that files haven't changed. These two rooms covered hashing itself and then John the Ripper, the tool that recovers passwords from hashes.

## What a hash function is

A **hash function** takes any input and produces a fixed-size output called a **hash** or **digest**. Key properties:

- **one-way:** you can't reverse a hash back to the input
- **deterministic:** the same input always gives the same hash
- **fixed length:** "hi" and a 2 GB file both produce a hash of the same size
- **avalanche effect:** changing one character changes the whole hash
- **collision resistant:** it should be practically impossible to find two inputs with the same hash

Common algorithms: **MD5** (128-bit, broken, don't use for security), **SHA-1** (160-bit, also broken), and the **SHA-2** family like **SHA-256** (still strong). For passwords specifically, slow algorithms like **bcrypt** are preferred, for reasons below.

## Insecure password storage

The worst thing a system can do is store passwords as **plaintext**: one database breach and every password is exposed. The idea behind hashing passwords is:

1. When a user sets a password, store only its **hash**, never the password.
2. When they log in, hash what they typed and compare it to the stored hash.

The real password is never kept, so even a stolen database doesn't directly reveal it. But hashing alone isn't enough.

## Salting

If two users have the same password, they get the same hash, and attackers use precomputed tables (**rainbow tables**) to reverse common hashes instantly. A **salt** fixes this: a random value added to each password before hashing. Each user gets a different salt, so identical passwords produce different hashes, and rainbow tables become useless. Slow algorithms like **bcrypt** also make each guess expensive, which is why they're used for passwords.

## Recognising password hashes

Part of the job is identifying what kind of hash you're looking at, from its length and format:

- **MD5:** 32 hex characters
- **SHA-1:** 40 hex characters
- **SHA-256:** 64 hex characters
- **bcrypt:** starts with `$2a$` or `$2b$`
- hashes on Linux in `/etc/shadow` use a `$id$salt$hash` format, where `$6$` means SHA-512

Tools like **hashid** or **hash-identifier** help guess the type. Getting the type right matters, because the cracking tool needs to know which algorithm to use.

## Hashing for integrity checking

Hashing isn't only for passwords. Download pages often publish a file's hash. You hash the file you downloaded and compare:

```bash
sha256sum downloaded-file.iso
```

If your hash matches the published one, the file wasn't corrupted or tampered with. In a SOC, file hashes are a core piece of threat intelligence: you take the hash of a suspicious file and look it up (for example on VirusTotal) to see if it's known malware, without running it.

## John the Ripper

**John the Ripper** ("John") recovers passwords from hashes by guessing: it hashes candidate passwords and compares them to the target. It can't reverse a hash; it just tries fast. For a defender, John is how you test whether your users' passwords are weak, and how you understand what attackers can do with a stolen hash.

### Cracking a basic hash

```bash
john --format=raw-md5 --wordlist=/usr/share/wordlists/rockyou.txt hash.txt
```

- `--format` tells John the hash type
- `--wordlist` is the list of candidate passwords (**rockyou.txt** is the famous one)
- `hash.txt` holds the hash(es)

To see a result again later: `john --show hash.txt`.

### Windows authentication hashes (NTLM)

Windows stores password hashes as **NT hashes** (often called **NTLM**). If you obtain one, John can attempt it:

```bash
john --format=nt --wordlist=rockyou.txt nt_hashes.txt
```

This is why stolen NT hashes are dangerous, and why strong, long passwords matter so much on Windows.

### /etc/shadow hashes

On Linux, password hashes live in `/etc/shadow`. John has a helper, **unshadow**, that combines `/etc/passwd` and `/etc/shadow` into the format John expects:

```bash
unshadow /etc/passwd /etc/shadow > crack.txt
john --wordlist=rockyou.txt crack.txt
```

### Single crack mode and word mangling

**Single crack mode** uses information already in the file, like the username and the **GECOS** field (the user's full name and details), to generate guesses. People often base passwords on their own name, so this catches a surprising number.

**Word mangling** applies rules to each wordlist entry: adding numbers, swapping letters for symbols (`a` → `@`), capitalising. So "password" also becomes "Password1", "p@ssword", and so on.

### Custom rules

You can write your own mangling rules in John's config for password patterns specific to a target, for example a company that always ends passwords with the year.

### Cracking protected files

John can also attack password-protected files by first extracting a hash from them with helper tools, then cracking that hash:

```bash
zip2john secret.zip > zip.hash
john --wordlist=rockyou.txt zip.hash

rar2john secret.rar > rar.hash
john --wordlist=rockyou.txt rar.hash

ssh2john id_rsa > ssh.hash
john --wordlist=rockyou.txt ssh.hash
```

`ssh2john` is worth noting: it attacks the passphrase on a stolen SSH **private** key. It's a reminder that a private key alone isn't enough; its passphrase needs to be strong too.

## Why this matters for a SOC engineer

Understanding how passwords are cracked shapes defence: enforce long passwords, use slow salted hashing, and watch for signs of credential theft (like access to `/etc/shadow` or to the Windows SAM). File hashing is also a daily SOC task, used to identify malware by its hash.

## Questions I should be able to answer

- What are the key properties of a hash function?
- Why is storing hashed passwords better than plaintext? Why isn't hashing alone enough?
- What does a salt prevent?
- How can you tell MD5, SHA-256 and bcrypt apart?
- How is hashing used for file integrity and in threat intelligence?
- What does John's single crack mode use, and what is word mangling?
- What do zip2john, rar2john and ssh2john do?

## Next

Tonight: the start of the web security section. HTTP in depth and JavaScript essentials.
