#!/usr/bin/env bash

main() {
	mode=$(cat /tmp/__vim_mode_tmux_socket 2>/dev/null)

	case "$mode" in
	"n")
		mode_art="<(•∪•)>"
		;;
	"i")
		mode_art="<(•o•)>"
		;;
	"cv")
		mode_art="(v•-•)>"
		;;
	"v")
		mode_art="(v•-•)v"
		;;
	"V")
		mode_art="(>•-•)>"
		;;

	"c")
		mode_art="(>*-*)>"
		;;

	"s")
		mode_art="(>*-*)>"
		;;

	"S")
		mode_art="(>*-*)>"
		;;

	"ic")
		mode_art="(>*-*)>"
		;;
	"R")
		mode_art="(>*-*)>"
		;;

	"Rv")
		mode_art="(>*-*)>"
		;;

	"r")
		mode_art="(>*-*)>"
		;;

	"rm")
		mode_art="(>*-*)>"
		;;

	"V")
		mode_art="(>*-*)>"
		;;
	*)
		mode_art="(>*-*)>"
		;;
	esac
	echo "$mode_art    "
}

main
