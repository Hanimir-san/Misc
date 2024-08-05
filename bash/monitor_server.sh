#! /bin/bash

set -o errexit
set -o nounset
set -o pipefail

num_cores=cat /proc/cpuinfo|grep --count "processor"

load_avg_quart=uptime | cut -d "," -f 5