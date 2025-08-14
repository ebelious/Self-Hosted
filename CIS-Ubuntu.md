# CIS Compliance with USG for Ubuntu Server
This is a basic guide for running a CIS benchmark for Ubuntu server using Ubuntu Security Guide (usg).
This guide is specifically using cis level1 server(there is others for workstation, and also level2 options)
This will not set the server to 100% complaince but does achieve most of it with a simple and easy process


## Getting Ubuntu Pro
This process does require [Ubuntu Pro](https://ubuntu.com/pro/) which you can get for **FREE (up to 5 machines)**
    - Make a Pro account on the Ubuntu site, this will be used in the next step

You can activate Ubuntu Pro during the server installation by 2 methods. Either by entering the code displayed by the server and entering it on your [Ubuntu Pro profile - Attach](https://ubuntu.com/pro/attach) or entering the token from you [Ubuntu Pro profile - Token](https://ubuntu.com/pro/dashboard) 

You can also activate this after installation by entering a token generated from your [Ubuntu Pro profile - Token](https://ubuntu.com/pro/dashboard)
```
sudo pro attach <TOKEN>
```

### Installing USG
```
sudo pro enable usg
```
```
sudo apt install -y usg ubuntu-advantage-tools
```


### Generate a tailoring file
This is the hardening rules that will be used to measure against for the audit, and to use for remediation
```
sudo usg generate-tailoring cis_level1_server hardening.xml
```

### Notes before you run the Audit and Remediation
For both the audit and remediation, there will be a OpenSCAP Evaluation Report generated in html format after each process is completed. These file paths will be printed to the screen. 
You can using `lynx` cli browser tool to view these reports
```
sudo apt install lynx
```
```
sudo lynx /PATH/TO/HTML_FILE
```


### Auditing a system
This will show the CIS score of the servers current state with a pass or fail on each item. On a minimal base install of Ubuntu 24.04 there will be about 65% compliance 
```
sudo usg audit --tailoring-file hardening.xml
```

### Remediating a system
This will apply most fixes automatically. On a minimal base install of Ubuntu 24.04 there will be about 89% of compliance after the fixes are applied
```
sudo usg fix --tailoring-file hardening.xml
```
