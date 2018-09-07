set -x # Print debug info

json_out=`pwd`/errors.json
report_out=`pwd`/report

# Install necessary packages
apt install -y libssl-dev libcap-dev automake

# Build the project
CC=cc
LD=ld
mkdir build-atf; cd build-atf; ../unit/atf-src/configure --enable-tools --disable-shared --prefix=/tmp/atf; make -j`nproc`; make install; cd ../
CC=rvpc LD=rvpc ./configure --with-atf=/tmp/atf
make -C ./lib/dns gen BUILD_CC=cc # Avoid hang
make -j`nproc`

# Tests
export RVP_ANALYSIS_ARGS="--output=json" 
export RVP_REPORT_FILE=$json_out
/tmp/atf/bin/atf-run ./lib/dns/tests/dispatch_test
cd ./bin/tests/system/smartsign; sh setup.sh; sh tests.sh

# Generate and upload report
touch $json_out && rv-html-report $json_out -o $report_out
rv-upload-report $report_out