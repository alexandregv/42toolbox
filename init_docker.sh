#!/bin/bash
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init_docker.sh                                     :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: aguiot-- <aguiot--@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/11/18 08:17:08 by aguiot--          #+#    #+#              #
#    Updated: 2019/11/20 10:24:38 by aguiot--         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# https://github.com/alexandregv/42toolbox

# Ensure USER variabe is set
[ -z "${USER}" ] && export USER=`whoami`

################################################################################

# Config
docker_destination="/goinfre/$USER/docker" #=> Select docker destination (goinfre is a good choice)

################################################################################

# Uninstall docker, docker-compose and docker-machine if they are installed with brew
brew uninstall -f docker docker-compose docker-machine ;:

# Check if Docker is installed with MSC and open MSC if not
if [ ! -d "/Applications/Docker.app" ] && [ ! -d "~/Applications/Docker.app" ]; then
	echo $'\033[0;34m'Please install $'\033[1;96m'Docker for Mac $'\033[0;34m'from the MSC \(Managed Software Center\)$'\033[0;39m'
	open -a "Managed Software Center"
	read -p $'\033[0;34m'Press\ RETURN\ when\ you\ have\ successfully\ installed\ $'\033[1;96m'Docker\ for\ Mac$'\033[0;34m'...$'\033[0;39m'
fi

function rm_and_link() {
	rm -rf ~/Library/Containers/com.docker.docker ~/.docker
	mkdir -p $docker_destination/{com.docker.docker,.docker}
	ln -sf $docker_destination/com.docker.docker ~/Library/Containers/com.docker.docker
	ln -sf $docker_destination/.docker ~/.docker
}

# Kill Docker if started
pkill Docker

# Create needed files in destination and make symlinks
if [ -d $docker_destination ]; then
	read -p $'\033[0;34m'Folder\ $'\033[1;96m'$docker_destination$'\033[0;34m'\ already\ exists,\ \d\o\ you\ want\ to\ reset\ it?\ [y/$'\033[1;96m'N$'\033[0;34m']$'\033[0;39m'\  input
	if [ -n "$input" ] && [ "$input" = "y" ]; then
		rm_and_link
	fi
else
	rm_and_link
fi

# Start Docker for Mac
open -g -a Docker
echo $'\033[1;96m'Docker$'\033[0;34m' is now starting\! Please report any bug to: $'\033[1m'aguiot--$'\033[0;39m'
