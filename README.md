![ruptime](.ruptime.png?raw=true "ruptime")

poor man’s ruptime

Historically the original ruptime[^1] was using broadcast udp/513[^2] in a network.
Since it's not 1982 anymore, but 2022 today, here's a version for multiple networks with encrypted traffic and
client-server architecture.

You will automatically get instant list of hosts (down or up), inventory of hardware, software overview,
comparable list of benchmark results.

While it was
- rcp (remote copy)
- rexec (remote execution)
- rlogin (remote login)
- rsh (remote shell)
- rstat
- ruptime
- rwho (remote who)

It is now
- ruptime (remote uptime) - the classic
- runame (remote uname and OS/release) - keep track what OS/release you run
- rsw (remote software) - what kind of package managers did sneak in
- rhw (remote hardware, inventory) - what hardware you have
- rload (remote load of CPU/GPU/MEM/NET) - usage of hardware
- rbench (remote benchmark) - comparable list of your hardware
- rboot (remote rebootable?) - safety level for a reboot
- rnet (remote network) - networking details (interface name, connection speed)
- rdisk (remote disk) - overview of local disks and their speeds

## Never heard of ruptime, what does it look like?

The output shows how long the system has been up, the number of  users currently on the
system, and the load averages. The load average numbers give the number of jobs in the
run queue averaged over 1, 5 and 15 minutes.

```
$ ruptime # FQDN   State Uptime    Users    Load Averages 1' 5' 15'
fish.ocean.net      up    4+21:27  0 users  load 0.22 0.25 0.25
tuna.ocean.net      up    4+21:27  0 users  load 0.20 0.30 0.42
dolphin.ocean.net   up   15+05:57  0 users  load 0.04 0.08 0.07
```

```
$ runame # FQDN              Kernel Release Architecture, OS Version Code
fish.ocean.net               Linux 5.15.0-17-generic x86_64, Ubuntu 22.04 jammy
tuna.ocean.net               Darwin 21.1.0 arm64, macOS 12.0.1 21A559
```

```
$ rload # FQDN               CPU %  MEM %
whale.ocean.net               19.00   3.37
```

```
$ rsw # FQDN                 pkg number...
seahorse.ocean.net           dpkg 7243 rpm 0 pip3 393 
```

```
$ rboot # FQDN               users    screen/tmux    cpu load
orca.ocean.net               Users: 2 screen/tmux: 1 CPU: 5
```

```
$ rbench # FQDN              Memory   Total CPU      Cores
orca.ocean.net               MEM 5.05 94 GB CPU 6.16 32
```

## Command line options

```
-i   Install the software
-u   Upload information to the server
-v   Print license/version and quit
```

No option queries the server for the information.

## Why would I want this?
- it's simple[^5]
- monitoring systems have no or not very useful CLI tools
- you don't want to manually keep a list of hosts
- you want to see what hosts are down
- you want to see what hosts are not idle
- you want to run something on all running hosts with `parallel`
- get rid of non-standard/in-house solutions that do not scale or are cumbersome in some other way

## Configuration
The defaults for rwhod/ruptime is downtime after 11' (11\*60 seconds)[^3] (ISDOWN), status messages are originally generated approximately every 3' (AL_INTERVAL)[^4].
```
SERVER=wedonthaveaprivacyproblem.com
PORT=51300
HOSTNAMECMD='hostname -f'
```

Create a key for the encryption with `mcrypt`. You will need this on server and client for symmetric encryption.
```
COLUMNS=160 dd if=/dev/urandom bs=1 count=60 2>/dev/null > /etc/ruptime/ruptime.key
```

Create a local user to run the daemon.
```
adduser --disabled-password --quiet --system --home /var/spool/ruptime --gecos "ruptime daemon" --group ruptime
```

Running the daemon.
```
daemon --user=ruptime:ruptime mini-inetd 51300 /usr/sbin/ruptimed
```

## Requirements
- Client: `nc` `xz` `bc` `memtester` `lm-sensors` `mcrypt`
- Server: `nc` `xz` `tcputils` `daemon` `mcrypt`
- Optionals: `pen` `trickle` `timeout`

## Supported Systems
- macOS
- Linux
- FreeBSD
- Windows if someone implements uptime.exe (https://www.windowscentral.com/how-check-your-computer-uptime-windows-10#check_pc_uptime_cmd)

## Starting it
- FreeBSD: rc.d
- Linux: daemon, init.d, cron @reboot, systemd[^6]
- macOS: https://medium.com/swlh/how-to-use-launchd-to-run-services-in-macos-b972ed1e352
- Windows (not sure if they still have `net start`, haven't seen it since NT 4)

- without systemd
```
# crontab -l
*/1 * * * *  /usr/bin/ruptime -u
*/3 * * * *  /usr/bin/rload -u
*/15 * * * * /usr/bin/rboot -u
@reboot      /usr/bin/rdisk -u
@reboot      /usr/bin/rbench -u
@reboot      /usr/bin/runame -u
@reboot      /usr/bin/rsw -u
@reboot      /usr/bin/rhw -u
@reboot      /usr/bin/rnet -u
```

## Special Files

- https://manpages.debian.org/unstable/manpages/nologin.5.en.html
- https://manpages.debian.org/unstable/manpages/issue.5.en.html
- https://manpages.debian.org/unstable/manpages/motd.5.en.html
- https://manpages.debian.org/unstable/proftpd-basic/ftpusers.5.en.html
- https://manpages.debian.org/unstable/cron/crontab.1.en.html references cron.allow cron.disallow
- https://manpages.debian.org/unstable/login/login.1.en.html

[^1]: https://en.wikipedia.org/wiki/Berkeley_r-commands
[^2]: https://manpages.debian.org/unstable/manpages/services.5.en.html
[^3]: https://sources.debian.org/src/netkit-rwho/0.17-14/ruptime/ruptime.c/
[^4]: https://sources.debian.org/src/netkit-rwho/0.17-14/rwhod/rwhod.c/
[^5]: https://www.gkogan.co/blog/simple-systems/
[^6]: https://kill-9.xyz/harmful/software/systemd
