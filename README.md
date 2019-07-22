
This is a service that will dynamically update the knock sequence used by
`knockd`. In essence, we will stop `knockd`, update the knock sequence, and then
restart `knockd` at regular intervals (configurable). The way the knock sequence
is generated will depend on which script is used for generating them. The basic
layout of this repository is as follows:

- `generators/`: stores different scripts that generate knock sequences
- `update.bash`: script to update the knock sequence and restart `knockd`

## Generator Scripts

Each generator script under `generators/` only has two responsibilities:

- generate port numbers
- generate protocol (optional)

The output should be on a per-line basis. For example:

12345
23456:tcp
34567:udp

## Updater Script

If this service is to be deployed, the `update.bash` script can be integrated
with a `systemd` timer. The `update.bash` script will call the generator script
that is given as input, and write the results to the knock sequence file.
Because `knockd` will "cross out" a sequence after using it, we need to write
the desired sequence multiple times into the sequence file for each interval. As
such, we must replace the whole file after each interval.

## Configuration

All configuration should be done via environment variables (which can be set using
the `Environment=` directive in the case of a `systemd` module).

