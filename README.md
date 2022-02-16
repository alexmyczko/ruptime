# ruptime
poor man’s ruptime

Historically it is using broadcast udp/513 in a network.
So this is a test how many machines it can take.

## Never heard of ruptime, what does it look like?
```
$ ruptime
fish             up    4+21:27,  0 users,  load 0.22, 0.25, 0.25
tuna             up    4+21:27,  0 users,  load 0.20, 0.25, 0.25
dolphin          up   15+05:57,  0 users,  load 0.04, 0.08, 0.07
```

## Configuration
```
yes
```

## Requirements
nc screen xz tcputils

## References
https://sources.debian.org/src/netkit-rwho/0.17-14/ruptime/ruptime.c/
