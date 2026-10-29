---
title: "AWS Cloud Basics, Part 2: Security, Networking, Storage and Monitoring"
date: 2026-10-29 21:00:00 +0500
categories: [Daily Log]
tags: [cloud, aws, vpc, s3, cloudtrail, security]
---

This is the second half of my notes from AWS Cloud Practitioner Essentials. Part 1 covered how AWS started, EC2, Lambda and SQS. This part covers the topics that matter most for security work.

## Shared responsibility: who secures what?

In the cloud, security is split between AWS and the customer.

- **AWS is responsible for security *of* the cloud:** the physical data centers, the hardware, the network between them, and the software that runs the virtual machines.
- **The customer is responsible for security *in* the cloud:** their data, who has access, the operating system on their EC2 instances, firewall settings, and encryption.
- **Some things depend on the service.** With EC2 the customer patches the operating system. With a managed service like Lambda, AWS takes care of more.

A simple way to remember it: AWS secures the building, you lock your own room.

## Networking in AWS

### VPC and subnets

A **VPC (Virtual Private Cloud)** is your own private network inside AWS. You choose its IP range in CIDR, like `10.0.0.0/16`, the same subnetting I practiced last week.

Inside a VPC you create **subnets**:
- **Public subnets** for things that must be reached from the internet, like a web server
- **Private subnets** for things that must not, like a database

### Connecting a VPC

- **Internet Gateway:** connects a VPC to the internet
- **VPN (Virtual Private Gateway):** an encrypted connection over the internet between a company's office and its VPC
- **AWS Direct Connect:** a dedicated private line from a company's data center to AWS. Faster and more stable than going over the public internet.
- **Elastic Load Balancing:** spreads incoming traffic across several servers so none of them gets overloaded

### Layers of security

AWS uses several layers of protection, not just one:

| | Network ACL | Security group |
|---|---|---|
| Protects | A whole subnet | One instance |
| Stateful? | **No:** inbound and outbound rules are checked separately | **Yes:** replies to allowed traffic are allowed automatically |
| Default | The default ACL allows all traffic | Blocks all inbound, allows all outbound |

On top of that come **permissions**: who is allowed to create, change or delete resources in the account. Even a perfect firewall doesn't help if everyone has admin rights.

### Global networking

- **Amazon Route 53** is AWS's DNS service. It turns domain names into IP addresses and can send users to the closest or healthiest Region.
- **Amazon CloudFront** caches content at edge locations around the world so websites load faster for users far away.

## Storage

There are three main kinds of storage, and the difference finally made sense to me:

- **Block storage (Amazon EBS):** a virtual hard drive attached to one EC2 instance. Good for operating systems and databases.
- **Object storage (Amazon S3):** stores files as objects in "buckets". Almost unlimited space, used for backups, images, logs and data lakes. It has storage classes from frequently used to very cheap long-term archives.
- **File storage (Amazon EFS):** a shared file system that many servers can use at the same time.

AWS also has managed databases, like **RDS** for relational databases and **DynamoDB** for NoSQL, so you don't have to run the database server yourself.

## Monitoring, compliance and governance

This was the most important module for me as someone moving into SOC work.

### AWS CloudTrail

**CloudTrail** records every API call made in an AWS account: who did it, what they did, when, and from which IP address.

Why this matters:
- **Event logs** show exactly what happened. If a server was deleted or a permission changed, CloudTrail shows who did it.
- **Audit logs** prove to auditors that rules are being followed.
- During an incident, CloudTrail is one of the first places to look.

**Amazon CloudWatch** watches performance, like CPU usage, and can raise an alarm when something crosses a limit.

### Compliance and governance

- AWS provides **compliance reports** for standards like ISO 27001 and PCI DSS, so customers can show their auditors that the AWS side meets those standards.
- **Governance** means setting rules for the whole organization, like who can create what and in which Regions, and checking that people follow them.

## Migration to AWS

The course also covered how companies move to the cloud:
- There are **frameworks and strategies** for planning a migration, for example moving an app as it is ("lift and shift") or rebuilding it to use cloud services.
- There are **services and tools** to move databases to AWS with little downtime.
- For huge amounts of data, internet transfer is too slow, so AWS offers **offline data transfer**: physical devices are shipped to the customer, filled with data and sent back.

## Building it well

### Well-Architected Framework

AWS's guide for building good cloud solutions. It has six pillars: operational excellence, **security**, reliability, performance efficiency, cost optimization and sustainability.

### Developer tools

A few tools I noted:
- **CodeBuild:** builds and tests code automatically
- **CodePipeline:** automates the release pipeline (CI/CD)
- **X-Ray:** traces requests through an app to find slow or failing parts
- **AppSync** and **Amplify:** help build web and mobile apps faster

And there are many more. AWS has hundreds of services.

### Support

AWS has different support plans, from a free basic plan up to enterprise plans with faster response times and dedicated experts.

## Why this matters for a SOC engineer

- **Shared responsibility** tells me where to look. A breach caused by a public S3 bucket or an open security group is the customer's side, and that's where most real cloud incidents come from.
- **CloudTrail** is to AWS what Windows Event Logs are to a Windows machine. Sending CloudTrail logs into a SIEM is a basic SOC engineering task.
- **Network ACLs, security groups and permissions** are the cloud versions of the firewalls and access control I studied in networking. Reviewing them is one of the first steps in any cloud investigation.

## Next

Today I also finished Cisco's Introduction to Cybersecurity, my first step into Security+ topics. That's for tomorrow's post.
