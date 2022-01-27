#!/bin/sh

set -e

SOURCE_REPO=$1
DESTINATION_REPO=$2
SOURCE_DIR=$(basename "$SOURCE_REPO")
DRY_RUN=$3

GIT_SSH_COMMAND="ssh -v"

echo "SOURCE=$SOURCE_REPO"
echo "DESTINATION=$DESTINATION_REPO"
echo "DRY RUN=$DRY_RUN"

mkdir Temp
cd Temp
origin_fail_count=1
while ! git clone $SOURCE_REPO Origin; do
    [ $origin_fail_count -ge 20 ] && echo "Git Clone Origin Failed!" && exit 1 || let origin_fail_count++
    sleep 1
done

target_fail_count=1
while ! git clone $DESTINATION_REPO Target; do
    [ $target_fail_count -ge 20 ] && echo "Git Clone Target Failed!" && exit 1 || let target_fail_count++
    sleep 1
done

cd Origin
rm -rf .git
rm -rf .github
cd ..
cp -rf Origin/ Target/


cd Target
git config --global user.name "fangxx3863"
git config --global user.email fang82099599@gmail.com
git add .
git commit -m "Auto Update"
git push origin master
echo "Finish!"
