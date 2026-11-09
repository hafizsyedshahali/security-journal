---
title: "Cyber Threat Management, Part 1: Governance, Policies, Ethics and Cyber Laws"
date: 2026-11-08 14:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, governance, data-roles, security-policies, ethics, cyber-law, gdpr, compliance]
---

**Cyber Threat Management** is the last course in Cisco's Junior Cybersecurity Analyst path. The earlier courses were mostly technical. This one starts with the side of security that isn't about packets and firewalls at all: who is responsible for data, what rules an organization sets, how a security professional should behave, and what the law says.

I'll admit I expected this part to be dry. It turned out to explain a lot of the "why" behind the technical controls.

## Governance

**Governance** is how an organization directs and controls its security: who makes decisions, who is accountable, and how rules are set and checked. Good governance means security isn't left to chance or to whoever happens to care. Responsibilities are clearly assigned.

A big part of governance is assigning roles for data. The course listed six:

- **Data owner:** the person accountable for a set of data, usually a senior business manager rather than someone in IT. The owner decides how sensitive the data is, who can access it, and how it must be protected. For example, the head of HR owns employee records.
- **Data controller:** a term from privacy law like GDPR. The controller decides *why* and *how* personal data is processed. A company collecting customer data for its online shop is the controller of that data.
- **Data processor:** processes personal data *on behalf of* the controller, following the controller's instructions. A payroll company or a cloud provider handling data for a business is a processor.
- **Data custodian:** the technical role that actually looks after the data day to day: running backups, applying access controls, keeping systems patched. This is usually the IT or security team. The owner decides the rules; the custodian carries them out.
- **Data steward:** makes sure data is accurate, consistent and handled according to policy. Stewards care about data quality, definitions and correct use across the organization.
- **Data Protection Officer (DPO):** a role required by GDPR in many organizations. The DPO checks that the organization follows data protection law, advises on privacy, and is the contact point for regulators and for people whose data is held.

The owner/custodian split was the most useful idea for me: the person who decides about the data and the person who technically protects it are usually different people.

## Cybersecurity policies

A **security policy** is a written statement of the rules an organization expects everyone to follow. Policies give everyone the same expectations, give the security team authority to enforce rules, and show regulators and auditors that the organization takes security seriously.

### Types of cybersecurity policies

The course listed nine:

- **Identification and authentication policy:** who can access the network and systems, and how they prove who they are (passwords, MFA, certificates).
- **Password policy:** how long and complex passwords must be, how often they change, and what happens after failed attempts.
- **Acceptable use policy (AUP):** what employees can and can't do with company systems and internet access. For example, no personal file sharing, no visiting illegal sites. Most companies have new staff sign it.
- **Remote access policy:** how people can connect from outside the office, such as only through the company VPN and only from company devices.
- **Network maintenance policy:** how systems and network devices are updated, patched and maintained, and when maintenance can happen.
- **Incident handling policy:** what happens when a security incident occurs: who must be told, who leads the response, and what steps to follow.
- **Data policy:** how data is classified, stored, retained and destroyed, and how each class of data must be handled.
- **Credential policy:** how credentials (passwords, keys, certificates, tokens) are issued, stored, changed and revoked, including for service accounts and third parties.
- **Organizational policy:** the higher-level rules for how the organization runs, like onboarding and offboarding staff, change management, and how security responsibilities are divided.

## The ethics of cybersecurity

### Ethics of a cybersecurity specialist

Security professionals often have a lot of power: admin access, access to private data, and tools that could cause real damage. **Ethics** is about using that power responsibly, even when nobody is watching and even when something isn't strictly illegal.

A few questions that help with ethical decisions: Is it legal? Does it follow company policy? Would I be comfortable if everyone knew I did it? Does it respect other people's privacy and rights?

A practical example: while investigating an incident, an analyst might come across an employee's private messages that have nothing to do with the case. The ethical choice is to leave them alone and only look at what the investigation needs.

### The Ten Commandments of Computer Ethics

These were written by the Computer Ethics Institute in 1992 and are still quoted today:

