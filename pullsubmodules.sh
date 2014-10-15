#!/bin/bash
# You may not want to do this if you have working dir changes
git submodule foreach -q --recursive 'branch="$(git config -f $toplevel/.gitmodules submodule.$name.branch)"; git checkout $branch; git pull origin $branch'
