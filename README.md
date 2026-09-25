# devtools

> **Historical workstation-bootstrap toolkit — 2010s**

A collection of scripts I used to bootstrap and reproduce my development environment.

The top-level installer orchestrated setup for things such as:

- base system packages;
- Zsh / Oh My Zsh;
- recompiling Vim;
- my Bash and Vim configurations;
- Powerline fonts;
- Java;
- Eclipse and Eclim;
- networking helpers;
- the wallpaper rotator.

The repository also contains package-manager-specific lists, utility scripts and an early Vagrant-based environment setup.

## Why keep this

This is not a modern provisioning system. It is useful as part of the historical record of a recurring engineering habit: if I had to configure something repeatedly, I usually tried to turn the steps into code.

That instinct later scaled from workstation scripts into CI/CD, deployment automation and production operations.

## Status

Historical tooling. Many external URLs, packages and assumptions are obsolete and should not be treated as a current installer.