1. Thou shalt not use a computer to harm other people.
2. Thou shalt not interfere with other people's computer work.
3. Thou shalt not snoop around in other people's computer files.
4. Thou shalt not use a computer to steal.
5. Thou shalt not use a computer to bear false witness.
6. Thou shalt not copy or use proprietary software for which you have not paid.
7. Thou shalt not use other people's computer resources without authorization or proper compensation.
8. Thou shalt not appropriate other people's intellectual output.
9. Thou shalt think about the social consequences of the program you are writing or the system you are designing.
10. Thou shalt always use a computer in ways that ensure consideration and respect for your fellow humans.

Number 9 stood out to me as someone who builds automations: what you build can affect people you'll never meet.

## Cyber crime and cyber law

**Cyber crime** is crime that involves computers or networks. It's usually grouped into three types:

- **computer-targeted crime:** the computer itself is the target, like hacking into a system or spreading malware
- **computer-assisted crime:** the computer is a tool for a traditional crime, like fraud, theft or harassment done online
- **computer-incidental crime:** the computer is just involved along the way, like a criminal storing records of drug sales on a laptop

**Cyber law** is the set of laws covering computers, the internet and data: what counts as a crime, how evidence is handled, and what organizations must do to protect data.

## FISMA

The **Federal Information Security Management Act (FISMA)**, passed in the US in 2002 and updated in 2014, requires US federal agencies to build and run information security programs. Agencies must keep inventories of their systems, classify them by risk, apply security controls, and monitor and report on their security. The detailed guidance comes from **NIST**, which is why NIST publications show up all over security work, even outside government.

## Industry-specific laws

Different industries have their own rules because they handle sensitive data:

- **HIPAA:** protects health information in the US healthcare sector
- **GLBA** (Gramm-Leach-Bliley Act): requires US financial institutions to protect customers' personal financial information
- **SOX** (Sarbanes-Oxley Act): requires US public companies to have accurate financial reporting and controls around it, which includes IT controls
- **PCI DSS:** not a law but an industry standard that any organization handling payment cards must follow
- **FERPA:** protects student education records in the US
- **COPPA:** protects the online privacy of children under 13 in the US

## Security breach notification laws

Many laws require organizations to **tell people when their data has been breached**, so they can protect themselves by changing passwords or watching their bank accounts. Under the EU's **GDPR**, a breach must generally be reported to the data protection authority within **72 hours** of becoming aware of it, and affected people must be told when there's a high risk to them. In the US, every state has its own breach notification law.

## Protecting privacy

Privacy laws control how personal data can be collected, used and shared. Examples include the US **Privacy Act of 1974** (federal agencies' handling of personal records), the **Electronic Communications Privacy Act** (interception of communications), and the EU's **GDPR**, which gives people rights like seeing the data held about them and asking for it to be deleted. Since I'm aiming for a job in Germany, GDPR is the one I need to know best.

## International laws

The internet crosses borders, so cyber crime often does too. An attacker in one country can hit a victim in another, which makes investigation and prosecution hard. International agreements try to help:

- The **Council of Europe Convention on Cybercrime** (the **Budapest Convention**, 2001) is the main international treaty. It defines cyber crimes and sets up cooperation between countries for investigations.
- **GDPR** applies to any organization worldwide that handles data of people in the EU.
- Countries also have their own laws. In Pakistan, for example, it's the **Prevention of Electronic Crimes Act (PECA) 2016**.

## Cybersecurity laws in short

Putting it together: laws tell organizations what they *must* protect (personal, health and financial data), what they must do when things go wrong (breach notification), and what counts as a crime. Policies turn those laws into internal rules, and governance makes sure someone is responsible for following them. Security controls are then how the rules are actually enforced.

## Why this matters for a SOC engineer

A SOC doesn't only fight attackers. When an incident involves personal data, the clock may start on breach notification deadlines, and the SOC's findings feed straight into that. Knowing who the data owner is tells you who to inform. Policies like the AUP define what counts as a violation in the first place. And ethics matter every day, because analysts see a lot of sensitive information while investigating.

## Questions I should be able to answer

- What's the difference between a data owner, a data custodian and a data steward?
- What's the difference between a data controller and a data processor?
- Name the nine types of cybersecurity policies.
- What are the three types of cyber crime?
- What is FISMA, and who does it apply to?
- What does GDPR require after a data breach?
- What is the Budapest Convention?

## Next

Security management frameworks: ISO 27000, NICE, the CIS Critical Security Controls and the Cloud Controls Matrix.
