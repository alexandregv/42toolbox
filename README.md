# 42toolbox
A bunch of scripts to make your life better at @42School

## init_session
A script to init your session at 42 when you log in. It can:
- Connect your bluetooth device
- Init docker (see [init_docker](#init_docker))
- Check if all your apps are installed and start them
- Update brew and its formulas
- Clean your disk (also check [free_space](#free_space))
- Start [RP42](https://github.com/alexandregv/RP42)
- Open System Preferences (You could need it to edit your keyboard/screen settings, etc)

## init_docker
A script to init Docker for Mac at 42.  
It checks if Docker for Mac is properly installed and makes symlinks to the goinfre to not fill your session disk.

## free_space
A script to free space on your session disk.  
It will show you a summary of your disk, what files take space, and delete them if you ask to.

## shell_utils
This one is a script you should source in your .zshrc/.bashrc/etc.  
It creates nice aliases and functions:
- valgrind_macos : a function to protect valgrind and fsanitize
- valgrind_docker_{make,custom} : two functions to run valgrind (and your program) inside docker. No more false positive with valgrind on macOS

