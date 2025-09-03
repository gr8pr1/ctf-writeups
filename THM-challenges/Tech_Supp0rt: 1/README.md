# Tech_Supp0rt: 1 - TryHackMe Writeup

## Description
Tech_Supp0rt: 1 is a beginner-friendly box on TryHackMe designed to simulate a real-world technical support scenario. The challenge involves identifying vulnerabilities, exploiting misconfigurations, and escalating privileges to gain root access. This writeup documents the step-by-step approach taken to solve the machine, focusing on practical techniques and learning outcomes.

**Note:** Metasploit was not used during the solution of this machine. All exploitation and enumeration were performed manually to encourage deeper understanding of the underlying processes.

---

## Enumeration
For enumeration I used a simple nmap scan with the key -A (which includes -sC - simple scripts, -sV - port and services scan, -O - OS detection):

```bash
nmap -A 10.201.31.100
```

![Nmap Scan](assets/nmap-scan.png)

The scan has identified 4 open ports:
- 22: SSH
- 80: HTTP
- 139: Legacy SMB file sharing
- 445: Current standard for SMB file sharing

The detailed nmap scan also revealed that the security for Samba is relatively weak and can be accessed in guest mode (no authenticaion), so I will start with searching through the samba shared files. For this we will use this smbclient command:

```bash
smbclient -L //10.201.31.100/ -N
```

This command lists all the available shares (-L) on the target as well as supresses the password prompt, since we already know that a connection can be established with a guest account:


![Samba Scan](assets/smb-scan.png)

The websrv share is exactly what we are looking for here. Lets connect to the share and inspect what it contains. For this purpose I used the same command, but removed the -L key to simply connect to the share instead of listing:

```bash
smbclient //10.201.31.100/websvr -N
```

![Samba Share](assets/smb-share.png)


And there it is! Using simple commands - ls and get, we have spotted the file enter.txt and downloaded it for later inspection.

Let us take a look at what is inside the file we have just downloaded.

![Enter.txt File](assets/enter.txt.png)

The samba share is cleared now. Now we will see what we have on the HTTP front, but first lets assess the txt file. The file describes 'goals' for the admin, they include:
- Setting up a fake popup website
- Fix the subrion from the /panel, as there is an issue with the /subrion
- Edit the wordpress webiste

This is all very important information. The admin gave us the location to one of the panels - the subrion panels. Under that he also included the credentials for subrion:
- **admin:7sKvntXdPEJaxazce9PXi24zaFrLiKWCk**

However it