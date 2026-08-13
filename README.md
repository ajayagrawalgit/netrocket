# 🚀 NetRocket

### Make Windows use the network hardware you already paid for.

NetRocket is a PowerShell-based Windows network optimization utility for Wi-Fi and wired Ethernet.

## Quick start

Run PowerShell as Administrator:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
```

```powershell
.\NetworkOptimizer.ps1 -Type WiFi
```

or:

```powershell
.\NetworkOptimizer.ps1 -Type Wired
```

Preview changes:

```powershell
.\NetworkOptimizer.ps1 -Type WiFi -WhatIf
```

Skip the adapter restart:

```powershell
.\NetworkOptimizer.ps1 -Type WiFi -NoRestart
```

## One entry point, small components

Only one file is executed directly:

```text
netrocket/
├── NetworkOptimizer.ps1       # ONLY entry point
├── src/
│   ├── Output.ps1
│   ├── AdapterDiscovery.ps1
│   ├── AdapterProperties.ps1
│   ├── PowerManagement.ps1
│   ├── WiredOptimizer.ps1
│   ├── WiFiOptimizer.ps1
│   └── Runner.ps1
├── docs/
│   ├── wifi.md
│   ├── ethernet.md
│   └── troubleshooting.md
└── tests/
    └── PropertyMatching.Tests.ps1
```

The entry point only handles parameters and loads the implementation components. Each component has one focused responsibility.

## What it tunes

### Wi-Fi

Where supported:

- Transmit Power → Highest
- Roaming Aggressiveness → Medium
- Preferred Band → 6 GHz / 5 GHz
- 5 GHz Channel Width → Auto
- Wireless Mode → 802.11ax where supported
- Windows adapter power-down → Disabled

### Wired Ethernet

Where supported:

- Energy Efficient Ethernet → Disabled
- Interrupt Moderation → Disabled
- Flow Control → Disabled
- Windows adapter power-down → Disabled

Driver properties vary. Unsupported settings are skipped rather than forced.

## Why driver-aware?

Different Windows network drivers expose different property names and values.

NetRocket discovers the properties first, then tries known compatible values.

```text
Detect adapter
      ↓
Read driver properties
      ↓
Find supported settings
      ↓
Apply compatible values
      ↓
Show final state
```

## Important

NetRocket is an optimization tool, not an internet-speed generator.

Results depend on the adapter, driver, router/access point, signal, congestion, ISP, and network topology.

Flow Control in particular can be useful on managed networks, so disabling it should be treated as an experiment rather than a universal recommendation.

Always benchmark before and after.

## Requirements

- Windows 10+
- PowerShell 5.1+ or PowerShell 7
- Administrator privileges
- Physical Wi-Fi or Ethernet adapter

## Tests

Install Pester:

```powershell
Install-Module Pester -Scope CurrentUser
```

Run:

```powershell
Invoke-Pester .\tests
```

## Documentation

- [Wi-Fi tuning](docs/wifi.md)
- [Ethernet tuning](docs/ethernet.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Contributing](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)

## References

Initial Ethernet tuning ideas were inspired by:

https://www.makeuseof.com/i-changed-4-windows-settings-on-my-laptop-and-my-wi-fi-finally-matched-my-plans-speed/

Microsoft NetAdapter documentation:

https://learn.microsoft.com/powershell/module/netadapter/

Intel wireless guidance:

https://www.intel.com/content/www/us/en/support/articles/000057574/wireless.html

## Roadmap

- [ ] `-Type Auto`
- [ ] Configuration backup
- [ ] One-command rollback
- [ ] Built-in speed benchmark
- [ ] Latency / packet-loss benchmark
- [ ] Wi-Fi signal diagnostics
- [ ] Wi-Fi 7 profile
- [ ] Driver-specific profiles
- [ ] Low-latency profile
- [ ] Maximum-throughput profile
- [ ] JSON diagnostics
- [ ] GUI

## License

MIT. See [LICENSE](LICENSE).
