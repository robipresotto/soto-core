#!/bin/sh

set -eux

swift package generate-xcodeproj
jazzy --clean

# stash everything that isn't in docs
git stash push -- ":(exclude)docs"

current_branch=$(git rev-parse --abbrev-ref HEAD)

git checkout gh-pages
# copy contents of docs to docs/current replacing the ones that are already there
rm -rf docs/current
mv docs/ current/
mkdir docs
mv current/ docs/
# commit
git add --all docs
git commit -m "Publish latest docs"
git push
# return to master branch
git checkout $current_branch
git stash pop
