---
title: "Cyber Security 101, Part 3: Active Directory Basics"
date: 2026-11-13 14:00:00 +0500
categories: [Daily Log, Cyber Security 101]
tags: [active-directory, windows, kerberos, group-policy, tryhackme]
---

Active Directory is in almost every company that runs Windows. It decides who can log in, to which machines, with what permissions. That also makes it the main prize for attackers once they get inside a network, so it's worth understanding properly.

## The problem Active Directory solves

Imagine a company with 500 employees and 600 computers. Without central management, every password change, new hire and security setting would have to be done on each machine by hand. A **Windows domain** fixes this: users and computers are managed from one central place.

That central place is **Active Directory (AD)**, and more specifically the **Active Directory Domain Services (AD DS)** role. The server running it is called a **Domain Controller (DC)**. When you log in at work with the same username on any office computer, the DC is checking your password.

Benefits:

- **centralised identity:** one account per person, usable on any domain machine
- **centralised policy:** security settings pushed to every machine at once

## What lives in Active Directory

AD stores **objects**. The main ones:

- **Users:** accounts for people, and also **service accounts** used by applications like a database server. Service accounts should have only the permissions their service needs.
- **Machines:** every computer that joins the domain gets its own account. Its name is the computer name followed by a `$`, for example `DC01$`.
- **Security groups:** collections of users or machines, so permissions can be given to the group instead of to each person. Important built-in groups include **Domain Admins** (full control of the domain), **Enterprise Admins**, **Server Operators**, **Backup Operators**, **Account Operators**, **Domain Users** and **Domain Computers**.

## Organizational Units vs groups

These two are easy to mix up:

| | Organizational Unit (OU) | Security group |
|---|---|---|
| Purpose | organise objects and apply **policies** | grant **permissions** to resources |
| Membership | an object can be in **one** OU | an object can be in **many** groups |
| Typical use | one OU per department: Sales, IT, Management | "Finance share access", "VPN users" |

OUs usually mirror the company structure. You manage them in **Active Directory Users and Computers**.

### Delegation

You can **delegate** control of an OU. For example, IT support can be allowed to reset passwords only for users in the Sales OU, without becoming domain admins. This follows the principle of least privilege.

## Managing users and computers

A few practical points from the room:

- When someone leaves, their account should be **disabled or deleted** quickly. Old active accounts are a common way in.
- OUs are often protected from accidental deletion, which you have to switch off before deleting them.
- By default, new computers land in a generic **Computers** container. It's better to sort them into OUs like **Workstations**, **Servers** and **Domain Controllers**, because each type needs different policies. A laptop and a database server shouldn't follow the same rules.

## Group Policy

**Group Policy Objects (GPOs)** are collections of settings applied to OUs. You manage them in **Group Policy Management**. A GPO can, for example:

- enforce a minimum password length and complexity
- lock the screen after a few minutes of inactivity
- block access to Control Panel for normal users
- deploy software or scripts

GPOs are distributed to machines through a network share called **SYSVOL** on the domain controllers. Machines refresh their policies periodically, and you can force it with:

```powershell
gpupdate /force
```

From a security view, GPOs are powerful in both directions: defenders use them to harden every machine at once, and an attacker who can edit a GPO can push malicious settings to the whole domain. Changes to GPOs should be monitored.

## Authentication methods

When a user logs in, the domain controller verifies them using one of two protocols:

### Kerberos (the default)

1. The user logs in, and the computer asks the **Key Distribution Center (KDC)** on the DC for a **Ticket Granting Ticket (TGT)**.
2. With the TGT, the user requests a **Ticket Granting Service (TGS)** ticket for a specific service, like a file share.
3. The user presents that service ticket to the service, which trusts it because the KDC issued it.

The password itself is never sent across the network. Tickets do the work.

### NetNTLM (older, still around for compatibility)

A **challenge-response** method: the server sends a random challenge, the client answers with a value calculated from the password hash, and the domain controller checks it. It still works, but it's weaker than Kerberos and is targeted by several known attacks, so many organisations try to reduce its use.

## Trees, forests and trusts

As companies grow, one domain may not be enough:

- **Tree:** several domains that share the same namespace, like `company.local` with child domains `uk.company.local` and `us.company.local`.
- **Forest:** a collection of trees with different namespaces, for example after one company buys another.
- **Trust relationship:** lets users in one domain access resources in another.
  - In a **one-way trust**, if domain A trusts domain B, users in B can be given access to resources in A, but not the other way around. The direction of access is the opposite of the direction of trust.
  - A **two-way trust** works in both directions. Domains in the same forest trust each other this way by default.

## Why this matters for a SOC engineer

AD is where many serious attacks end up: stealing credentials, adding an account to Domain Admins, abusing Kerberos tickets, or changing GPOs. A SOC watches events like:

- **4624 / 4625:** successful and failed logons
- **4720:** a user account was created
- **4728 / 4732 / 4756:** a member was added to a security group
- **4740:** an account was locked out
- **4768 / 4769:** Kerberos ticket requests

Someone being added to Domain Admins at 3 a.m. is the kind of event that should never go unnoticed.

## Questions I should be able to answer

- What is a domain, and what does a domain controller do?
- What's the difference between an OU and a security group?
- Why do machine accounts end with `$`?
- What is delegation, and how does it support least privilege?
- What is a GPO, how is it distributed, and how do you force an update?
- Explain the Kerberos process in three steps. How is NetNTLM different?
- What's the difference between a tree and a forest? Which way does access flow in a one-way trust?

## Next

Tonight: networking from the TryHackMe side, from DHCP and ARP to DNS, HTTP and the email protocols.
