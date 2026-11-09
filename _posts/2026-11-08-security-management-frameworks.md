---
title: "Cyber Threat Management, Part 2: Security Management Frameworks"
date: 2026-11-08 21:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, iso-27001, iso-27002, nice-framework, cis-controls, cloud-controls-matrix, frameworks]
---

This afternoon's post was about governance, policies and laws. This one is about **frameworks**: ready-made structures that organizations use to build and check their security, instead of inventing everything from scratch. A framework answers the question "have we covered everything we should?"

## Why frameworks exist

Without a framework, every organization would decide on its own what "secure enough" means, and important areas would be easy to forget. Frameworks give a common checklist and a common language. They also make audits possible, because an auditor can check an organization against a known standard. Many companies get certified against one so they can prove their security to customers and partners.

## ISO 27000

The **ISO/IEC 27000** family is the best-known international set of security standards. The two most important are:

- **ISO/IEC 27001:** defines how to build an **Information Security Management System (ISMS)**: the policies, processes and controls an organization uses to manage security. Organizations can be certified against 27001.
- **ISO/IEC 27002:** gives detailed guidance on the security **controls** an organization can use.

### The twelve domains of cybersecurity

The course presented ISO's approach as twelve domains, or areas, that an organization's security should cover:

1. **Risk assessment:** finding and evaluating risks
2. **Security policy:** documenting the organization's security rules
3. **Organization of information security:** who does what in security, internally and with outside parties
4. **Asset management:** keeping an inventory of assets and classifying them
5. **Human resources security:** security before, during and after someone's employment, like background checks, training and removing access when they leave
6. **Physical and environmental security:** protecting buildings, rooms and equipment
7. **Communications and operations management:** running systems and networks securely day to day, including backups, malware protection and monitoring
8. **Information systems acquisition, development and maintenance:** building security into systems from the start
9. **Access control:** controlling who can access what
10. **Information security incident management:** detecting, reporting and responding to incidents
11. **Business continuity management:** keeping the business running during and after disruptions
12. **Compliance:** following laws, regulations and contracts

> **Note:** these twelve domains come from the older 2005/2013 versions of ISO 27002. The 2022 version reorganized the controls into four themes (organizational, people, physical and technological) with 93 controls in total. The ideas are the same, just grouped differently.

### Control objectives and controls

These two terms are easy to mix up:

- A **control objective** says *what* you want to achieve. For example: "Only authorized users should access company systems."
- A **control** is *how* you achieve it. For example: user account reviews, strong passwords and MFA.

One objective usually needs several controls working together.

### Mapping to ISO 27002 controls

Organizations take their own needs and **map** them to ISO 27002 controls. For example, a company worried about stolen laptops maps that risk to controls for asset management, encryption and physical security. Mapping shows which risks are already covered and where the gaps are.

### ISO 27000 and the CIA triad

Every ISO control supports one or more parts of the **CIA triad**. Encryption controls protect **confidentiality**. Change management and hashing protect **integrity**. Backups and business continuity protect **availability**.

### ISO 27000 and the states of data

Controls also apply to each **state of data** from the cybersecurity cube: data **at rest** (storage encryption, access control), data **in transit** (network encryption, secure protocols) and data **in process** (input validation, application security).

### ISO 27000 and safeguards

And controls fall under the three **safeguards** from the cube: **technology** (firewalls, encryption), **policies and practices** (procedures, standards) and **people** (awareness and training). So ISO 27000 fits neatly onto the McCumber Cube I learned in my first course: it's a structured way of making sure every principle, state and safeguard is covered.

## The National Cybersecurity Workforce Framework (NICE)

The **NICE Framework**, from NIST in the US, is different from the others. It doesn't describe controls. It describes **cybersecurity jobs**: the work roles, tasks, knowledge and skills needed in the field.

The version the course covered groups the work into seven categories:

1. **Securely Provision:** designing and building secure systems
2. **Operate and Maintain:** running and supporting systems
3. **Oversee and Govern:** leadership, management, policy and legal
4. **Protect and Defend:** finding and handling threats, including **cyber defense analysis** and **incident response**
5. **Analyze:** reviewing and evaluating incoming security information and threats
6. **Collect and Operate:** specialized collection and operations, often in government
7. **Investigate:** investigating cyber crime and digital evidence

A SOC analyst role sits mainly under **Protect and Defend**. The framework is useful for planning a career, because it shows which skills each role needs. NIST has since updated the framework's structure, but the idea of mapping roles to tasks and skills stays the same.

## The CIS Critical Security Controls

The **Center for Internet Security (CIS)** publishes a prioritized list of the most important things an organization should do to defend itself. It's very practical: it focuses on actions that stop the most common real attacks. The current version (v8) has 18 controls:

1. Inventory and control of enterprise assets
2. Inventory and control of software assets
3. Data protection
4. Secure configuration of enterprise assets and software
5. Account management
6. Access control management
7. Continuous vulnerability management
8. Audit log management
9. Email and web browser protections
10. Malware defenses
11. Data recovery
12. Network infrastructure management
13. Network monitoring and defense
14. Security awareness and skills training
15. Service provider management
16. Application software security
17. Incident response management
18. Penetration testing

The order matters: the first controls are the foundation. You can't protect assets you don't know you have, which is why inventory comes first. CIS also splits the controls into **Implementation Groups** (IG1 to IG3), so a small company can start with the basics (IG1) and larger organizations can go further.

## The Cloud Controls Matrix

The **Cloud Controls Matrix (CCM)**, from the **Cloud Security Alliance**, is a framework built specifically for cloud computing. Its current version has **197 control objectives in 17 domains**, covering areas like identity and access, encryption and key management, logging and monitoring, and infrastructure security.

What makes it useful is that it:
- shows which controls are the provider's responsibility and which are the customer's, following the shared responsibility model
- maps each control to other frameworks like ISO 27001, NIST and PCI DSS, so one assessment can serve several standards

## Comparing them

Each framework answers a different question:

- **ISO 27001/27002:** how do we build and run a complete security management system?
- **NICE:** what jobs and skills does security need?
- **CIS Controls:** what are the most important practical defenses, and in what order?
- **Cloud Controls Matrix:** how do we secure our use of the cloud?

Organizations often use several together.

## Why this matters for a SOC engineer

SOC work is often described in framework terms. Audit log management (CIS control 8) and network monitoring (control 13) are exactly what a SOC does. Incident reports often reference which controls failed. And if I end up at a company certified to ISO 27001, which is common in Germany, the SOC will produce evidence for its audits.

## Questions I should be able to answer

- What's the difference between ISO 27001 and ISO 27002?
- Name some of the twelve domains of cybersecurity.
- What's the difference between a control objective and a control?
- How does ISO 27000 relate to the CIA triad, the states of data and safeguards?
- What does the NICE Framework describe, and where does a SOC analyst fit?
- Why does the CIS list start with asset inventory?
- What is the Cloud Controls Matrix used for?

## Next

Network security testing (scanners, penetration testing and tools like Nmap) and where threat intelligence comes from.
