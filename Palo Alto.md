## Palo Alto Cheatsheet [Another Cheatsheet](https://www.analysisman.com/2020/07/pan-cli-cheat.html)

#### Config Mode
`configure`

#### Show System information
`show system info`
#### Clear Screen
`ctl` +`l`

#### Path Monitoring
`show routing path-monitor`

#### Elasticsearch Health 
`show system software status` <br />
`debug elasticsearch es-state option health`<br />

#### 5000 hints on disk
`debug log-receiver rawlog_fwd show hints-stats`

#### High Disk Usage 
`show system disk-space`<br />
`debug software disk-usage cleanup deep threshold 94` <br />
`debug software disk-usage cleanup deep threshold 90` <br />
`delete core management-plane file crashinfo` <br />
`delete debug-log mp-log file` (all .old_backup files) <br />
`delete config saved autosave-9.0-20210911.xml` <br />
`delete config saved autosave-8.0-20190201.xml` <br />
`delete config saved autosave-8.1-20210116.xml` <br />
`delete pcap directory` (- can also select pcap file to delete `hit tab after directory`) <br />
`delete content cache old-content` <br />

#### EDL Refresh
`set system setting target-vsys vsys2` <br />
`request system external-list refresh type ip name NAME` <br />

#### Bounce VPN
`test vpn ipsec-sa tunnel` <br />
`test vpn ike gateway` <br />
(try clearing sessions on Monitor > session browser if this does not come back up)

#### Test Routing 
`test routing fib-lookup virtual-router default ip <ip address>`

#### Show configuration in set commands 
`run set cli config-output-format set`
	show

#### MVLAV Cloud
`show mlav cloud-status`

#### Raid detail
`show system raid detail`

#### reboot mgmgt server 
`debug software restart process management-server`
