#!/usr/bin/env bash
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init_docker.sh                                     :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: aguiot-- <aguiot--@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/11/18 08:17:08 by aguiot--          #+#    #+#              #
#    Updated: 2020/02/20 14:34:42 by aguiot--         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# https://github.com/alexandregv/42toolbox

# Ensure USER variabe is set
[ -z "${USER}" ] && export USER=$(whoami)

################################################################################

# Config
docker_destination="/goinfre/$USER/docker" #=> Select docker destination (goinfre is a good choice)

################################################################################

# Colors
blue=$'\033[0;34m'
cyan=$'\033[1;96m'
reset=$'\033[0;39m'

# Uninstall docker, docker-compose and docker-machine if they are installed with brew
brew uninstall -f docker docker-compose docker-machine &>/dev/null ;:

# Check if Docker is installed with MSC and open MSC if not
if [ ! -d "/Applications/Docker.app" ] && [ ! -d "~/Applications/Docker.app" ]; then
	echo "${blue}Please install ${cyan}Docker for Mac ${blue}from the MSC (Managed Software Center)${reset}"
	open -a "Managed Software Center"
	read -n1 -p "${blue}Press RETURN when you have successfully installed ${cyan}Docker for Mac${blue}...${reset}"
	echo ""
fi

# Kill Docker if started, so it doesn't create files during the process
pkill Docker

# Ask to reset destination if it already exists
if [ -d "$docker_destination" ]; then
	read -n1 -p "${blue}Folder ${cyan}$docker_destination${blue} already exists, do you want to reset it? [y/${cyan}N${blue}]${reset} " input
	echo ""
	if [ -n "$input" ] && [ "$input" = "y" ]; then
		rm -rf "$docker_destination"/{com.docker.{docker,helper},.docker} &>/dev/null ;:
	fi
fi

# Unlinks all symlinks, if they are
unlink ~/Library/Containers/com.docker.docker &>/dev/null ;:
unlink ~/Library/Containers/com.docker.helper &>/dev/null ;:
unlink ~/.docker &>/dev/null ;:

# Delete directories if they were not symlinks
rm -rf ~/Library/Containers/com.docker.{docker,helper} ~/.docker &>/dev/null ;:

# Create destination directories in case they don't already exist
mkdir -p "$docker_destination"/{com.docker.{docker,helper},.docker}

# Make symlinks
ln -sf "$docker_destination"/com.docker.docker ~/Library/Containers/com.docker.docker
ln -sf "$docker_destination"/com.docker.helper ~/Library/Containers/com.docker.helper
ln -sf "$docker_destination"/.docker ~/.docker

# Start Docker for Mac
open -g -a Docker

echo "${cyan}Docker${blue} is now starting! Please report any bug to: ${cyan}aguiot--${reset}"
