# Ethernet tuning

## Energy Efficient Ethernet

Preferred value: `Disabled`

EEE reduces power consumption on supported links. Disabling it can favor performance and responsiveness.

## Interrupt Moderation

Preferred value: `Disabled`

Disabling interrupt moderation can reduce latency for some workloads at the cost of potentially higher CPU interrupt activity.

## Flow Control

Preferred value: `Disabled`

This is environment-sensitive. Flow Control can be useful on managed networks. Treat disabling it as an experiment on a personal/home network.

## Adapter power management

NetRocket asks Windows not to power down the adapter.
