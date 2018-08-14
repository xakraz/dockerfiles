# Dockerfiles repo


<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Desc](#desc)
- [TL;DR](#tldr)
- [Details](#details)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## Desc

This repo is a collection of `Dockerfiles` and `Shell` wrappers to use containerized version of software.

Inspired by https://github.com/jessfraz/dockerfiles

[![Build Status](https://travis-ci.org/xakraz/dockerfiles.svg?branch=master)](https://travis-ci.org/xakraz/dockerfiles)


## TL;DR

* Copy, symlink or whatever the shell wrappers to a directory which is in your `$PATH`
  - `/usr/local/bin/` is a common place
  - `~/.local/bin` is an other user common place

* OR update your `$PATH` environment variable to the directory containing the wrapper


> Notes:
>
>   It is always a good thing to have a look at the wrapper before executing it ;)
>


## Details

If the image called in the wrappers doesn't suites you, you can rebuild it and/or expand it by making changes to the `Dockerfile`.
