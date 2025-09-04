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

Create a simple .sh file and add the rights to execute it using the command `chmod +x NAME_OF_YOUR_SCRIPT.sh`. Afterwards, launch it ./NAME_OF_YOUR_SCRIPT.sh, and this is what you are going to see:

![Enumeration Scan](assets/enum-script-scan.png)


As we can see, one of the banners tells us to "go to port 12345", so let's do that:


![Port 12345](assets/12345-scan.png)

