#!/usr/bin/env bash
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    free_space.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: aguiot-- <aguiot--@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/11/24 12:13:59 by aguiot--          #+#    #+#              #
#    Updated: 2019/11/24 13:25:28 by aguiot--         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Colors
blue=$'\033[0;34m'
cyan=$'\033[1;96m'
reset=$'\033[0;39m'

# Avoid boring prefix in du/df/etc
cd $HOME

initial_used_space=$(df -h $HOME | grep -v 'Filesystem' | awk '{ printf("%f", $3) }')

# Show current used space
initial_df=$(df -h . | grep --color=always -E "Size|Used|Avail|Capacity|[0-9]*\.*[0-9]*Mi|[0-9]*\.*[0-9]*Gi|[0-9]+\.*[0-9]+% |$")
echo -e "${blue}Current space:\n${reset}${initial_df}${reset}"
echo -e "${blue}\nHome folder:${reset}"
du -hd1 . 2>/dev/null | sort -h | grep --color=always "[0-9]*\.*[0-9]*M\t\|[0-9]*\.*[0-9]*G\t\|$"
echo ""

function delete() {
	read -n1 -p "${blue}Delete ${cyan}$1${blue} ? [y/${cyan}N${blue}]${reset} " input
	echo ""
	if [ -n "$input" ] && [ "$input" = "y" ]; then
		rm -rf $1
	fi
}

# Delete heavy files/folders
delete "./.cache/*"
delete "./Library/Caches/*"
delete "./Library/Containers/com.docker.docker/*"
delete "./Library/Containers/*"
delete "./Downloads/*"

# Brew cleanup
read -n1 -p "${blue}Cleanup Homebrew? (${cyan}brew cleanup${blue}) [y/${cyan}N${blue}]${reset} " input
echo ""
if [ -n "$input" ] && [ "$input" = "y" ]; then
	brew cleanup ;:
fi

# Show before/after
echo -e "${blue}\nSpace before:\n${reset}${initial_df}${blue}\n\nSpace after:${reset}"
df -h . | grep --color=always -E "Size|Used|Avail|Capacity|[0-9]*\.*[0-9]*Mi|[0-9]*\.*[0-9]*Gi|[0-9]+\.*[0-9]+% |$"

final_used_space=$(df -h $HOME | grep -v 'Filesystem' | awk '{ printf("%f", $3) }')
freed_space=$(printf "%.1f" $(echo -e "${initial_used_space} - ${final_used_space}" | bc))
echo -e "${blue}\nFreed space: ${cyan}${freed_space}Gi${reset}"
echo -e "${blue}Pro tip: use ${cyan}GrandPerspective${blue} (GUI, available in the MSC) or ${cyan}ncdu${blue} (terminal, available with brew) to show a deep scan of your space.${reset}"
