## Cheatsheet

### Configure Juniper Device:

If you enter the ssh shell as rooit, enter `cli` to go into JunOS Operational Mode

Enter Configuration Mode
`configure`

Set Hostname
`set system host-name hostname`

Set `root` clear-text password (the entering of the password is in cleartext, then encrypts)
`set system root-authentication plain-text-password`

Set `root` ssh key
`set system root-authentication ssh-rsa key`

Configure domain 
`set system domain-name domain-name`

Configure Management IP (need to see which mgmt interface the device has `show interface terse`)
`set interfaces fxp0 unit 0 family inet address address/prefix-length`
`set interfaces em0 unit 0 family inet address address/prefix-length`

Configure DNS server
`> set system name-server address`

Commit the changes on the device
`commit`
`commit check` - does a dry run to verifyu settings are correct
`commit at [Time]` - This will revert changes if you do not accept at a certain time frame when this command is ran
`commit comment` - adds a comment to the commit

## Diagnostics

How to see interface information
`show interfaces` - detailed view
`show interfaces terse` - list view

How to see chassis (device) alarms
`show chassis alarms`

How to see chassis (device) enviroment info
`show chassis environment`

How to see chassis (device) hardware
`show chassis hardware`

How to check software version
`show software`

`request diagnostics tdr start interface [INTERFACE]`
`show diagnostics tdr interface [INTERFACE]`

See the device configuration in the `set` format
`show configuration | display set
