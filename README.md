# 42toolbox
A bunch of scripts to make your life better at @42School.

⚠️ This has been devloped when 42Paris was still using macOS, which is not the case anymore. Some scripts will only work on macOS and not Linux, or will be useless on Linux.  
For example, `init_docker.sh` is useless on Linux because it's configured by default and `free_space.sh` uses macOS directories.

## Installation
Just `git clone https://github.com/alexandregv/42toolbox.git ~/42toolbox`.  

If you use [shell_utils.sh](#shell_utils), you probably want to source it inside your .zshrc/.bashrc/etc:  
`echo "source ~/42toolbox/shell_utils.sh" >> ~/.zshrc`.  

You can also use the scripts of your choice without cloning the repository. You will have to edit `toolbox_path` in [init_session.sh](https://github.com/alexandregv/42toolbox/blob/master/init_session.sh#L22) if you use it.

### init_session
A script to init your session at 42 when you log in. It can:
- Connect your bluetooth device
- Init SSH (see [init_ssh](#init_ssh))
- Init docker (see [init_docker](#init_docker))
- Check if all your apps are installed and start them
- Update brew and its formulas
- Clean your disk (also check [free_space](#free_space))
- Start [RP42](https://github.com/alexandregv/RP42)
- Open System Preferences (You could need it to edit your keyboard/screen settings, etc)

### init_ssh
A script to create an SSH key pair if needed, then see how to add it on the intra.  
It can copy the public key to your clipboard if supported (macOS or Linux with xsel/xclip) and open the intra settings page automatically.

### init_docker
A script to init Docker for Mac at 42.  
It checks if Docker for Mac is properly installed and makes symlinks to the goinfre to not fill your session disk.

### free_space
A script to free space on your session disk.  
It will show you a summary of your disk, what files take space, and delete them if you ask to.

### shell_utils
This one is a script you should source in your .zshrc/.bashrc/etc.  
It creates nice aliases and functions:
- valgrind_macos : a function to protect valgrind and fsanitize
- valgrind_docker_{make,custom} : two functions to run valgrind (and your program) inside docker. No more false positive with valgrind on macOS

## Stargazers over time
[![Stargazers over time](https://starchart.cc/alexandregv/42toolbox.svg?variant=adaptive)](https://starchart.cc/alexandregv/42toolbox)
