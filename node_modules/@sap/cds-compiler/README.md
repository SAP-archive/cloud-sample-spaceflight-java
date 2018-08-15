# Getting started

<!-- markdownlint-disable MD001 MD022 -->
##### Table of Contents
<!-- markdownlint-enable MD001 MD022 -->

[Installation and Usage](#installation-and-usage)  
[Documentation](#documentation)  
[Fiori annotations](doc/FioriAnnotations.md)

## Installation and Usage

### github

***Do not add direct dependency to cdsv's github project!***

### Snapshots

Unfortunately npm does not support snapshots via nexus.
The only possibility is to download manually a snapshot and install it.

### Milestones/Releases

Configure Nexus **milestones** registry:

```
npm config set registry "http://nexus.wdf.sap.corp:8081/nexus/content/groups/build.milestones.npm"
```

or **releases** registry:

```
npm config set registry "http://nexus.wdf.sap.corp:8081/nexus/content/groups/build.releases.npm"
```

Install via npm:

```
npm install "@sap/cds-compiler"
```

Or maintain your package.json dependencies as follows:

package.json
```
  "dependencies": {
    "@sap/cds-compiler": "*"
  }
```

### Command Invocation

The compiler with its options is invoked like any other npm/Unix command:

```bash
cdsc [options] <file...>
```
See `cdsc --help` for the options.

The exit code is similar to [`grep` and other commands](http://stackoverflow.com/questions/1101957/are-there-any-standard-exit-status-codes-in-linux):

* `0`: successful compilation
* `1`: compiled with error (the command invocation itself is ok)
* `2`: commmand invocation error (invalid options, repeated file name)

## Documentation

See <https://github.wdf.sap.corp/pages/cap/CDS>.
