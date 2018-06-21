#!/bin/bash

# store the current dir
CUR_DIR=$(pwd)

# Let the person running the script know what's going on.
echo -e "\n\033[1mPulling in latest changes for all repositories...\033[0m\n"

# Find all git repositories and update it to the master latest revision
for i in $(find . -name ".git" | cut -c 3-); do
    echo -e "";
    # The sed removes the trailing "/.git"
    echo -e "\033[33m"+$(echo $i | sed 's/.\{5\}$//')+"\033[0m";

    # We have to go to the .git parent directory to call the pull command
    cd "$i";
    cd ..;

    # finally pull (git fetch + git merge)
    git fetch;
    # this shows a summary of the changes between local and origin, but we can only do this before our local copy is updated
    git cherry -v $(git rev-parse --abbrev-ref HEAD) $(git rev-parse --abbrev-ref --symbolic-full-name @{u});
    git merge;

    # lets get back to the CUR_DIR
    cd $CUR_DIR
done

echo -e "\n\033[32mComplete!\033[0m\n"
