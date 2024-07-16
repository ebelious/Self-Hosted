## Cheatsheet

### Configure Juniper Device:
If you enter the ssh shell as rooit, enter `cli` to go into JunOS Operational Mode

#### Enter Configuration Mode <br />
`configure` <br />

#### Set Hostname <br />
`set system host-name hostname` <br />

#### Set `root` clear-text password (the entering of the password is in cleartext, then encrypts) <br />
`set system root-authentication plain-text-password` <br />

#### Set `root` ssh key <br />
`set system root-authentication ssh-rsa key` <br />

#### Configure domain  <br />
`set system domain-name domain-name` <br />

#### Configure Management IP (need to see which mgmt interface the device has `show interface terse`) <br />
`set interfaces fxp0 unit 0 family inet address address/prefix-length` <br />
`set interfaces em0 unit 0 family inet address address/prefix-length` <br />

#### Configure DNS server <br />
`> set system name-server address` <br />

#### Commit the changes on the device <br />
`commit` <br />
`commit check` - does a dry run to verifyu settings are correct <br />
`commit at [Time]` - This will revert changes if you do not accept at a certain time frame when this command is ran <br />
`commit comment` - adds a comment to the commit <br />

## Diagnostics
#### How to see interface information <br />
`show interfaces` - detailed view <br />
`show interfaces terse` - list view <br />

#### How to see chassis (device) alarms <br />
`show chassis alarms` <br />

#### How to see chassis (device) enviroment info <br />
`show chassis environment` <br />

#### How to see chassis (device) hardware <br />
`show chassis hardware` <br />

#### How to check software version <br />
`show software` <br />

#### Cable diagnostics
`request diagnostics tdr start interface [INTERFACE]` <br />
`show diagnostics tdr interface [INTERFACE]` <br />

#### See the device configuration in the `set` format <br />
`show configuration | display set`<br />
