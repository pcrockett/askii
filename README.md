<p align="center">
  <img src="askii.png" alt="logo"><br><br>
  <a href="https://github.com/pcrockett/askii/releases">
    <img alt="GitHub All Releases" src="https://img.shields.io/github/downloads/pcrockett/askii/total?style=flat-square">
  </a>
  <a href="./LICENSE-APACHE">
    <img alt="Apache-2.0 OR MIT" src="https://img.shields.io/crates/l/askii?style=flat-square">
  </a>
  <br><br>
  <a href="https://asciinema.org/a/329963" target="_blank"><img src="https://asciinema.org/a/329963.svg" /></a>
</p>

TUI based ASCII diagram editor.

_This is a fork of [nytopop/askii](https://github.com/nytopop/askii). The **real** hard
work was done there. This fork just attempts to restore maintenance, bring dependencies
up-to-date, introduce a continuous integration (CI) process, add quality gates, etc.
However there are two big caveats:_

* _Windows support is completely dropped._
* _macOS can technically be supported, however it is untested and not included in the CI
  or release process here._

# Installation
Install a [binary release](https://github.com/pcrockett/askii/releases).

# Compilation
If you have `docker` installed, run `make ci` to generate an executable.

The binary links against a few X11 libs for clipboard functionality (on Linux), so if
you want to compile without `docker`, make sure those libraries are available during
compilation. On Debian, check out the [Aptfile](./ci/Aptfile) to see what packages are
needed to do a build.

Use `cargo` to compile. Alternatively, the [`Makefile`](./Makefile) can be used to build
a binary and deb / rpm / pacman packages.

```
cd askii && make
```

The produced artifacts will be located in `askii/dist`.

It requires:

- [GNU Make](https://www.gnu.org/software/make/)
- [jq](https://stedolan.github.io/jq/)
- [fpm](https://github.com/jordansissel/fpm)
- [libarchive](https://www.libarchive.org/)

# License
Licensed under either of

* Apache License, Version 2.0, ([LICENSE-APACHE](./LICENSE-APACHE) or
  <http://www.apache.org/licenses/LICENSE-2.0>)
* MIT license ([LICENSE-MIT](./LICENSE-MIT) or <http://opensource.org/licenses/MIT>)

at your option.

## Contribution
Unless you explicitly state otherwise, any contribution intentionally submitted for
inclusion in the work by you, as defined in the Apache-2.0 license, shall be dual
licensed as above, without any additional terms or conditions.
