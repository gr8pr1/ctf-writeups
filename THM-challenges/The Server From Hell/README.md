# The Server From Hell - TryHackMe Writeup

## Description
The Server From Hell is a medium-level challenge on the TryHackMe platform. This lab stands out by encouraging the use of manually written scripts or adapting existing ones to capture the flags. Personally, I learned a lot while attempting this challenge and highly recommend it for anyone looking to improve their practical skills.

**Note:** Metasploit was not used during the solution of this machine. All exploitation and enumeration were performed manually to encourage deeper understanding of the underlying processes.

---

## Enumeration

As soon as we join the challenge, we are advised to "Start at port 1337 and enumerate your way.", so this is what we are going to do.

We can use telnet to establish a session to the machine:

![Telnet 1337](assets/telnet-1337.png)

