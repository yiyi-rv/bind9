set -x # Print debug info

# Install necessary packages
sudo apt-get install -y libssl-dev libcap-dev automake

# Build the project
CC=cc
LD=ld
mkdir build-atf; cd build-atf; ../unit/atf-src/configure --enable-tools --disable-shared --prefix=/tmp/atf; make -j`nproc`; make install; cd ../
CC=rvpc LD=rvpc ./configure --with-atf=/tmp/atf
make -C ./lib/dns gen BUILD_CC=cc # Avoid hang
make -j`nproc`

# Tests
report_path=`pwd`/report
/tmp/atf/bin/atf-run ./lib/dns/tests/dispatch_test
cd ./bin/tests/system/smartsign; sh setup.sh; RVP_ANALYSIS_ARGS="--html-dir $report_path" sh tests.sh

# Upload report
rv-upload-report $report_path