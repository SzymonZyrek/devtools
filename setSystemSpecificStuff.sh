#!/bin/bash
case "$DESKTOP_SESSION" in
"gnome" | "GNOME")
	DROPDOWN_TERMINAL="guake"
    USER_DESKTOP_DIR=$(xdg-user-dir DESKTOP)
    ;;
"mate" | "MATE" | "lxde" | "LXDE")
	DROPDOWN_TERMINAL="tilda"
    ;;
"kde" | "KDE")
	DROPDOWN_TERMINAL="yakuake"
    ;;
*)
    error "Not supported graphical environment: $DESKTOP_SESSION"
    ;;
esac


