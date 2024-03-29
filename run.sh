#!/usr/bin/env sh

if [ ! -n "$WERCKER_PLENV_VERSION" ]; then
    if [ -f "$WERCKER_SOURCE_DIR/.perl-version" ]; then
        WERCKER_PLENV_VERSION=$(cat "$WERCKER_SOURCE_DIR/.perl-version")
    else
        error 'Please specify Perl version'
        exit 1
    fi
fi

WERCKER_CACHE_DIR_PLENV="$WERCKER_CACHE_DIR/plenv"
PLENV_ROOT=${PLENV_ROOT:-$WERCKER_CACHE_DIR_PLENV}

PLENV_INSTALL_ARGS="$WERCKER_PLENV_VERSION $WERCKER_PLENV_SWITCHES"
PLENV_VERSION_DIR="$WERCKER_PLENV_VERSION"

if [ -n "$WERCKER_PLENV_AS" ]; then
    PLENV_INSTALL_ARGS="$PLENV_INSTALL_ARGS --as $WERCKER_PLENV_AS"
    PLENV_VERSION_DIR=$WERCKER_PLENV_AS
fi

## install plenv if not yet installed
if [ ! -d "$PLENV_ROOT" ]; then
    info "Installing plenv" && \
    mkdir -p $PLENV_ROOT/plugins/perl-build && \
    curl -L --silent https://github.com/tokuhirom/plenv/archive/2.1.1.tar.gz     | tar -xz --strip 1 -C $PLENV_ROOT && \
    curl -L --silent https://github.com/tokuhirom/Perl-Build/archive/1.10.tar.gz | tar -xz --strip 1 -C $PLENV_ROOT/plugins/perl-build
else
    info 'Found plenv in cache'
    debug "plenv cache dir: $WERCKER_CACHE_DIR_PLENV"
fi

export PLENV_ROOT
export PATH="$PLENV_ROOT/bin:$PATH"
eval "$(plenv init -)"

## install Perl if not yet installed
if [ ! -d "$PLENV_ROOT/versions/$PLENV_VERSION_DIR" ]; then
    plenv install $PLENV_INSTALL_ARGS && \
    success "Installed Perl $WERCKER_PLENV_VERSION" && \
    plenv shell $PLENV_VERSION_DIR && \
    plenv install-cpanm
else
    info "Found Perl $PLENV_VERSION_DIR in cache"
fi