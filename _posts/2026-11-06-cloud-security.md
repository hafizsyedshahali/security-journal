---
title: "Network Defense, Part 4: Cloud Security"
date: 2026-11-06 21:00:00 +0500
categories: [Daily Log]
tags: [cybersecurity, cloud-security, virtualization, csa, shared-responsibility, vm-sprawl]
---

This section built on my AWS Cloud Practitioner notes, but looked at the cloud purely from the security side: what can go wrong, who is responsible for what, and how to protect data and applications that live on someone else's servers.

## Virtualization and cloud computing

**Virtualization** lets one physical computer run several separate virtual computers, called **virtual machines (VMs)**. Each VM has its own operating system and apps, and thinks it has the machine to itself.

The software that makes this possible is the **hypervisor**. There are two types:
- **Type 1 (bare metal):** runs directly on the hardware, with no operating system underneath. Used in data centers and by cloud providers. Examples: VMware ESXi, Microsoft Hyper-V, KVM.
- **Type 2 (hosted):** runs as an app on top of a normal operating system. Used on laptops and for labs. Examples: VirtualBox, VMware Workstation, and UTM. This is the kind of setup I use for the Ubuntu VM on my Mac.

**Cloud computing** is built on virtualization. Instead of buying servers, you rent computing power, storage and services over the internet and pay for what you use.

## The virtual environment

A virtual environment includes VMs, virtual networks and virtual switches that connect them, shared storage, and often **containers**. Containers are lighter than VMs: they share the host's operating system kernel and just package an app with what it needs. Docker is the well-known example.

## Cloud-based technology

The main **service models**:
- **IaaS (Infrastructure as a Service):** you rent virtual servers, storage and networks, and manage the operating system and everything above it. Example: AWS EC2.
- **PaaS (Platform as a Service):** the provider manages the servers and OS. You just deploy your code. Example: Google App Engine.
- **SaaS (Software as a Service):** you just use the finished application. Example: Gmail or Microsoft 365.

The main **deployment models**:
- **Public cloud:** shared infrastructure run by a provider, used by many customers
- **Private cloud:** used by one organization only
- **Hybrid cloud:** a mix of the two, connected together
- **Community cloud:** shared by several organizations with similar needs, like government agencies

## Top threats to cloud computing

The course listed the biggest cloud threats:

- **Data breaches:** sensitive data stolen from cloud storage or databases
- **Cloud misconfiguration:** the number one cause of cloud incidents. A storage bucket left public, a database open to the internet, or a security group allowing everything.
- **Poor cloud security architecture and strategy:** moving to the cloud quickly without planning how to secure it
- **Compromised account credentials:** stolen passwords or access keys give attackers direct access. Access keys accidentally pushed to GitHub are a classic example.
- **Insider threat:** employees or contractors misusing their cloud access
- **Insecure software interfaces and APIs:** everything in the cloud is managed through APIs, so weak APIs expose everything behind them
- **Limited cloud usage visibility:** the company doesn't know which cloud services employees are using. Unapproved services are called **shadow IT**.

## The 14 domains of cloud security

My notes say to mention all 14. They come from the **Cloud Security Alliance (CSA) Security Guidance (version 4)**, which divides cloud security into 14 areas:

1. **Cloud computing concepts and architectures:** the basic definitions and models
2. **Governance and enterprise risk management:** how the organization manages cloud risk overall
3. **Legal issues, contracts and electronic discovery:** contracts with providers, data laws, and finding data for legal cases
4. **Compliance and audit management:** meeting regulations and proving it to auditors
5. **Information governance:** who owns data, how it's classified and handled
6. **Management plane and business continuity:** securing the cloud management console and keeping services running through failures
7. **Infrastructure security:** securing cloud networks and compute
8. **Virtualization and containers:** securing VMs, hypervisors and containers
9. **Incident response:** how to detect and respond to incidents in the cloud
10. **Application security:** building and running secure applications in the cloud
11. **Data security and encryption:** protecting data and managing encryption keys
12. **Identity, entitlement and access management:** who can access what
13. **Security as a Service:** security tools delivered from the cloud, like cloud firewalls or cloud email filtering
14. **Related technologies:** newer areas like big data, IoT and mobile

(CSA published a newer version in 2024 with 12 domains, but the course uses the 14-domain version.)

## Cloud infrastructure security

### Who is responsible for what

The **shared responsibility model** decides who secures what, and the split changes with the service model:

- With **IaaS**, the provider secures the physical data center, hardware and hypervisor. The customer secures the operating system, patches, applications, network settings and data.
- With **PaaS**, the provider also takes care of the operating system and runtime. The customer secures their code, data and access.
- With **SaaS**, the provider runs almost everything. The customer is still responsible for their data, user accounts and access settings.

In every model, the customer is always responsible for their **data** and **who has access** to it. That's why misconfigured access is the most common cause of cloud breaches.

### Other infrastructure considerations

Other things to get right: separate networks with private subnets and security groups, encrypt data, use MFA on every account (especially the root/admin account), give least-privilege permissions, turn on logging (like AWS CloudTrail) and monitor it, and regularly scan for misconfigurations.

## Cloud application security

The same principles as normal application security apply: secure development from the start, secure coding techniques, **input validation** so bad data is rejected, and **integrity checks** (like hashes and version control) to make sure code and data haven't been changed. In the cloud, apps also need to protect their API keys and secrets, ideally in a secrets manager rather than in the code.

## Cloud data security

Data in the cloud has to be protected in all three states, the same states from the cybersecurity cube:
- **at rest:** stored in cloud storage or databases, protected with encryption and access control
- **in transit:** moving between users and the cloud, or between services, protected with TLS
- **in use:** being processed, protected with access control and, increasingly, special hardware that keeps data encrypted even in memory

**Cryptography** is the main tool here. Encryption keys must be managed carefully: whoever controls the keys controls the data. **Hashing** is used to check that data hasn't been changed and to store passwords safely.

## Protecting VMs from VM sprawl

**VM sprawl** happens when VMs are created so easily that nobody keeps track of them. Old test machines get forgotten, never patched, and stay running with old passwords. Each forgotten VM is an easy way in for an attacker. There's also the risk of **VM escape**, where an attacker breaks out of one VM to reach the hypervisor or other VMs on the same host.

Defenses:
- keep an up-to-date inventory of every VM and who owns it
- have a lifecycle policy: approve creation, review regularly, delete what's not needed
- patch VMs and hypervisors like any other system
- separate VMs with different trust levels onto different hosts or networks
- monitor for VMs that weren't created through the normal process

## Why this matters for a SOC engineer

More and more alerts come from the cloud: impossible-travel logins to cloud accounts, new access keys being created, storage made public, or API calls from unusual places. Knowing the shared responsibility model tells me where to look, because most cloud incidents are on the customer's side. And forgotten VMs and shadow IT are exactly the blind spots attackers love.

## Questions I should be able to answer

- What's the difference between a Type 1 and Type 2 hypervisor?
- IaaS vs PaaS vs SaaS: who secures what?
- What are the top threats to cloud computing?
- Name the 14 CSA cloud security domains.
- What is VM sprawl, and how do you prevent it?

## Next

Tomorrow: cryptography, including symmetric and asymmetric encryption, Diffie-Hellman, data masking, steganography, hashing, HMAC and salting.
