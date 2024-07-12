### Step 1 - Open PowerShell or Command Prompt as administrator

### Step 2 - Convert Windows Server Evaluation to retail edition


**To get the available editions:**

```shell
DISM /Online /Get-TargetEditions
```

**To set your Windows Server to a higher edition:**

```shell
DISM /online /Set-Edition:ServerStandard /ProductKey:XXXXX-XXXXX-XXXXX-XXXXX-XXXXX /AcceptEula
```

### Step 3 - Install KMS client key

```shell
slmgr /ipk your_license_key
```

Replace `your_license_key` with following volumn license keys according to Windows Edition:

```YOUR KEY HERE```

### Step 4 - Set KMS machine address

```shell
slmgr /skms microsoft.com
```

### Step 5 - Activate your Windows

```shell
slmgr /ato
```
