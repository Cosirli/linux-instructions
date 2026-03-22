
[Ln's Blog](weilining.github.io/294.html)


## Terminal


### Linux

Bash shell:

```bash
export http_proxy=http://127.0.0.1:7890
export https_proxy=$http_proxy
```

A handy script:

```bash
#!/usr/bin/bash
function proxy_on() {
	export http_proxy=http://127.0.0.1:7890
	export https_proxy=\$http_proxy
	echo -e "Proxy on"
}
function proxy_off() {
	unset http_proxy https_proxy
	echo -e "Proxy off"
}
```

Fish shell:

```bash
# set
set -gx http_proxy=http://127.0.0.1:7890
set -gx https_proxy=$http_proxy
# unset
set -e http_proxy https_proxy
```

### Windows

Command Prompt:
```bash
# set
set http_proxy=http://127.0.0.1:7890
set https_proxy=http://127.0.0.1:7890
# unset
set http_proxy=
set https_proxy=
```

Powershell:
```bash
$env:http_proxy="http://127.0.0.1:1080"
$env:https_proxy="http://127.0.0.1:1080"
```

## Git

Set
```bash
git config --global http.proxy 'socks5://127.0.0.1:7890'
git config --global https.proxy 'socks5://127.0.0.1:7890'
```

Unset
```bash
git config --global --unset http.proxy
git config --global --unset https.proxy
```

### git ssh

#### Linux
In `~/.ssh/config`:

```bash
## Global
# ProxyCommand nc -X 5 -x 127.0.0.1:1080 %h %p

# For specified domain name
Host github.com
	ProxyCommand nc -X 5 -x 127.0.0.1:1080 %h %p
```
#### Windows

In `C:\Users\UserName\.ssh\config`:

```bash
## Global
# ProxyCommand connect -S 127.0.0.1:1080 %h %p

# For specified domain name
Host github.com
	ProxyCommand connect -S 127.0.0.1:1080 %h %p
```


## npm

Set
```bash
npm config set proxy http://server:port
npm config set https-proxy http://server:port
```

Unset
```bash
npm config delete proxy
npm config delete https-proxy
```
