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
export PATH="$PLENV_ROOT/bin:$PATH"

PLENV_INSTALL_ARGS="$WERCKER_PLENV_VERSION $WERCKER_PLENV_SWITCHES"
PLENV_VERSION_DIR=$WERCKER_PLENV_VERSION
if [ ! -n "$WERCKER_PLENV_AS" ]; then
    PLENV_INSTALL_ARGS="$PLENV_INSTALL_ARGS --as $WERCKER_PLENV_AS"
    PLENV_VERSION_DIR=$WERCKER_PLENV_AS
fi

## install plenv if not yet installed
if [ ! -f "$PLENV_ROOT/bin/plenv" ]; then
    info "Installing plenv" && \
    sudo apt-get update -qq && \
    sudo apt-get install -y perl-modules && \
    sudo mkdir -p $PLENV_ROOT/plugins/perl-build && \
    curl -L --silent https://github.com/tokuhirom/plenv/archive/2.1.1.tar.gz     | sudo tar -xz --strip 1 -C $PLENV_ROOT && \
    curl -L --silent https://github.com/tokuhirom/Perl-Build/archive/1.10.tar.gz | sudo tar -xz --strip 1 -C $PLENV_ROOT/plugins/perl-build && \
    sudo sh -c 'echo '\''eval "$(plenv init -)"'\'' > /etc/profile.d/plenv.sh' &&
    sudo chmod 755 /etc/profile.d/plenv.sh && \
    source /etc/profile
fi

## install Perl if not yet installed
if [ ! -d "$PLENV_ROOT/versions/$PLENV_VERSION_DIR" ]; then
    info "Installing $WERCKER_PLENV_VERSION" && \
    sudo plenv install $PLENV_INSTALL_ARGS && \
    success "Installed $WERCKER_PLENV_VERSION" && \
    sudo plenv install-cpanm && \
    sudo cpanm Carton && \
    sudo plenv rehash
fi

apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*