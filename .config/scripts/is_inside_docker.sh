#!/bin/bash

inside=$(grep "/docker/" </proc/1/cgroup)
if [[ -z "$inside" ]]; then
	exit "0"
else
	exit "1"
fi
