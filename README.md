# 🚀 NetRocket

A tiny PowerShell utility that applies a few Windows network-adapter settings that can help you get closer to the speed your connection is capable of.

Inspired by:

https://www.makeuseof.com/i-changed-4-windows-settings-on-my-laptop-and-my-wi-fi-finally-matched-my-plans-speed/

## Usage

Run PowerShell as Administrator.

### Wi-Fi

```powershell
.\NetworkOptimizer.ps1 -Type WiFi
```

### Wired Ethernet

```powershell
.\NetworkOptimizer.ps1 -Type Wired
```

That's it.

## What it changes

### Wi-Fi

NetRocket attempts to configure:

- Transmit Power → Highest
- Roaming Aggressiveness → Medium
- Preferred Band → 5 GHz
- 5 GHz Channel Width → Auto

### Wired Ethernet

NetRocket attempts to configure:

- Energy Efficient Ethernet → Disabled
- Interrupt Moderation → Disabled
- Flow Control → Disabled

The exact settings available depend on your network adapter and driver.

If a setting doesn't exist on your machine, NetRocket simply skips it.

## Requirements

- Windows 10 or newer
- PowerShell
- Administrator privileges
- Wi-Fi or Ethernet adapter

## Important

This does not increase the speed provided by your ISP.

It only changes network-adapter settings that may affect performance.

Results vary depending on your:

- Network adapter
- Driver
- Router/access point
- Wi-Fi signal
- Network environment

Run a speed test before and after to see whether it actually helped.

## Project structure

```text
netrocket/
├── NetworkOptimizer.ps1
├── src/
│   ├── Adapter.ps1
│   ├── WiFi.ps1
│   └── Wired.ps1
├── README.md
└── LICENSE
```

`NetworkOptimizer.ps1` is the only entry point.

## License

MIT
