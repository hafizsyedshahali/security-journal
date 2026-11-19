---
title: "Cyber Security 101, Part 6: Packet Analysis with Wireshark and tcpdump"
date: 2026-11-14 21:00:00 +0500
categories: [Daily Log, Cyber Security 101]
tags: [wireshark, tcpdump, packet-analysis, pcap, tryhackme]
---

After two posts about protocols, these two rooms were about actually looking at them. **Wireshark** and **tcpdump** both capture and read network packets. Wireshark is the graphical tool you use to explore; tcpdump is the command-line tool you use on servers or when you need to script something.

## What a packet capture is

A **packet capture (pcap)** is a file containing the raw packets that crossed a network interface: every header, every payload, with exact timestamps. Logs tell you that something happened; a pcap shows you exactly what was sent. That's why packet captures are so valuable in investigations.

## Wireshark: tool overview

When you open a capture in Wireshark, the window has three main panes:

1. **Packet list:** one line per packet with number, time, source, destination, protocol, length and a short summary.
2. **Packet details:** the selected packet broken down layer by layer.
3. **Packet bytes:** the raw data in hex and ASCII.

The **Statistics** menu is also useful: **Conversations** shows who talked to whom and how much, and **Protocol Hierarchy** shows which protocols make up the capture.

## Packet dissection

Wireshark "dissects" each packet into its layers, matching the OSI model I covered earlier:

- **Frame:** capture details, like arrival time and length (layer 1)
- **Ethernet:** source and destination MAC addresses (layer 2)
- **IP:** source and destination IP addresses, TTL (layer 3)
- **TCP or UDP:** ports, sequence numbers, flags (layer 4)
- **Application protocol:** HTTP, DNS, and so on (layers 5–7)

Clicking through these layers on a single HTTP packet made the OSI model feel much more concrete than any diagram.

## Packet navigation

- **Go to packet** jumps to a packet number.
- **Find packet** searches for a string, hex value or display filter.
- **Mark packets** and **packet comments** help you keep track of interesting ones during an investigation.
- **Follow TCP stream** rebuilds a whole conversation, so you can read an HTTP exchange from start to finish.
- **Export objects** pulls files out of HTTP or SMB traffic, for example a downloaded file.
- **Expert info** flags problems like retransmissions and errors.

## Packet filtering

There are two kinds of filters, and the difference matters:

- **Capture filters** decide what gets recorded in the first place (same syntax as tcpdump).
- **Display filters** hide packets you don't want to see, without deleting them.

Some display filters I used:

```
ip.addr == 10.10.10.5          # traffic to or from this IP
ip.src == 10.10.10.5           # only from this IP
tcp.port == 80                 # TCP traffic on port 80
http                           # only HTTP
dns                            # only DNS
http.request.method == "POST"  # form submissions
tcp.flags.syn == 1 && tcp.flags.ack == 0   # connection attempts
```

Filters can be combined with `&&` (and), `||` (or) and `!` (not). You can also right-click any field and choose **Apply as Filter**, which is the fastest way to build one.

## tcpdump: basic packet capture

tcpdump runs in the terminal, which makes it the tool of choice on remote servers.

```bash
sudo tcpdump -i eth0                 # capture on interface eth0
sudo tcpdump -i eth0 -w capture.pcap # save to a file
tcpdump -r capture.pcap              # read a saved file
sudo tcpdump -i eth0 -c 50           # stop after 50 packets
sudo tcpdump -i eth0 -n              # don't resolve names, show raw IPs and ports
```

- `-i` picks the interface (`ip a s` lists them)
- `-w` writes to a file, `-r` reads one
- `-c` limits the number of packets
- `-n` skips DNS lookups, which keeps output fast and clean
- `-v` adds more detail

A file saved with tcpdump can be opened in Wireshark afterwards, which is a common workflow: capture on the server, analyse on your laptop.

## Filtering expressions

```bash
tcpdump -r capture.pcap host 10.10.10.5
tcpdump -r capture.pcap src host 10.10.10.5
tcpdump -r capture.pcap port 53
tcpdump -r capture.pcap tcp
tcpdump -r capture.pcap icmp
tcpdump -r capture.pcap "host 10.10.10.5 and port 80"
tcpdump -r capture.pcap "not port 22"
```

- `host`, `src host`, `dst host` filter by address
- `port`, `src port`, `dst port` filter by port
- `tcp`, `udp`, `icmp` filter by protocol
- `and`, `or`, `not` combine them

## Advanced filtering

tcpdump can filter on individual fields inside headers. The most useful example is TCP flags:

```bash
tcpdump -r capture.pcap "tcp[tcpflags] == tcp-syn"        # only SYN packets
tcpdump -r capture.pcap "tcp[tcpflags] & tcp-rst != 0"     # packets with RST set
```

Lots of SYN packets from one host to many ports is what a port scan looks like, which links straight to the Nmap post tomorrow.

## Displaying packets

```bash
tcpdump -r capture.pcap -q   # quick, short output
tcpdump -r capture.pcap -e   # include MAC addresses
tcpdump -r capture.pcap -A   # show the payload as ASCII
tcpdump -r capture.pcap -X   # show the payload in hex and ASCII
```

`-A` is how you'd spot a cleartext password in an FTP or HTTP capture.

## Why this matters for a SOC engineer

When an alert says "possible data exfiltration" or "suspicious DNS", the packets are the ground truth. Being able to open a pcap, filter it down to the suspicious host and follow the conversation is a core analyst skill. tcpdump also fits well into automation: a script can capture traffic for a set time when an alert fires, so the evidence is there when someone looks.

## Questions I should be able to answer

- What are Wireshark's three main panes?
- What's the difference between a capture filter and a display filter?
- Write a Wireshark filter for HTTP POST requests from one IP.
- What does Follow TCP Stream do?
- What do tcpdump's `-i`, `-w`, `-r`, `-c` and `-n` options do?
- How would you show only SYN packets in tcpdump? Why would you want to?

## Next

Tomorrow: Nmap, the tool that maps which hosts are up and which services they run.
