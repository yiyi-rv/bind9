set -x # Print debug info

# Install necessary packages
# apt install -y libssl-dev libcap-dev automake

# Build the project
mkdir build-atf; cd build-atf; CC=clang ../unit/atf-src/configure --enable-tools --disable-shared --prefix=/tmp/atf; make -j`nproc`; make install; cd ../
# Add /tmp/atf/bin to system path.

## clang only
### CC=clang ./configure --with-atf=/tmp/atf

## With tsan
### CC=clang CFLAGS='-fsanitize=thread' ./configure --with-atf=/tmp/atf

## rvpc (perfctrs branch)
export RVP_TRACE_ONLY=yes
export RVP_TRACE_FILE=/dev/null   # Tracing to /dev/null
CC=rvpc ./configure --with-atf=/tmp/atf

make -j`nproc` -k all V=1