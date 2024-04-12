#!/bin/bash

inside=$(grep "/docker/" </proc/1/cgroup)
if [[ -z "$inside" ]]; then
	echo "0"
else
	echo "1"
fi
