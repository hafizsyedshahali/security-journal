---
title: "Cyber Threat Management, Part 5: Secure Device Management, Risk and Security Controls"
date: 2026-11-10 14:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, risk-management, vulnerability-management, patch-management, security-controls, compliance]
---

This section brought together two things: managing devices securely over their whole life, and managing risk in a structured way. It ended with security controls, which is where risk management turns into actual protection.

## Secure device management

### Risk management, briefly

Every decision about devices comes back to risk. There are four ways to handle a risk:

- **Risk avoidance:** stop doing the risky thing. For example, retire an old server that can't be secured.
- **Risk reduction:** lower the risk with controls, like patching, MFA or a firewall rule. This is the most common choice.
- **Risk sharing:** move part of the risk to someone else, like buying cyber insurance or outsourcing to a managed security provider.
- **Risk retention:** accept the risk because it's small or too costly to fix, and document that decision.

### Vulnerability management and its lifecycle

**Vulnerability management** is the ongoing process of finding and fixing weaknesses. It's never "done," because new vulnerabilities appear every day. The lifecycle has six steps:

1. **Discover:** inventory all assets on the network and find their vulnerabilities, using scanning tools.
2. **Prioritize assets:** decide which assets matter most, based on how critical they are to the business.
3. **Assess:** determine the risk of each vulnerability, using things like CVSS scores and how exposed the asset is.
4. **Report:** document the findings and their risk levels, so the right people know what needs fixing.
5. **Remediate:** fix the vulnerabilities, starting with the most serious, by patching, changing configurations or adding controls.
6. **Verify:** re-scan to confirm the fixes worked and nothing new was introduced.

Then it starts again.

### Asset management

**Asset management** means keeping an accurate, up-to-date record of every hardware and software asset: what it is, where it is, who owns it, and what's installed on it. It's the foundation for everything else. You can't patch, monitor or protect a device you don't know exists. Tools can discover devices on the network automatically, which also helps catch unauthorized ones.

### Mobile device management (MDM)

**MDM** lets an organization manage phones and tablets centrally: enforcing screen locks and encryption, controlling which apps can be installed, separating work data from personal data, and remotely wiping a lost device. With so much work done on phones now, they need the same management as laptops.

### Configuration management

**Configuration management** keeps devices in a known, secure state. Each type of device gets an approved **baseline configuration**, and any change goes through **change control**: it's requested, approved, tested and documented. When a device drifts away from its baseline, that's either a mistake to fix or a sign something is wrong.

### Enterprise patch management

**Patch management** means installing updates that fix bugs and vulnerabilities, across every system in the organization. In a company with thousands of devices, this needs a process: track which patches are released, test them so they don't break anything important, roll them out in stages, and confirm they were installed everywhere. Most attacks use vulnerabilities that already have a patch, which makes this one of the most effective defenses there is.

### Patch management techniques

The course described three ways to track and manage patches:

- **Agent-based:** a small program (agent) is installed on each device. It reports the device's patch status and can install updates. It's very accurate and works even when devices are off the company network, but every device needs the agent installed and maintained.
- **Agentless scanning:** a central server scans devices over the network to check which patches are missing, usually by logging in with credentials. No software is needed on the devices, but devices that aren't connected during the scan get missed.
- **Passive network monitoring:** watches network traffic to identify devices and the software versions they're running, without scanning or installing anything. It's useful for devices you can't touch, like medical or industrial equipment, but it's the least detailed.

## Risk management and security controls

### Risk types

Organizations face several kinds of risk, and security affects all of them:

- **strategic risk:** threats to the organization's long-term goals
- **operational risk:** failures in day-to-day processes and systems, including cyber attacks and outages
- **financial risk:** direct money losses, like theft, fines or recovery costs
- **compliance risk:** failing to follow laws and regulations
- **reputational risk:** loss of trust from customers and partners

### The risk management process

Risk management is a continuous cycle with four stages, based on NIST's approach:

1. **Frame the risk:** set the context: what the organization's goals are, what risks it's willing to accept, and what constraints exist.
2. **Assess the risk:** identify threats and vulnerabilities, and work out how likely and how damaging each risk is.
3. **Respond to the risk:** decide what to do about each risk: accept, reduce, avoid or transfer it.
4. **Monitor the risk:** keep checking whether the responses are working and whether new risks have appeared.

