#!/bin/bash

# I run this in Raspbian chroot with the following command:
#
# $ env -i \
#       HOME=/root \
#       PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
#       SHELL=/bin/bash \
#       TERM=$TERM chroot \
#       /chroot/raspbian /ruststrap/armhf/build-rust.sh

set -x
set -e

: ${DIST_DIR:=~/dist}
: ${DROPBOX:=dropbox_uploader.sh}
: ${MAX_NUMBER_OF_NIGHTLIES:=5}
: ${SNAP_DIR:=~/snap}
: ${SRC_DIR:=~/src}

RUST_DIST_DIR=$DIST_DIR/rust
RUST_SRC_DIR=$SRC_DIR/rust

# Update source to upstream
cd $RUST_SRC_DIR
git checkout master
git pull

# Optionally checkout older hash
git checkout $1
git submodule update

# Get the hash and date of the latest snaphot
SNAP_HASH=$(head -n 1 src/snapshots.txt | tr -s ' ' | cut -d ' ' -f 3)

# Check if the snapshot is available
SNAP_TARBALL=$($DROPBOX list snapshots | grep $SNAP_HASH)
if [ -z "$SNAP_TARBALL" ]; then
  exit 1
fi
SNAP_TARBALL=$(echo $SNAP_TARBALL | tr -s ' ' | cut -d ' ' -f 3)

# setup snapshot
cd $SNAP_DIR
rm -rf *
$DROPBOX -p download snapshots/$SNAP_TARBALL
tar xjf $SNAP_TARBALL --strip-components=1
rm $SNAP_TARBALL
bin/rustc -V

# Get information about HEAD
cd $RUST_SRC_DIR
HEAD_HASH=$(git rev-parse --short HEAD)
HEAD_DATE=$(TZ=UTC date -d @$(git show -s --format=%ct HEAD) +'%Y-%m-%d')
TARBALL=rust-${HEAD_DATE}-${HEAD_HASH}-arm-unknown-linux-gnueabihf

# build it
cd build
../configure \
  --enable-ccache \
  --enable-local-rust \
  --local-rust-root=$SNAP_DIR \
  --prefix=/ \
  --build=arm-unknown-linux-gnueabihf \
  --host=arm-unknown-linux-gnueabihf \
  --target=arm-unknown-linux-gnueabihf
make clean
make -j$(nproc)

# packgae
rm -rf $RUST_DIST_DIR/*
DESTDIR=$RUST_DIST_DIR make install -j$(nproc)
cd $RUST_DIST_DIR
tar czf $DIST_DIR/$TARBALL .
cd $DIST_DIR
TARBALL_HASH=$(sha1sum $TARBALL | tr -s ' ' | cut -d ' ' -f 1)
mv $TARBALL $TARBALL-$TARBALL_HASH.tar.gz
TARBALL=$TARBALL-$TARBALL_HASH.tar.gz

# ship it
$DROPBOX -p upload $TARBALL .
rm $TARBALL

# delete older nightlies
NUMBER_OF_NIGHTLIES=$($DROPBOX list . | grep rust- | wc -l)
for i in $(seq `expr $MAX_NUMBER_OF_NIGHTLIES + 1` $NUMBER_OF_NIGHTLIES); do
  OLDEST_NIGHTLY=$($DROPBOX list . | grep rust- | head -n 1 | tr -s ' ' | cut -d ' ' -f 4)
  $DROPBOX delete $OLDEST_NIGHTLY
done

# cleanup
cd $SNAP_DIR
rm -rf *
cd $RUST_DIST_DIR
rm -rf *