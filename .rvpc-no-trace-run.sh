#!/bin/bash
export RVP_TRACE_ONLY=yes
export RVP_TRACE_FILE=/dev/null   # Tracing to /dev/null
bash -x util/prepare-softhsm2.sh
make unit