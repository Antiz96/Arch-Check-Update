#!/bin/bash

# common.sh: Set variables and functions commonly used across Arch-Update stages
# https://github.com/Antiz96/arch-update
# SPDX-License-Identifier: GPL-3.0-or-later

# Definition of the colors for the colorized output
if [ -z "${no_color}" ]; then
	bold="\e[1m"
	blue="${bold}\e[34m"
	green="${bold}\e[32m"
	yellow="${bold}\e[33m"
	red="${bold}\e[31m"
	color_off="\e[0m"
	# shellcheck disable=SC2034
	pacman_color_opt="always"
else
	# shellcheck disable=SC2034
	pacman_color_opt="never"
	contrib_color_opt+=("--nocolor")
fi

# Definition of the main_msg function: Display a message as a main message
main_msg() {
	msg="${1}"
	echo -e "${blue}==>${color_off}${bold} ${msg}${color_off}"
}

# Definition of the info_msg function: Display a message as an information message
info_msg() {
	msg="${1}"
	echo -e "${green}==>${color_off}${bold} ${msg}${color_off}"
}

# Definition of the ask_msg function: Display a message as an interactive question
ask_msg() {
	msg="${1}"
	# shellcheck disable=SC2034
	read -rp $"$(echo -e "${blue}->${color_off}${bold} ${msg}${color_off} ")" answer
}

# Definition of the ask_msg_array function: Display a message as an interactive question with multiple possible answers 
ask_msg_array() {
	msg="${1}"
	# shellcheck disable=SC2034
	read -rp $"$(echo -e "${blue}->${color_off}${bold} ${msg}${color_off} ")" -a answer_array
}

# Definition of the warning_msg function: Display a message as a warning message
warning_msg() {
	msg="${1}"
	echo -e "${yellow}==> $(eval_gettext "WARNING"):${color_off}${bold} ${msg}${color_off}"
}

# Definition of the error_msg function: Display a message as an error message
error_msg() {
	msg="${1}"
	echo -e >&2 "${red}==> $(eval_gettext "ERROR"):${color_off}${bold} ${msg}${color_off}"
}

# Definition of the continue_msg function: Display the continue message
continue_msg() {
	msg="$(eval_gettext "Press \"enter\" to continue ")"
	read -n 1 -r -s -p $"$(info_msg "${msg}")" && echo
}

# Definition of the quit_msg function: Display the quit message
quit_msg() {
	msg="$(eval_gettext "Press \"enter\" to quit ")"
	read -n 1 -r -s -p $"$(info_msg "${msg}")" && echo
}

# Definition of the AUR helper to use (depending on if/which one is installed on the system and if it's not already defined in arch-update.conf) for the optional AUR packages support
# shellcheck disable=SC2034
if [ -z "${aur_helper}" ]; then
	if command -v paru > /dev/null; then
		# shellcheck disable=SC2034
		aur_helper="paru"
	elif command -v yay > /dev/null; then
		# shellcheck disable=SC2034
		aur_helper="yay"
	fi
else
	if ! command -v "${aur_helper}" > /dev/null; then
		warning_msg "$(eval_gettext "The \${aur_helper} AUR helper set for AUR packages support in the arch-update.conf configuration file is not found\n")"
	fi
fi

# Check if flatpak is installed for the optional Flatpak support
# shellcheck disable=SC2034
flatpak=$(command -v flatpak)

# Check if notify-send is installed for the optional desktop notification support
# shellcheck disable=SC2034
notif=$(command -v notify-send)

# Definition of the elevation command to use (depending on which one is installed on the system and if it's not already defined in arch-update.conf)
if [ -z "${su_cmd}" ]; then
	if command -v sudo > /dev/null; then
		su_cmd="sudo"
	elif command -v doas > /dev/null; then
		su_cmd="doas"
	elif command -v run0 > /dev/null; then
		su_cmd="run0"
	else
		error_msg "$(eval_gettext "A privilege elevation command is required (sudo, doas or run0)\n")" && quit_msg
		exit 2
	fi
else
	if ! command -v "${su_cmd}" > /dev/null; then
		error_msg "$(eval_gettext "The \${su_cmd} command set for privilege escalation in the arch-update.conf configuration file is not found\n")" && quit_msg
		exit 2
	fi
fi

# Definition of the diff program to use (if it is set in the arch-update.conf configuration file)
if [ -n "${diff_prog}" ]; then
	if [ "${su_cmd}" == "sudo" ]; then
		diff_prog_opt=("DIFFPROG=${diff_prog}")
	elif [ "${su_cmd}" == "run0" ]; then
		diff_prog_opt+=("--setenv=DIFFPROG=${diff_prog}")
	fi
fi

# Definition of the state_updates_available function: Change state to "updates-available"
state_updates_available() {
	# shellcheck disable=SC2154
	echo "${name}_updates-available" > "${statedir}/current_state"
}

# Definition of the state_up_to_date function: Change state to "up to date"
state_up_to_date() {
	echo "${name}" > "${statedir}/current_state"
}
