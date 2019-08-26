
This is a service that will dynamically update the knock sequence used by
`knockd`. In essence, we update the knock sequence and restart `knockd` at
regular intervals (configurable), thereby increasing security. The way the
knock sequence is generated will depend on which script is used for generating
them. The basic layout of this repository is as follows:

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

All configuration for `dynamic-knockd` should be done via environment variables
(which can be set using the `Environment=` directive in the case of a `systemd`
module). Each generator script can have different environmental configurations,
so you should set them based on the generator script you are using.

Configuration for `knockd` itself should still be done through
`/etc/knockd.conf`. Note that you need to set the following:

    one_time_sequences = $BASE_PREFIX/etc/sequence

Where, by default, `$BASE_PREFIX` is `/opt/dynamic-knockd`.

## Installation

Generally, you can clone this repository to `/opt/dynamic-knockd`, and copy the
`systemd` files as appropriate to use it. We have provided a `Makefile` for
convenience. Note that if you modify the `*_PREFIX` values, you may need to
manually modify some paths as well. The basic installation syntax is as follows:

    make [BASE_PREFIX=...] [SYSTEMD_PREFIX=...] [all|base|systemd]

There is no need to compile. Not specifying a recipe will print a message and
do nothing. Installing `all` will install both `base` and `systemd`. Installing
`base` will put the base scripts (`generators/*` and `update.bash`) into
`BASE_PREFIX` (`/opt/dynamic-knockd` by default). Installing `systemd` will put
the `systemd/*` files into `SYSTEMD_PREFIX` (`/usr/local/lib/systemd/system` by
default). Note that you will need to run as root for these default options.

