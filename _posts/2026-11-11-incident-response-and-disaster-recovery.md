---
title: "Cyber Threat Management, Part 7: Incident Response and Disaster Recovery"
date: 2026-11-11 14:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, incident-response, nist, csirt, disaster-recovery, business-continuity, rto, rpo]
---

The final section of Cyber Threat Management, and of the whole Junior Cybersecurity Analyst path, was about what to do when things go wrong: responding to a security incident, and recovering from a disaster.

## Incident response

An **incident** is an event that threatens the confidentiality, integrity or availability of systems or data, like a malware infection, a data breach or a DDoS attack. **Incident response** is the organized way an organization detects, handles and recovers from incidents. Without a plan, people panic, evidence gets destroyed and the damage grows.

## Establishing an incident response capability

The guidance here comes mainly from NIST's incident handling guide (SP 800-61). An organization needs three things in place before anything happens:

- an **incident response policy:** management's commitment, the scope, the definition of an incident, roles and authority
- an **incident response plan:** the roadmap for how incidents are handled, including goals, how the team communicates, and how success is measured
- **incident response procedures:** the detailed, step-by-step instructions for specific situations, like handling a ransomware infection

The team that handles incidents is often called a **CSIRT** (Computer Security Incident Response Team).

## Incident response stakeholders

Incident response isn't only the security team's job. Others need to be involved:

- **management:** approves budgets and decisions, and takes overall responsibility
- **information assurance / security:** may be needed to change things like firewall rules during the response
- **IT support:** knows the systems best and does much of the technical work
- **legal department:** reviews plans and advises on legal duties, like breach notification and evidence handling
- **public affairs and media relations:** handles communication with the public and press
- **human resources:** involved when an employee is part of the incident
- **business continuity planners:** make sure the business keeps running and the response fits with continuity plans
- **physical security and facilities:** needed when the incident involves physical access to buildings or equipment

## Levels of organization

Incident response teams can be organized in different ways, depending on the organization's size:

- **central team:** one team handles incidents for the whole organization. Common in small and medium companies.
- **distributed teams:** several teams, each responsible for a location or part of the business, ideally coordinated centrally. Common in large companies spread across countries.
- **coordinating team:** a team that advises and coordinates other teams without having direct authority over them, like a national CERT.

Teams can also be staffed by employees, partly outsourced, or fully outsourced to a managed security provider.

## The NIST incident response lifecycle

NIST describes four phases. They form a cycle rather than a straight line, because lessons from one incident improve the preparation for the next.

### 1. Preparation

Getting ready before an incident happens: building the team, writing the plan, setting up tools (logging, a SIEM, forensic software), training staff, and putting preventive controls in place. Preparation also includes keeping contact lists up to date and having a "jump bag" of tools ready.

### 2. Detection and analysis

Spotting that something has happened and understanding it. Signs come from alerts (IDS, SIEM, antivirus), logs, and reports from users. Analysts confirm whether it's a real incident, work out its scope, and **prioritize** it based on its impact on the business, the type of data involved, and how easily it can be recovered. They document everything and notify the right people.

### 3. Containment, eradication and recovery

- **Containment:** stop the damage from spreading, like isolating an infected machine from the network or disabling a compromised account. Short-term containment acts fast; long-term containment keeps things stable while a full fix is prepared.
- **Eradication:** remove the cause: delete malware, close the exploited vulnerability, and remove any accounts or backdoors the attacker created.
- **Recovery:** restore systems to normal, often from clean backups, and watch them closely to make sure the attacker doesn't come back.

### 4. Post-incident activity

Learning from the incident, usually in a **lessons learned** meeting soon after. Questions include: what happened, how well did the team respond, what would we do differently, and what can stop this from happening again? The answers feed back into preparation.

> **Note:** NIST updated this guide in 2025 (SP 800-61 Rev. 3), aligning incident response with its Cybersecurity Framework 2.0. The four phases from the course are still the classic model most people learn and use.

## Incident data collection and retention

An organization has to decide how long to keep evidence and records from an incident. The course listed three main factors:

- **Prosecution:** if the attacker might be prosecuted, evidence must be kept until all legal action is finished, which can take years.
- **Data type:** some types of data must be kept for set periods by law or policy.
- **Cost:** storing large amounts of evidence, like full disk images and packet captures, costs money, which has to be weighed against its value.

