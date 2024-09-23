#!/bin/bash

# update.sh: Update packages
# https://github.com/Antiz96/arch-update
# SPDX-License-Identifier: GPL-3.0-or-later

if [ -n "${packages}" ]; then
	echo
	main_msg "$(eval_gettext "Updating Packages...\n")"

	if ! "${su_cmd}" pacman --color "${pacman_color_opt}" -Syu; then
		state_updates_available
		echo
		error_msg "$(eval_gettext "An error has occurred during the update process\nThe update has been aborted\n")" && quit_msg
		exit 5
	else
		packages_updated="y"
	fi
fi

if [ -n "${aur_packages}" ]; then
	echo
	main_msg "$(eval_gettext "Updating AUR Packages...\n")"

	if ! "${aur_helper}" --color "${pacman_color_opt}" "${devel_flag[@]}" -Syu; then
		state_updates_available
		echo
		error_msg "$(eval_gettext "An error has occurred during the update process\nThe update has been aborted\n")" && quit_msg
		exit 5
	else
		# shellcheck disable=SC2034
		packages_updated="y"
	fi
fi

if [ -n "${flatpak_packages}" ]; then
	echo
	main_msg "$(eval_gettext "Updating Flatpak Packages...\n")"

	if ! flatpak update; then
		state_updates_available
		error_msg "$(eval_gettext "An error has occurred during the update process\nThe update has been aborted\n")" && quit_msg
		exit 5
	fi
fi

state_up_to_date
echo
info_msg "$(eval_gettext "The update has been applied\n")"