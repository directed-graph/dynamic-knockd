#!/usr/bin/env bash

# Usage:
#
#     $0 [ <oathtool_arguments except --totp and --base32> ]
#
# See oathtool.bash for more details.

set -e

$(dirname $0)/oathtool.bash --totp --base32 "$@"

