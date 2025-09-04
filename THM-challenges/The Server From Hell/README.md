# The Server From Hell - TryHackMe Writeup

## Description
The Server From Hell is a medium-level challenge on the TryHackMe platform. This lab stands out by encouraging the use of manually written scripts or adapting existing ones to capture the flags. Personally, I learned a lot while attempting this challenge and highly recommend it for anyone looking to improve their practical skills.

**Note:** Metasploit was not used during the solution of this machine. All exploitation and enumeration were performed manually to encourage deeper understanding of the underlying processes.

---

## Enumeration

As soon as we join the challenge, we are advised to "Start at port 1337 and enumerate your way.", so this is what we are going to do.

We can use telnet to establish a session to the machine:

![Telnet 1337](assets/telnet-1337.png)

The message states that we must find a trollface hiding in the banners of sessions of the first 100 port. Banners are the messages printed as the last line before the "Connection close by foreign host" message. So, let's create a script printing those lines from the connection of the first 100 ports. The script shall accomplish that through the following steps:
- Connect via telnet to the session (IP + port number)
- Sanitize the output, so that only the banner is printed
- Do the same for the next port until the port 100 is reached

Using AI, I created the following script:

```bash
#!/bin/bash

TARGET_IP="IP"
MAX_PORT=100

echo "Scanning ports 1 to $MAX_PORT on $TARGET_IP..."
echo "----------------------------------------"

for port in $(seq 1 $MAX_PORT); do
    echo -n "port $port: "
    
    output=$(telnet $TARGET_IP $port)
    echo $output | tail -n 1
    
    sleep 0.1
done

echo "----------------------------------------"
echo "Scan completed."
```

**Note:** I uploaded the script into the assets directory.


Create a simple .sh file and add the rights to execute it using the command `chmod +x NAME_OF_YOUR_SCRIPT.sh`. Afterwards, launch it ./NAME_OF_YOUR_SCRIPT.sh, and this is what you are going to see:

![Enumeration Scan](assets/enum-script-scan.png)


As we can see, one of the banners tells us to "go to port 12345", so let's do that:


![Port 12345](assets/12345-scan.png)

The banner of the session with port 12345 informs us about the NFS share available on the server. We can locate and mount the share using `nfs-utils` package, if you do not already have it, download it.


Using the showmount command with the key -e (Shows the export lists of the NFS server) we can list the available shares:

![ShowMount](assets/showmount.png)

The output indicates that the share /home/nfs is available, so let`s mount it to our device:
- Create a directory which will be used to mount the NFS share:
```bash
mkdir /mnt/nfs
```
- Mount the share to your device:
```bash
mount -t nfs server_ip:/home/nfs /mnt/nfs
```
- List the shared directory:
```bash
ls /mnt/nfs
```
- Copy the files in the share to your working directory.

- Unmount the share
```bash
umount /mnt/nfs
```

![NFS Mount](assets/nfs-mount.png)


The only file located on the share was `backup.zip`. Trying to unzip the archive, we can see that it is encrypted with a passkey:

![backup.zip](assets/backup.png)

Let's bruteforce our way in. There are multiple tools for that, however I used `fcrackzip` with a `rockyou.txt` wordlist. If you wish to use the same tool, here is the command:

```bash
frackzip -u -D -p /path/to/wordlist backup.zip
```

![Fcrackzip](assets/fcrackzip.png)

There it is! The passkey to the archive is **zxcvbnm**. Let`s unzip it:

![unzipping](assets/unzip.png)

![List Hades](assets/ls-hades.png)

If we list the /home/hades directory, we can see that it contains a .ssh directory containing:
- **authorized_keys** file: Stores public SSH keys that are allowed to authenticate and log in to the user account without a password.
- **flag.txt**: One of the flags for the task
- **hint.txt**: A hint we are going to take a look at
- **id_rsa**: The private SSH key used for secure authentication.
- **id_rsa.pub**: The public SSH key corresponding to id_rsa. It can be added to authorized_keys on remote systems to allow key-based authentication.


There is the first flag!

![flag.txt](assets/flag.txt.png)


