---
title: "Cyber Security 101, Part 10: Web and HTTP Fundamentals"
date: 2026-11-16 21:00:00 +0500
categories: [Daily Log, Cyber Security 101]
tags: [http, web-security, javascript, security-headers, tryhackme]
---

The web section started here. To find and understand web vulnerabilities, you first have to understand how the web works underneath the browser: URLs, HTTP requests and responses, security headers, and a little JavaScript.

## Web application overview

A web application has two sides. The **front end** is what runs in your browser: HTML for structure, CSS for styling, JavaScript for behaviour. The **back end** is what runs on the server: the application code, the database, and the web server software. When you click something, the browser sends an **HTTP request** to the server, and the server sends back an **HTTP response**.

## Typosquatting and the URL

**Typosquatting** is registering domains that look almost like a real one, like `tryhackme.com` becoming `tryhackmee.com` or `tryhackme.co`, to catch people who mistype or don't look closely. It's the backbone of many phishing attacks.

That makes reading a **URL** carefully a real skill:

```
https://user:password@sub.example.com:443/path/page?search=query#section
```

- **scheme:** `https://`
- **user:password:** optional credentials (rare and often a warning sign)
- **host:** `sub.example.com`, the part that actually matters for trust
- **port:** `:443`, often hidden
- **path:** `/path/page`
- **query string:** `?search=query`, data sent to the page
- **fragment:** `#section`, a spot on the page

Attackers hide the real host with tricks, like `https://trusted.com@evil.com`, which actually goes to `evil.com`. The host is always the part right before the first `/`.

## HTTP messages

Every HTTP exchange is a **request** from the client and a **response** from the server, each with the same shape: a first line, headers, a blank line, and an optional body.

### HTTP request: line, methods, version

The request line looks like:

```
GET /index.html HTTP/1.1
```

That's a **method**, a **path**, and the **HTTP version**. The methods:

- **GET:** retrieve a resource
- **POST:** send data (like a form) to be processed
- **PUT:** create or replace a resource
- **DELETE:** remove a resource
- others include **HEAD** (headers only), **OPTIONS** and **PATCH**

### HTTP request: headers and body

**Headers** are key-value lines giving extra information:

- **Host:** which site on the server you want
- **User-Agent:** the browser and OS
- **Cookie:** data the server set earlier, often the session token
- **Authorization:** credentials or a token
- **Content-Type:** the format of the body

The **body** carries data, for example the fields of a login form in a POST request.

### HTTP response: status line and status codes

The response starts with a status line like `HTTP/1.1 200 OK`. Status codes come in families:

| Range | Meaning | Examples |
|---|---|---|
| **1xx** | informational | 100 Continue |
| **2xx** | success | 200 OK, 201 Created |
| **3xx** | redirection | 301 Moved Permanently, 302 Found |
| **4xx** | client error | 401 Unauthorized, 403 Forbidden, 404 Not Found |
| **5xx** | server error | 500 Internal Server Error, 503 Service Unavailable |

Status codes are useful in log analysis: a flood of 404s can be someone probing for hidden pages, and a sudden run of 500s can mean an attack is breaking the application.

### HTTP response: headers and body

Response headers include **Server** (the software), **Set-Cookie** (to store data in the browser), **Content-Type** and **Location** (where a redirect points). The **body** is usually the HTML, JSON or file being returned.

## Security headers

Some response headers exist purely to make the browser enforce protections. These are the ones I added to my own site earlier, so they were familiar:

- **Content-Security-Policy (CSP):** controls which sources of scripts, styles and images the browser will load, which limits cross-site scripting.
- **Strict-Transport-Security (HSTS):** forces the browser to always use HTTPS.
- **X-Content-Type-Options: nosniff:** stops the browser guessing a file's type.
- **X-Frame-Options:** stops the page being embedded in a frame, which prevents clickjacking.
- **Referrer-Policy:** controls how much of the URL is sent when following a link.

A site that's missing these isn't necessarily vulnerable, but it's a sign of how much thought went into its security. Tools like securityheaders.com grade them.

## JavaScript essentials

The JavaScript room was about how client-side code can be abused, since JavaScript runs in the user's browser where the user controls everything.

- **Integrating JS in HTML:** scripts go inside `<script>` tags or in separate `.js` files loaded with `<script src="...">`.
- **Abusing dialogue functions:** functions like `alert()`, `prompt()` and `confirm()` are often used to prove a cross-site scripting vulnerability, because getting an `alert()` box to pop means you managed to run your own script on the page.
- **Bypassing control flow:** client-side checks (like "is the password correct?") written in JavaScript can be read and skipped, because the user can edit or ignore the code. The lesson: **never trust the client**. Any real security check must happen on the server.
- **Exploring minified files:** production JavaScript is **minified** (whitespace and names stripped out) to make it smaller. Attackers "beautify" it to read it, sometimes finding hidden API endpoints, keys or logic. This is a reminder never to put secrets in front-end code.

## Why this matters for a SOC engineer

Web servers are among the most attacked systems, and their logs are a core SOC data source. Reading a request line, spotting odd methods or paths, and understanding status codes is what turns a wall of web logs into a story. The client-side lessons also explain why so many attacks work: the server trusted something it shouldn't have.

## Questions I should be able to answer

- What is typosquatting, and which part of a URL decides where you really go?
- What are the parts of an HTTP request and response?
- What do the 2xx, 3xx, 4xx and 5xx status code families mean?
- Name three security headers and what each one prevents.
- Why should security checks never be done only in client-side JavaScript?
- Why do attackers beautify minified JavaScript?

## Next

Tomorrow: SQL, and the injection attack that comes from mishandling it.
