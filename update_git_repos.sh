#!/bin/bash

# store the current dir
CUR_DIR=$(pwd)

# Let the person running the script know what's going on.
echo ""
echo "Pulling in latest changes for all repositories..."
echo ""

# Find all git repositories and update it to the master latest revision
for i in $(find . -name ".git" -type d | cut -c 3-); do
    echo "";
    # The sed removes the trailing "/.git"
    echo $i | sed 's/.\{5\}$//';

    # We have to go to the .git parent directory to call the pull command
    cd "$i";
    cd ..;

    # finally pull (git fetch + git merge)
    git fetch;
    # this shows a summary of the changes between local and origin, but we can only do this before our local copy is updated
    git cherry -v $(git rev-parse --abbrev-ref HEAD) $(git rev-parse --abbrev-ref --symbolic-full-name @{u});
    # recognize pull.rebase option
    if PULL_REBASE=$(git config --get pull.rebase); then
        if PULL_REBASE="true"; then
            git rebase;
        else
            git merge;
        fi
    else
        git merge;
    fi

    # lets get back to the CUR_DIR
    cd $CUR_DIR
done

echo ""
echo "Complete!"
echo ""