### Risk assessment

#### Threat source types

Threats come from different kinds of sources:
- **adversarial:** people or groups who mean harm, like criminals, hacktivists, insiders or nation-states
- **accidental:** mistakes by people, like deleting the wrong file or misconfiguring a firewall
- **structural:** failures of equipment, software or the environment it runs in, like a disk crash or a cooling failure
- **environmental:** natural or human-caused disasters outside the organization's control, like floods, fires or power outages

#### Risk assessment methodology

There are two main approaches:
- **Qualitative:** rates risks with categories like low, medium and high, often in a matrix of likelihood against impact. It's quick and easy to understand, but subjective.
- **Quantitative:** puts actual numbers on risk, usually money. It's more precise but needs good data.

#### Risk analysis

Quantitative risk analysis uses a few simple formulas:

- **Asset Value (AV):** what the asset is worth
- **Exposure Factor (EF):** the percentage of the asset lost if the threat happens
- **Single Loss Expectancy (SLE)** = AV × EF: the loss from one occurrence
- **Annualized Rate of Occurrence (ARO):** how many times a year it's expected to happen
- **Annualized Loss Expectancy (ALE)** = SLE × ARO: the expected loss per year

**Example:** a customer database is worth $200,000. A breach would damage 50% of its value, so SLE = $200,000 × 0.5 = $100,000. If a breach is expected once every five years (ARO = 0.2), then ALE = $100,000 × 0.2 = **$20,000 a year**. A control that costs $5,000 a year and greatly reduces that risk is clearly worth it. One that costs $50,000 a year probably isn't.

#### Risk mitigation

After analysis, each risk gets one of four responses:
- **Accept:** live with it, if it's small or the fix costs more than the risk
- **Reduce:** add controls to lower the likelihood or impact
- **Avoid:** stop the activity causing the risk
- **Transfer:** share it with someone else, like an insurer

## Security controls

### Control types

Controls are grouped by **how** they're implemented:

- **Administrative controls:** policies, procedures, training, background checks and risk assessments. They guide how people behave.
- **Technical controls** (also called logical controls): technology that enforces security, like firewalls, encryption, MFA, antivirus and IDS.
- **Physical controls:** things that protect the physical world, like locks, fences, guards, cameras and badge readers.

### Functional security controls

Controls are also grouped by **what they do**:

- **Preventive:** stop an incident before it happens. Example: a firewall rule, MFA.
- **Detective:** spot an incident while or after it happens. Example: IDS, log monitoring, security cameras.
- **Corrective:** fix things after an incident. Example: restoring from backup, patching the exploited flaw.
- **Deterrent:** discourage attackers from trying. Example: warning banners, visible cameras.
- **Compensating:** an alternative control when the ideal one isn't possible. Example: extra monitoring on an old system that can't be patched.
- **Recovery:** get operations back to normal after an incident. Example: disaster recovery sites.
- **Directive:** tell people what to do. Example: policies and signs.

One control can fit more than one type. A security camera is physical and detective, and if it's visible, also deterrent.

### Controls and compliance

Laws and standards like PCI DSS, HIPAA, GDPR and ISO 27001 require certain controls. **Compliance** means proving those controls are in place and working, usually through audits. Being compliant doesn't automatically mean being secure, though. Compliance is a minimum, and attackers don't care whether you passed your audit.

## Why this matters for a SOC engineer

Detective controls are the SOC's whole job, and SOC findings often lead to corrective ones. Knowing the vulnerability management lifecycle helps the SOC work with the teams fixing things. Asset inventories tell analysts what's normal on the network. And when a SOC asks for budget for a new tool, risk analysis with ALE is how you make the case in a language management understands.

## Questions I should be able to answer

- What are the six steps of the vulnerability management lifecycle?
- Why is asset management the foundation of security?
- Agent-based vs agentless vs passive patch management: pros and cons?
- What are the four stages of the risk management process?
- What are the four types of threat sources?
- Qualitative vs quantitative risk assessment?
- Calculate ALE if AV = $100,000, EF = 40% and ARO = 0.5.
- Administrative, technical and physical controls: one example of each.
- Preventive vs detective vs corrective controls?

## Next

Digital forensics, the Cyber Kill Chain and the Diamond Model of intrusion analysis.
