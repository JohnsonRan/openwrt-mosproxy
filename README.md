# openwrt-mosproxy

OpenWrt package for `mosproxy` from `https://github.com/JohnsonRan/mosproxy`.

## Build

Place this directory in an OpenWrt build tree, for example:

```sh
mkdir -p package/mosproxy
cp -a /path/to/openwrt-mosproxy/. package/mosproxy/
make menuconfig
make package/mosproxy/compile V=s
```

The package uses OpenWrt's Go packaging helper from the `packages` feed:

```sh
./scripts/feeds update packages
./scripts/feeds install golang
```

## Runtime

Installed files:

- `/usr/bin/mosproxy`
- `/etc/init.d/mosproxy`
- `/etc/config/mosproxy`
- `/etc/mosproxy/config.yml`
- `/usr/share/mosproxy/99-dns-redirect.nft`

The default service command is:

```sh
mosproxy router -c /etc/mosproxy/config.yml
```

Service control:

```sh
service mosproxy enable
service mosproxy start
service mosproxy stop
service mosproxy restart
```

When `option nft_redirect '1'` is enabled, starting the service writes
`/etc/nftables.d/99-dns-redirect.nft` and reloads firewall4. Stopping the
service removes that generated rule file and reloads firewall4 again. The
DNS redirect target port is `5553`. The default service user is `nobody`,
matching the nft rule's `meta skuid "nobody" accept` bypass for mosproxy's
own upstream DNS traffic.
