![ruptime](.ruptime.png?raw=true "ruptime")

poor man’s ruptime

Historically the original ruptime[^1] was using broadcast udp/513[^2] in a network.
Since it's not 1982 anymore, but 2022 today, here's a version for multiple networks with encrypted traffic and
client-server architecture.

You will automatically get instant list of hosts (down or up), inventory of hardware, software overview,
comparable list of benchmark results.

While it was
- `rcp` (remote copy)
- `rexec` (remote execution)
- `rlogin` (remote login)
- `rstat`
- `ruptime`
- `rwho` (remote who)
- `rwall` (remote wall)

It is now
- `ruptime` (remote uptime) - the classic
- `runame` (remote uname and OS/release) - keep track what OS/release you run
- `rsw` (remote software) - what kind of package managers did sneak in
- `rhw` (remote hardware, inventory) - what hardware you have
- `rload` (remote load of CPU/MEM/GPU/GPUMEM) - usage of hardware
- `rbench` (remote benchmark) - comparable list of your hardware
- `rboot` (remote rebootable?) - safety level for a reboot
- `rnet` (remote network) - networking details (interface name, connection speed)
- `rdisk` (remote disk) - overview of local disks and their speeds
- `rac` (remote users' connect time) - overview of usage (see ac[^7])
- `rwho` (remote who) - show who is logged in

## Never heard of ruptime, what does it look like?
The output shows how long the system has been up, the number of  users currently on the
system, and the load averages[^6]. The load average numbers give the number of jobs in the
run queue averaged over 1, 5 and 15 minutes.

```
$ ruptime # FQDN   State Uptime    Users    Load Averages 1' 5' 15'
dolphin.ocean.net   up   15+05:57  0 users  load 0.04 0.08 0.07
fish.ocean.net      up    4+21:27  0 users  load 0.22 0.25 0.25
tuna.ocean.net      up    4+21:27  0 users  load 0.20 0.30 0.42
```

```
$ runame # FQDN              Kernel Release Architecture, OS Version Code
banana.ocean.net             Darwin 19.0.0 x86_64, MacOSX 10.15.1 19B77a
fish.ocean.net               Linux 5.15.0-17-generic x86_64, Ubuntu 22.04 jammy
lemon.ocean.net              GNU/kFreeBSD 11.4-0-amd64 x86_64, Debian unreleased sid
tuna.ocean.net               Darwin 21.1.0 arm64, macOS 12.0.1 21A559
```

```
$ rload # FQDN               CPU %  MEM %  GPU %  MEM %
whale.ocean.net               19.00   3.37  51.20  42.12
```

```
$ rsw # FQDN                 pkg number...
seahorse.ocean.net           dpkg 7243 rpm 0 pip3 393 
```

```
$ rhw # FQDN                 age        efi? cores memory
fish.ocean.net               2008/09/08 BIOS 8 31
lemon.ocean.net              2021/08/09 UEFI 16 16
banana.ocean.net             2019/12/10 UEFI 64 377
```

```
$ rnet # FQDN                interface linkspeed wlanquality%
fish.ocean.net               wlp3s0     144Mb/s 86
orca.ocean.net               enp4s0 	 2500Mb/s
```

```
$ rboot # FQDN               users   screen/tmux   cpu load
orca.ocean.net               users 2 screen/tmux 1 CPU 5
```

```
$ rbench # FQDN              Memory   Total CPU      Cores
orca.ocean.net               MEM 5.05 94 GB CPU 6.16 32
```

```
$ rac # FQDN                 hours users
orca.ocean.net               15122.94 4
```

```
$ rwho # user host                   date              IP
root     fish.ocean.net:pts/0        2023-06-12 07:28 (1.1.1.1)
me       fish.ocean.net:pts/1        2022-06-23 15:54 (127.0.0.1)
you      fish.ocean.net:pts/3        2023-06-28 06:33 (12.34.56.78)
we       fish.ocean.net:pts/3        1995-06-28 06:33 (100.200.100.200)
us       fish.ocean.net:pts/3        2023-06-28 06:33 (44.44.44.44)
```

## Command line options
```
-a   Show all information about host
-i   Initialize the software
-o   Overview
-u   Upload information to the server (NOTE: this might require root permission and get restricted to the root user in the future)
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

## Real life examples
Get an overview of your operating systems and releases
```
$ runame | awk '{i[$NF]++} END {for (n in i) print i[n] " " n}' | sort -nr
```

Find hosts that are least used by CPU
```
$ rload | sort -k2n
```

Find hosts that have 90%+ usage of either CPU/MEM/GPU/GPUMEM
```
$ rload -c | grep " [9][0-9].\| [0-9][0-9][0-9]."
```

Update `rnet` output for all online hosts
```
$ for a in `ruptime | grep -v " down " | awk '{print $1}'`; do echo $a; ssh root@$a "runame -u"; done
```

List all hosts sorted by network speed
```
$ rnet | sort -k3nr
```

Combined `ruptime` and `rload` output
```
$ join <(ruptime) <(rload) | column -t
```

Find missing reports
```
$ diff -y <(ruptime|awk '{print $1}') <(rhw|awk '{print $1}') | grep '<\|>\||'
```

Run something on all hosts having Ubuntu 22.04
```
$ runame | grep jammy | awk '{print $1}' | parallel -j0 'ssh root@{} "something"'
```

Get total cores and memory of all your machines
```
$ rhw|awk '{print $3 " " $4}'|datamash -t" " sum 1-2
```

Average age of computers, oldest and newest (by BIOS date)
```
$ rhw|awk '{print $2}'|sed "s,/.*,,g"|datamash -t" " median 1 min 1 max 1
```

Right adjusted `rhw` output
```
$ rhw|column -t -R3,4
```

Your total diskspace
```
$ rdisk | sed "s,sd.,,g;s,nvme... ,,g;s,md.,,g;s,mmcblk.,,g" |sed "s,.*ethz.ch,,g" | awk '{for(i=t=0;i<NF;) t+=$++i; $0=t}1' |datamash sum 1
```

Number of users
```
$ rac | awk '{print $3}' |grep -v ^$ |datamash sum 1
483
```

Find hosts without ruptime
```
diff -y <(ruptime|awk '{print $1}') <(arp -a|sort|awk '{print $1}') | grep '>\||'
```

Sometimes `nl` or `ts` (from `moreutils`) are useful as well.

## Installation on DEB based systems

Find the debs in the [release](https://github.com/alexmyczko/ruptime/releases) page.

To download:
```
curl -LO https://github.com/alexmyczko/ruptime/releases/download/1.6/ruptimed_1.6-1_all.deb
curl -LO https://github.com/alexmyczko/ruptime/releases/download/1.6/ruptime_1.6-1_amd64.deb
curl -LO https://github.com/alexmyczko/ruptime/releases/download/1.6/ruptime_1.6-1_arm64.deb
```

To install the client run
```
DEBIAN_FRONTEND=noninteractive apt install ./ruptime_1.6-1_amd64.deb
```

To install the server run
```
DEBIAN_FRONTEND=noninteractive apt install ./ruptimed_1.6-1_all.deb
```

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

## Classic Mode
If you set `HOSTNAMECMD='hostname -s'` you will have the same mode as original rwho/ruptime/rwhod.
You can even limit the thing to your single one network with
```
iptables -A INPUT -p tcp --dport 51300 --match ttl --ttl-gt 1 -j REJECT
```

## Requirements
- Client: `nc` `xz` `bc` `cron` `dmidecode` `memtester` `datamash` `timeout` `mcrypt` `wireless-tools` `acct`
- Server: `nc` `xz` `tcputils` `daemon` `mcrypt`
- Optionals: `pen` `trickle` `bkt` `iptables` `wireless-tools` `nvidia-smi` `lm-sensors`

## Supported Systems
- macOS
- Linux
- FreeBSD

## Starting it
- FreeBSD: rc.d
- Linux: daemon, init.d, cron @reboot, systemd
- macOS: https://medium.com/swlh/how-to-use-launchd-to-run-services-in-macos-b972ed1e352

- without systemd
```
# crontab -l
*/1 * * * *  /usr/bin/ruptime -u
*/3 * * * *  /usr/bin/rload -u
@reboot      /usr/bin/runame -u
@reboot      /usr/bin/rsw -u
```

Some metrics are not useful to have at regular intervals, nor at every boot, so collect them when needed, examples:

```
rboot -u
rnet -u
```

On first setup and hardware changes (memory upgrade, disks added):

```
rbench -u
rdisk -u
rhw -u
```

## More Details
Login to host and try these commands
```
ac -p
ethtool -i $(ifconfig|grep -v "^$"|sed "s,:.*,,"|grep -v "^ "|grep -v ^lo|head -1)
nvme smart-log /dev/nvme0n1
badblocks -sv /dev/sda
sensors
```

## Other r commands
- `rdate`, https://github.com/resurrecting-open-source-projects/openrdate

## Links to related software

- https://github.com/rfmoz/tuptime
- https://github.com/dylanaraps/neofetch
- https://github.com/glpi-project/glpi-agent
- https://github.com/snipe/snipe-it
- https://github.com/PRTG/PythonMiniProbe/
- https://github.com/ganglia/monitor-core

## Special Files
- https://manpages.debian.org/unstable/manpages/nologin.5.en.html
- https://manpages.debian.org/unstable/manpages/issue.5.en.html
- https://manpages.debian.org/unstable/manpages/motd.5.en.html
- https://manpages.debian.org/unstable/proftpd-basic/ftpusers.5.en.html
- https://manpages.debian.org/unstable/cron/crontab.1.en.html references cron.allow cron.disallow
- https://manpages.debian.org/unstable/login/login.1.en.html
- https://manpages.debian.org/unstable/manpages/services.5.en.html
- https://manpages.debian.org/unstable/finger/finger.1.en.html

[^1]: https://en.wikipedia.org/wiki/Berkeley_r-commands
[^2]: https://manpages.debian.org/unstable/manpages/services.5.en.html
[^3]: https://sources.debian.org/src/netkit-rwho/0.17-14/ruptime/ruptime.c/
[^4]: https://sources.debian.org/src/netkit-rwho/0.17-14/rwhod/rwhod.c/
[^5]: https://www.gkogan.co/blog/simple-systems/
[^6]: https://www.brendangregg.com/blog/2017-08-08/linux-load-averages.html
[^7]: https://manpages.debian.org/unstable/acct/ac.1.en.html
