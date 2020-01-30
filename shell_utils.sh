# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    shell_utils.sh                                     :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: aguiot-- <aguiot--@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/11/29 17:03:39 by aguiot--          #+#    #+#              #
#    Updated: 2020/01/30 18:59:24 by aguiot--         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

################################################################################

# Valgrind in docker with custom compilation command
# Usage: valgrind_docker_custom "make re" "./ft_ls -l /tmp ~"
function valgrind_docker_custom () {
	docker run -it --rm --workdir $HOME --entrypoint sh -v $PWD:$HOME mooreryan/valgrind -c "$1 && valgrind --leak-check=full --track-origins=yes --show-leak-kinds=all --show-reachable=yes $2"
}

# Valgrind in docker with default make
# Usage: valgrind_docker_make ./ft_ls -l /tmp ~
function valgrind_docker_make () {
	valgrind_docker_custom "make" "$*"
}

# Valgrind on macOS with fsanitize protection
# Usage: valgrind_macos ./ft_ls -l /tmp ~
# You must use "./" to specify executable file
function valgrind_macos ()
{
	for i in "$@"; do
		if [[ $i == ./* ]]; then
			cmd=$(nm -an $i | grep asan)
			if [[ $? == 0 ]]; then
				echo -e "\033[0;91mYou are trying to run valgrind but you compiled with -fsanitize. \033[1;31mNEVER do this on macOS\033[0;91m, this will crash you computer.\033[0;39m"
			else
				command valgrind $*
			fi
			break
		fi
	done
}

# Default alias on valgrind_macos
alias valgrind='valgrind_macos'

################################################################################
