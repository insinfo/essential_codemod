# rxdart_codemod

[![Build Status](https://api.travis-ci.org/brianegan/rxdart_codemod.svg?branch=master)](https://travis-ci.org/brianegan/rxdart_codemod)
[![codecov](https://codecov.io/gh/brianegan/rxdart_codemod/branch/master/graph/badge.svg)](https://codecov.io/gh/brianegan/rxdart_codemod)

A utility for code modification, to implement json serialization methods


This [codemod](https://pub.dev/packages/codemod) runs through your codebase
and performs these refactors so you don't have to!

## Installation

`essential_codemod` provides an executable via dart global packages.

In your terminal:

```
pub global activate essential_codemod 
```

## Usage

```
cd path/to/your/code
pub global run essential_codemod:codechange
```

## Arguments

```
    --[no-]recursive    Apply updates to Dart files in the current directory and all subdirectories recursively.
                        (defaults to on)

    --[no-]classes      Use Stream classes instead of Rx factories. Example: "TimerStream" instead of "Rx.timer"
                        (defaults to off)

-h, --help              Prints the help menu
```
