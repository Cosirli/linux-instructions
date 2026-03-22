
## SSH Tunneling & Port Forwarding

### 1. Local Port Forwarding (`-L`)

**Scenario**: You want to reach a remote service (e.g., a MySQL DB) that is protected by a firewall, but you have SSH access to a "Jump Server" that _can_ see that DB (they're in the same private network).

To access the MySQL server (`mysql_ip` on port 3306) from the client, set up a local tunnel (via `-L`) on the SSH client:


```bash
# Syntax: ssh -L [local_bind_address:]local_port:destination_host:destination_port user@jump_server
ssh -L 3307:mysql_ip:3306 user@jump_server
```

**How it works:** Your SSH client listens on `localhost:3307`. Any traffic sent there is encrypted, tunneled to `jump_server`, and then decrypted and forwarded to `mysql_ip:3306`.

Note that the SSH server must have set `AllowTCPForwarding yes` to enable port forwarding.

### 2. Remote Port Forwarding (`-R`)

**Scenario:** Intranet penetration. You are behind a NAT/Firewall and want a public server to be able to reach your local machine. The local machine is under NAT and its router blocks port 22.



```bash
# Run this from your local PC
ssh -R 2200:localhost:22 user@server_ip
```

**How it works:** The command above establishes a channel from the server to your local machine. `server_ip` starts listening on its port `2200`. Any traffic hitting that port is tunneled back to your local PC’s port `22`.

**Note:** This by default only allows the server itself to access the forwarding port. To allow outside users to connect to `server_ip:2200`, the server's `sshd_config` must have `GatewayPorts yes`.

### 3. Dynamic Port Forwarding (`-D`)

**Scenario:** You want to access _multiple_ different internal services, without manually setting up individual tunnels for every single IP/port, which might be dynamic and our tunnel would fail once an IP changes. Therefore, we'd set up a dynamic tunnel:

```bash
ssh -D 1080 user@server_ip
```

This turns your SSH client into a **SOCKS5 Proxy**. After setup:

```bash
# Web/HTTP
curl --socks5-hostname localhost:1080 http://internal-service.local

# MySQL
mysql --proxy=socks5://localhost:1080 -h mysql_ip -u user -p
```


### Key Configuration & Flags

| Flag | Purpose |
| :--- | :--- |
| `-L` | **Local** tunnel |
| `-R` | **Remote**: Forward a remote port back to localhost. |
| `-D` | **Dynamic**: SOCKS proxy for flexible routing. |
| `-N` | Do not run a command. |
| `-f` | Run in the background. |

> **Requirement:** The SSH server must have `AllowTCPForwarding yes` enabled in `/etc/ssh/sshd_config` for any of these to work.
