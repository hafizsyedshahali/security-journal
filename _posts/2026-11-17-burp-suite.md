---
title: "Cyber Security 101, Part 12: Burp Suite"
date: 2026-11-17 21:00:00 +0500
categories: [Daily Log, Cyber Security 101]
tags: [burp-suite, web-security, proxy, tryhackme]
---

**Burp Suite** is the tool that sits between your browser and a web server and lets you see and change every request. It's central to web security testing. These rooms covered the free Community Edition: setting it up, routing traffic through it, and using the proxy.

## What Burp Suite is

Burp Suite is a platform for testing web applications. The key idea is that it works as an **intercepting proxy**: your browser sends requests to Burp, Burp passes them on to the server, and the response comes back the same way. Because everything flows through Burp, you can pause a request, read it, change it, and send it on.

## Community vs Professional

- **Community Edition:** free. Includes the Proxy, Repeater, Decoder, Comparer, and a rate-limited Intruder.
- **Professional:** paid. Adds the automated **Scanner**, a full-speed Intruder, and more.

Community is enough to learn the fundamentals and do manual testing.

## Installation and the dashboard

Burp is pre-installed on Kali and AttackBox. On first launch you choose a **temporary project** (Community can't save projects) and default settings. The **Dashboard** tab shows tasks and an event log of what Burp is doing.

## Navigating Burp

The main tabs:

- **Proxy:** intercept and view traffic between browser and server
- **Target:** the **site map**, a tree of everything you've visited, plus **scope** settings
- **Repeater:** send a single request over and over, editing it each time
- **Intruder:** send many automated variations of a request (rate-limited in Community)
- **Decoder:** encode and decode data (URL, Base64, hex)
- **Comparer:** compare two pieces of data to spot differences

## The proxy and connecting the browser

For Burp to see traffic, the browser must send it to Burp instead of straight to the internet. Burp provides its own **pre-configured browser** (the easiest option), or you can point an external browser at Burp's proxy, usually `127.0.0.1:8080`.

### Proxying HTTPS

HTTPS is encrypted, so to read it Burp has to sit in the middle with its own certificate. You install **Burp's CA certificate** in the browser so it trusts Burp's certificates. After that, Burp can show HTTPS traffic in cleartext. This is a controlled, consented version of a man-in-the-middle, done on traffic you're allowed to test. The browser warnings you'd normally see are exactly the protection that stops a real attacker doing this to you.

### Intercept on and off

In the **Proxy** tab, **Intercept** can be on or off:

- **on:** each request pauses so you can read, edit, forward or drop it
- **off:** traffic flows normally, but is still recorded in the HTTP history

**HTTP history** is often more useful than live intercept: you browse the site normally, then go back and study every request that was made.

## Scoping and targeting

**Scope** tells Burp which sites you're allowed to test. You add the target to scope and tell Burp to log only in-scope traffic. This keeps the site map clean and, more importantly, makes sure you never send test traffic to a site you don't have permission for. Staying in scope is an ethical and legal requirement, not just a convenience.

## An example attack flow

A simple walkthrough the rooms used:

1. Turn Intercept on and submit a form in the browser.
2. The request pauses in Burp. You can see every field.
3. Send it to **Repeater**.
4. In Repeater, change a value, for example an `id` or a price, and send it.
5. Read the response to see how the server reacts.

This is how you find flaws like being able to view another user's data by changing an ID, or change a value the server should have checked but didn't. It all comes back to the JavaScript lesson from yesterday: the server must validate everything, because the client, and anyone using Burp, can send whatever they want.

## Why this matters for a SOC engineer

Burp is a tester's tool, but understanding it helps a defender in two ways. First, it shows how web requests are manipulated, which is what many web attacks really are underneath. Second, the traffic that tools like this generate, lots of near-identical requests to one endpoint with small changes, is a pattern worth recognising in web logs and WAF alerts.

## Questions I should be able to answer

- What does it mean that Burp is an intercepting proxy?
- What's the difference between Community and Professional editions?
- Why does Burp need its own CA certificate to read HTTPS?
- What's the difference between Intercept and HTTP history?
- What is scope, and why does it matter legally and ethically?
- What is Repeater used for?

## Next

Tomorrow: the OWASP Top 10, the industry's list of the most common web risks.