Many organizations keep incident records for a set period, like a year or more, even when nobody is prosecuted.

## Reporting requirements and information sharing

After an incident, an organization may have to report it to:
- **regulators**, under laws like GDPR (within 72 hours for personal data breaches)
- **affected customers or individuals**
- **law enforcement**
- **national CERTs**, like CISA in the US
- **industry ISACs**, to warn other organizations in the same sector

Sharing what happened, especially indicators of compromise, helps others defend themselves. Legal and management should approve what's shared and with whom.

## Disaster recovery

### Types of disasters

Disasters fall into two broad groups:

**Natural disasters:**
- **geological:** earthquakes, landslides, volcanoes
- **meteorological:** floods, storms, heat waves
- **health:** pandemics and widespread illness
- **miscellaneous:** fires, lightning strikes

**Human-caused disasters:**
- **labor events:** strikes and walkouts
- **social and political events:** riots, vandalism, terrorism
- **materials:** hazardous material spills, fires caused by equipment
- **utility disruptions:** power, water or communication outages

### The disaster recovery plan

A **disaster recovery plan (DRP)** describes how to restore IT systems and data after a disaster. It answers questions like: which systems are most critical, in what order are they restored, who is responsible, where are the backups, and where do we work if the building is unusable?

### Implementing disaster recovery controls

DR controls fall into three groups:
- **preventive:** stop a disaster from happening or reduce its effect, like surge protectors, fire suppression and redundant power
- **detective:** spot a disaster or problem as it happens, like smoke detectors, temperature alarms and monitoring
- **corrective:** restore systems after a disaster, like backups, recovery sites and restore procedures

### Business continuity planning

**Business continuity** is broader than disaster recovery. DR focuses on getting IT back. Business continuity is about keeping the **whole business** running during and after a disruption, including people, processes and communication, not just technology.

Four key measurements guide the planning:

- **RTO (Recovery Time Objective):** the maximum acceptable time a system can be down. If the RTO for the online shop is 4 hours, the recovery plan must get it back within 4 hours.
- **RPO (Recovery Point Objective):** the maximum acceptable amount of data loss, measured in time. An RPO of 1 hour means backups or replication must happen at least every hour, so no more than an hour of data is ever lost.
- **MTTR (Mean Time To Repair):** the average time it takes to repair a failed component and get it working again.
- **MTBF (Mean Time Between Failures):** the average time a component runs before it fails. Higher is better.

A simple way to remember RTO and RPO: **RTO is about time** (how fast we must be back), **RPO is about data** (how much we can afford to lose).

### Business continuity considerations and best practices

The usual steps for building a continuity plan:

1. write a policy that gives the planning authority and direction
2. identify critical systems and processes, using a **business impact analysis (BIA)**
3. identify threats and vulnerabilities to them
4. decide on recovery strategies and controls
5. develop the plan
6. **test** it, with exercises and drills
7. **maintain** it, updating it as the business and its systems change

A plan that's never tested is mostly a hope.

### Critical thinking about the disaster recovery plan

The course ended with an exercise in thinking critically about a DR plan: asking hard questions instead of assuming it works. What if the backup site is hit by the same disaster? What if key staff can't be reached? Are the backups actually restorable, and how long does a full restore really take compared to the RTO? Have the people in the plan actually practiced it?

## Why this matters for a SOC engineer

The SOC lives in the detection and analysis phase, and is usually the first to raise the alarm. Good containment decisions, like isolating a host quickly, come from the SOC too. Writing clear incident notes feeds post-incident reviews and any legal action. And this is another place where automation helps: a SOAR playbook can isolate a machine or disable an account in seconds, during the moments when speed matters most.

## Questions I should be able to answer

- What's the difference between an incident response policy, plan and procedure?
- Who are the stakeholders in incident response?
- What are the four phases of the NIST incident response lifecycle?
- What's the difference between containment, eradication and recovery?
- What factors decide how long incident evidence is kept?
- What's the difference between disaster recovery and business continuity?
- Explain RTO, RPO, MTTR and MTBF with examples.
- Why must a disaster recovery plan be tested?

## Next

That completes Cyber Threat Management, and with it the full Junior Cybersecurity Analyst path. Tonight I'm writing a reflection on the whole journey so far.
