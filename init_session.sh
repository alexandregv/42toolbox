#!/usr/bin/env bash
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init_session.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: aguiot-- <aguiot--@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/11/12 12:04:02 by aguiot--          #+#    #+#              #
#    Updated: 2019/11/19 20:48:04 by aguiot--         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# https://github.com/alexandregv/42toolbox

# Ensure USER variabe is set
[ -z "${USER}" ] && export USER=`whoami`

################################################################################

# Colors
blue=$'\033[0;34m'
cyan=$'\033[1;96m'
red=$'\033[0;91m'
bold=$'\033[1;31m'
reset=$'\033[0;39m'

# Config
toolbox_path="$HOME/42toolbox"                       #=> 42toolbox path. See https://github.com/alexandregv/42toolbox
bluetooth_device=""                                  #=> Bluetooth device name. Empty = skip bluetooth setup
init_docker=true                                     #=> Init Docker for Mac? See https://github.com/alexandregv/42toolbox/blob/master/init_docker.sh
init_docker_path="$toolbox_path/init_docker.sh"      #=> Location of init_docker.sh file. See https://github.com/alexandregv/42toolbox/blob/master/init_docker.sh
install_apps=true                                    #=> Install desired apps if they are missing?
start_apps=true                                      #=> Start apps?
update_brew=false                                    #=> Update Homebrew (itself)?
upgrade_brew_formulas=true                           #=> Upgrade Homebrew formulas (packages)?
clean_disk=true                                      #=> Clean disk (deletes ~/Library/Caches, does a brew cleanup, etc)?
start_RP42=true                                      #=> Start RP42 (Discord Rich Presence for 42)? See https://github.com/alexandregv/RP42
RP42_path="/sgoinfre/goinfre/Perso/aguiot--/public/" #=> Location of RP42. You should not edit this unless you downloaded it manually. See https://github.com/alexandregv/RP42/blob/master/README.md#installation
open_system_preferences=true                         #=> Open System Preferences at the end? You could need it to edit your keyboard/screen settings, etc.
send_notification=true                               #=> Send a notification when job is done?

# List your desired apps below, used by $install_apps and $start_apps.
declare -a desired_apps=(
	"Discord"
	"Docker"
	"Spotify"
	"Spectacle"
	"Slack"
	"iTerm"
)

################################################################################
# Pair and connect a bluetooth device
if [ -n "$bluetooth_device" ]; then
	echo -e "${blue}Setting up Bluetooth.${reset}"
	osascript <<'END'
		tell application "System Preferences"
			activate
			reveal pane "com.apple.preferences.Bluetooth"
		end tell
END
	bt=$(blueutil --is-connected "$bluetooth_device")
	if [ $bt -ne 0 ]; then
		blueutil --pair "$bluetooth_device" ;:
		blueutil --connect "$bluetooth_device" ;:
	fi
fi

# Check missing apps and open Managed Software Center (MSC) if needed
declare -a apps_to_install=()
if [ "$install_apps" = true ]; then
	for desired_app in "${desired_apps[@]}"; do
		if [ ! -d "/Applications/$desired_app.app" ] && [ ! -d "~/Applications/$desired_app.app" ]; then
			apps_to_install+=( "$desired_app" )
		fi
	done
	if [ ${#apps_to_install[@]} -eq 0 ]; then
		echo -e "${blue}All your apps are already installed! Have a good code session (unless you are a JavaScript guy).${reset}"
	else
		open -a "Managed Software Center"
		echo -e "${blue}Some of your apps are missing:${reset}"
		for app_to_install in "${apps_to_install[@]}"; do
			echo -e "${blue}- ${cyan}${app_to_install}${reset}"
		done
		echo -e "${blue}------------------${reset}"
		read -p "${blue}Please press ${cyan}ENTER${blue}/${cyan}RETURN${blue} when you have installed all your desired apps.${reset}"
		#TODO: re-run check (loop) ?
	fi
fi

# Prepare Docker for Mac (configuring it to not fill your poor 5Gb disk space)
# https://gist.github.com/alexandregv/9f19a72a7340db5c5ea903013fd844dc
[ "$init_docker" = true ] && $init_docker_path

# Start apps
if [ "$start_apps" = true ]; then
	for app in "${desired_apps[@]}"; do
		pgrep -q "$app"
		if [ $? -ne 0 ]; then
			echo -e "${blue}Starting ${cyan}${app}${reset}"
			open -g -a "$app"
		fi
	done
fi

# Update Homebrew
if [ "$update_brew" = true ]; then
	echo -e "${blue}Updating Homebrew.${reset}"
	brew update ;:
fi

# Upgrade Homebrew formulas
if [ "$upgrade_brew_formulas" = true ]; then
	echo -e "${blue}Updgrading Homebrew formulas.${reset}"
	brew upgrade ;:
fi

# Clean disk
if [ "$clean_disk" = true ]; then
	echo -e "${blue}Cleaning up disk.${reset}"
	rm -rf ~/.cache ~/Library/Caches ;:
	brew cleanup ;:
fi

# Start RP42
if [ "$start_RP42" = true ]; then
	if ! grep -q "[R]P42" <(ps aux); then
		if [ -d "/Applications/Discord.app" ] || [ -d "~/Applications/Discord.app" ]; then
			if ! grep -q "[D]iscord" <(ps aux); then
				open -g -a Discord
				echo -e "${blue}Waiting for ${cyan}Discord${blue} to start...${reset}"
				sleep 5
			fi
			if [ -d "$RP42_path"/RP42.app ]; then
				echo -e "${blue}Starting ${cyan}RP42.app${blue}.${reset}"
				open -g $RP42_path/RP42.app
			elif [ -f "$RP42_path"/RP42 ]; then
				echo -e "${blue}Starting ${cyan}RP42${blue}.${reset}"
				$RP42_path/RP42 &
			else
				echo -e "${red}Can not find ${bold}RP42${red}. Please report this bug to ${bold}aguiot--${reset}"
			fi
		else
			echo -e "${bold}Discord${red} is not installed. Please install it to use ${bold}RP42${red}. Skipping.${reset}"
		fi
	else
		echo -e "${cyan}RP42${blue} is already started. Skipping.${reset}"
	fi
fi

# Open System Preferences
if [ "$open_system_preferences" = true ]; then
	echo -e "${blue}Opening ${cyan}System Preferences${blue}.${reset}"
	osascript -e 'tell application "System Preferences" to activate'
fi

# Open System Preferences
if [ "$send_notification" = true ]; then
	osascript -e 'display notification "Your session is ready !" with title "42toolbox/init_session.sh"'
fi
