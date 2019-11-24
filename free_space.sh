#!/bin/sh
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

# Avoid boring prefix in du/df/etc
cd $HOME

initial_used_space=$(df -h $HOME | grep -v 'Filesystem' | awk '{ printf("%f", $3) }')

# Show current used space
initial_df=$(df -h . | grep --color=always -E "Size|Used|Avail|Capacity|[0-9]*\.*[0-9]*Mi|[0-9]*\.*[0-9]*Gi|[0-9]+\.*[0-9]+% |$")
echo $'\033[0;34m'Current space:\\n$'\033[0;39m'"$initial_df"$'\033[0;39m'
echo $'\033[0;34m'\\nHome folder:$'\033[0;39m'
du -hd1 . 2>/dev/null | sort -h | grep --color=always "[0-9]*\.*[0-9]*M\t\|[0-9]*\.*[0-9]*G\t\|$"
echo

function delete() {
	read -p $'\033[0;34m'Delete\ $'\033[1;96m'$1$'\033[0;34m'\ ?\ [y/$'\033[1;96m'N$'\033[0;34m']$'\033[0;39m'\  input
	if [ -n "$input" ] && [ "$input" = "y" ]; then
		rm -rf $1
	fi
}

# Delete heavy files/folders
delete "./.cache"
delete "./Library/Caches"

# Brew cleanup
read -p $'\033[0;34m'Cleanup\ Homebrew?\ \($'\033[1;96m'brew\ cleanup$'\033[0;34m'\)\ [y/$'\033[1;96m'N$'\033[0;34m']$'\033[0;39m'\  input
if [ -n "$input" ] && [ "$input" = "y" ]; then
	brew cleanup ;:
fi

# Show before/after
echo $'\033[0;34m'\\nSpace before:\\n$'\033[0;39m'"$initial_df"$'\033[0;34m'\\n\\nSpace after:$'\033[0;39m'
df -h . | grep --color=always -E "Size|Used|Avail|Capacity|[0-9]*\.*[0-9]*Mi|[0-9]*\.*[0-9]*Gi|[0-9]+\.*[0-9]+% |$"

final_used_space=$(df -h $HOME | grep -v 'Filesystem' | awk '{ printf("%f", $3) }')
freed_space=$(printf "%.1f" $(echo "$initial_used_space - $final_used_space" | bc))
echo $'\033[0;34m'\\nFreed\ space:$'\033[0;39m'\ ${freed_space}Gi
echo $'\033[0;34m'Pro\ tip:\ use $'\033[1;96m'GrandPerspective$'\033[0;34m'\ app\ to\ show\ a\ deep\ scan\ of\ your\ space.\ Available\ in\ the\ $'\033[1;96m'MSC$'\033[0;34m' \(Managed Software Center\).$'\033[0;39m'
