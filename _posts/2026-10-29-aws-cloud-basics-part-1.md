---
title: "AWS Cloud Basics, Part 1: How AWS Started, EC2, Lambda and SQS"
date: 2026-10-29 12:00:00 +0500
categories: [Daily Log]
tags: [cloud, aws, ec2, lambda, sqs]
---

Yesterday I finished AWS Cloud Practitioner Essentials. I took handwritten notes all the way through, and the course covers a lot, so I'm writing it up in two parts. This first part is about where AWS came from, how it stays up, and the compute services.

## How AWS started

Amazon started as an online shop. To run that shop at a huge scale, they had to build a lot of servers, storage and tools. Over time they saw a gap: many other companies needed the same kind of infrastructure but couldn't build it themselves.

So Amazon started renting it out. The big idea was **pay as you go**: you don't buy servers, you rent exactly what you need and pay only for what you use. That idea is the heart of cloud computing.

## Cloud in real life

Without the cloud, a company has to buy servers, wait for them to arrive, set them up, and guess how much capacity it will need. Guess too low and the site crashes on a busy day. Guess too high and money is wasted on idle machines.

With the cloud, a server is ready in minutes, you can add more when traffic goes up, and you can switch them off when it goes down. It also makes it easy to reach a **global audience**: you can run your app in data centers close to users in different countries.

## Fault tolerance: still working when something fails

This was one of my favorite parts. AWS is built on the idea that hardware **will** fail, so the system should keep working anyway.

- AWS is split into **Regions**, which are geographic areas, like Frankfurt or Mumbai.
- Each Region has several **Availability Zones (AZs)**. In my notes I wrote them like AZ-01, AZ-02, AZ-03. Each AZ is one or more data centers with its own power and network.
- If you run your app in at least two AZs and one goes down, the other keeps serving users.

It's the same fault tolerance idea from networking, just at a much bigger scale.

## Multi-tenancy

Many customers share the same physical hardware in AWS's data centers. This is called **multi-tenancy**. AWS keeps each customer's virtual machines and data separated from each other, so you can't see or touch someone else's resources even if you are on the same physical server. Making that separation strong is part of AWS's security job.

## Security and compliance: who is responsible?

My one-line note says it well: **AWS and the user are both responsible.** AWS calls this the **shared responsibility model**. I'll go into it properly in Part 2, because it's the most important idea for security work.

## Ways to work with AWS

Everything in AWS is really an **API** call underneath. There are a few ways to make those calls:

- **AWS Management Console:** the website. Easy for learning and one-off tasks.
- **AWS CLI:** commands in the terminal. Good for repeating tasks and scripting.
- **SDKs:** libraries for programming languages like Python, so your code can control AWS directly.

Being able to do everything through the API and CLI means you can **automate** it. As someone who builds automations, this was the part that excited me most.

## EC2: virtual servers

**Amazon EC2** gives you virtual servers, called **instances**. It's the same idea as the Ubuntu VM I run on my Mac, but in AWS's data center.

- You choose the operating system, size and settings, and the instance is ready in minutes.
- **Instance families** are built for different jobs: general purpose, compute optimized, memory optimized, storage optimized, and accelerated computing (GPUs, for example for machine learning).
- Benefits: you only pay while it runs, you can resize it, and you can add more instances when you need them.

## Other compute options

Not every job needs a full server running all the time.

- **AWS Batch** runs large batches of jobs, like processing thousands of files, and handles the servers for you.
- **AWS Lambda** runs code without you managing any server at all.

### Lambda

Lambda clicked for me because it works exactly like the workflows I build in n8n:

1. Something happens, which is the **trigger**: a file is uploaded, a message arrives, an API is called, or a schedule fires.
2. Lambda runs your **function**, a small piece of code.
3. AWS manages the environment automatically: servers, scaling and patching.
4. You pay only for the time the code actually runs.

Lambda supports several languages, including Python, Node.js, Java, C# (.NET), Go and Ruby, and you can bring others with a custom runtime.

### SQS: decoupling with a queue

**Amazon SQS** is a message queue. One part of an app puts messages in, and another part takes them out when it is ready.

Why this matters: if the second part is slow or crashes, the messages just wait in the queue instead of getting lost. The two parts don't depend on each other being up at the same moment. This is called **decoupling**, and it makes systems much more reliable.

## Why this matters for a SOC engineer

- Fault tolerance and multiple AZs are about **availability**, one part of the CIA triad.
- Because everything in AWS is an API call, every action can be **logged**. That's what makes cloud security monitoring possible.
- Lambda and SQS are also used in security automation: a security alert can trigger a Lambda function that, for example, isolates a server or notifies the team automatically. That's the kind of SOC engineering work I'm aiming for.

## Next

Part 2 tonight: shared responsibility, networking, storage, monitoring with CloudTrail, migration and the Well-Architected Framework.
