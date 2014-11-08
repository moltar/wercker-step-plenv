# wercker step moltar/plenv

[![wercker status](https://app.wercker.com/status/dea39740fe7e6a0e9a3ea68cf051dcd5/s "wercker status")](https://app.wercker.com/project/bykey/dea39740fe7e6a0e9a3ea68cf051dcd5)

## SYNOPSIS

This is a [wercker step](http://devcenter.wercker.com/articles/steps/) for installing and using [plenv](https://github.com/tokuhirom/plenv/).

This step will install plenv if necessary, and compile a Perl version specified. The results will be cached in `$WERCKER_CACHE_DIR/plenv` for subsequent runs to save compilation time.

## OPTIONS

All of the options are optional. By default, this step will try to determine the Perl version from the `.perl-version` file in your project root.

If you don't have `.perl-version` file, then you are required to specify the `version` explicitly.

To set your project Perl version, use `plenv local $VERSION` command.

* `version` - which Perl version to build (e.g. 5.20.0).
* `switches` - switches to pass to perl-build (e.g. "-Dusedtrace").
* `as` - as what name to build this Perl version (e.g. "5.18.1-dtrace").

## EXAMPLE

```yaml
box: wercker/default
build:
    steps:
        - moltar/plenv:
        	version: 5.20.0
```

## CHANGES

### 0.3.0

The first usable version.