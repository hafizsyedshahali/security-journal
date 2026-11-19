---
title: "Cyber Security 101, Part 1: Linux Fundamentals and Linux Shells"
date: 2026-11-12 14:00:00 +0500
categories: [Daily Log, Cyber Security 101]
tags: [linux, ssh, bash, shell-scripting, tryhackme]
---

With the Cisco path finished, I've started TryHackMe's **Cyber Security 101** path. It's hands-on: every room has a machine to work on, so the commands below are ones I actually ran in the labs. The first rooms were about Linux, which makes sense, because most of the systems a SOC protects or uses run on it.

## Where Linux is used

Linux runs far more of the world than most people notice:

- **web servers** and most of the cloud (AWS, Azure and Google Cloud run huge numbers of Linux machines)
- **Android phones**, which use the Linux kernel
- **network devices** like routers, firewalls and many IoT devices
- **supercomputers**, almost all of which run Linux
- **security tools** themselves: Kali Linux, Security Onion and most SIEM servers

For a SOC analyst this means two things. You will investigate Linux machines, and you will use Linux tools to do it.

## Remote access with SSH

Servers usually don't have a screen and keyboard attached. Admins reach them over the network with **SSH (Secure Shell)**, which gives you a command line on the remote machine through an encrypted connection.

```bash
ssh tryhackme@10.10.10.10
```

- `ssh` is the client program
- `tryhackme` is the username on the remote machine
- `10.10.10.10` is the machine's IP address

SSH listens on **TCP port 22** by default. You can log in with a password or, more securely, with a **key pair** (covered in the cryptography post). Because SSH is so useful, it's also a common target: thousands of failed SSH logins from one IP in a Linux auth log is a classic brute-force pattern.

## Extending commands with arguments

Most Linux commands accept **flags** (also called switches or options) that change what they do. The simplest example is `ls`:

```bash
ls        # lists files in the current folder
ls -a     # also shows hidden files (names starting with a dot, like .bashrc)
ls -l     # long format: permissions, owner, size, date
ls -la    # both at once
```

Hidden files matter in security. Attackers sometimes hide tools or scripts in dot-folders, and configuration files like `.bash_history` can show what commands a user ran.

When you don't know a command's options, `man ls` opens its manual and `ls --help` gives a short summary.

## Managing files

| Command | What it does | Example |
|---|---|---|
| `touch` | creates an empty file | `touch notes.txt` |
| `mkdir` | creates a folder | `mkdir reports` |
| `cp` | copies a file | `cp notes.txt backup.txt` |
| `mv` | moves or renames | `mv backup.txt reports/` |
| `rm` | deletes a file (`rm -R` for folders) | `rm notes.txt` |
| `file` | tells you what type a file really is | `file suspicious.jpg` |
| `cat` | prints a file's contents | `cat /etc/hostname` |

`file` is more useful than it looks. A file called `invoice.pdf` that `file` reports as an executable is a red flag.

## Four folders worth knowing

- **`/etc`** holds system configuration. `/etc/passwd` lists user accounts and `/etc/shadow` stores their password hashes (readable only by root).
- **`/var`** holds data that changes often, most importantly **`/var/log`**, where system and application logs live. This is where a lot of investigation starts.
- **`/root`** is the home folder of the root (administrator) user, separate from `/home`.
- **`/tmp`** is temporary storage that any user can write to and that is cleared on reboot. Because anyone can write there, attackers often drop tools in `/tmp`.

## Editing files: nano and vim

Servers rarely have a graphical editor, so you edit files in the terminal.

- **nano** is simple. `nano file.txt` opens the file, you type, `Ctrl+O` saves and `Ctrl+X` exits. The shortcuts are listed at the bottom of the screen.
- **vim** is more powerful but has modes. You press `i` to insert text, `Esc` to go back to command mode, then type `:wq` to save and quit (or `:q!` to quit without saving).

## Linux shells

A **shell** is the program that reads the commands you type and passes them to the operating system. The terminal is just the window; the shell is what runs inside it. You can check which one you're using with `echo $SHELL`, and list the installed ones with `cat /etc/shells`.

The common shells:

- **Bash** (Bourne Again Shell): the default on most Linux systems, with history, tab completion and scripting.
- **sh**: the older, minimal shell. Many scripts still use it because it's everywhere.
- **Zsh**: Bash-compatible with extra features like better auto-completion and themes. It's the default on macOS.
- **Fish**: user-friendly, with suggestions as you type, but its scripting is not Bash-compatible.

## Shell scripting

A shell script is a text file full of commands that run in order. It's how admins (and SOC engineers) automate repetitive work. The main parts are:

- **the shebang** on the first line, like `#!/bin/bash`, which says which shell runs the script
- **variables** to store values
- **conditions** (`if`) to make decisions
- **loops** (`for`, `while`) to repeat work
- **comments** starting with `#` to explain the code

The room ended with a small "locker" script: it asks for a username, a company name and a PIN, and only "unlocks" if all three are correct. A simplified version:

```bash
#!/bin/bash
# Simple locker: unlocks only when every answer is correct

read -p "Username: " username
read -p "Company: " company
read -p "PIN: " pin

if [ "$username" = "John" ] && [ "$company" = "Tryhackme" ] && [ "$pin" = "7385" ]; then
    echo "Authentication successful. The locker is open."
else
    echo "Authentication denied."
fi
```

Before running it, you make it executable with `chmod +x locker.sh`, then run `./locker.sh`.

It's a toy, but it shows something real: hard-coding secrets in a script means anyone who can read the file can read the PIN. In real environments, that's exactly the kind of thing secret-scanning tools look for.

## Why this matters for a SOC engineer

Almost every investigation on a Linux host uses these basics: reading logs in `/var/log`, checking `/tmp` for dropped files, looking at hidden files and bash history, and checking who logged in over SSH. And scripting is where automation starts, which is the part of security operations I most want to work in.

## Questions I should be able to answer

- Name four places where Linux is commonly used.
- How does SSH work, and which port does it use by default?
- What's the difference between `ls` and `ls -a`?
- What are `/etc`, `/var`, `/root` and `/tmp` used for, and why does `/tmp` interest attackers?
- What's the difference between a terminal and a shell?
- What are the main parts of a shell script?

## Next

Tonight: Windows. The command-line tools every analyst uses on Windows, and PowerShell.
