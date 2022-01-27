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
rm update

cd ONywPfH3Rh
FILE=pWgXrfGEV6Vtmhy
SIZE=12000
# 数据总条数, 去掉wc前面的空格
ROWS=`cat $FILE | wc -l | sed 's/ //g'`
# 向下取整数(floor)
FLOOR=$(( $ROWS/$SIZE  ))
# 向上取整数(ceil)
CEIL=`echo "if ( $ROWS%$SIZE  ) $ROWS/$SIZE+1 else $ROWS/$SIZE" | bc`
# 文件名前缀
FILE_PREFIX=${FILE%.*}
echo "file:$FILE prefix:$FILE_PREFIX size:$SIZE rows:$ROWS FLOOR:$FLOOR CEIL:$CEIL"
# 先按整除的迭代
for i in `seq 1 $FLOOR`; do
    LOAD_CNT=$((i*$SIZE))
    echo "head -$LOAD_CNT $FILE | tail -$SIZE > ${FILE_PREFIX}_$i.part1"
    # execute split file
    head -$LOAD_CNT $FILE | tail -$SIZE > ${FILE_PREFIX}_$i.part1
done
# 如果最后还有余数
if [[ $FLOOR != $CEIL ]]; then
    LEFT_ROWS=$(( $ROWS - $FLOOR*$SIZE ))
    echo "tail -$LEFT_ROWS $FILE > ${FILE_PREFIX}_$CEIL.part1"
    tail -$LEFT_ROWS $FILE > ${FILE_PREFIX}_$CEIL.part1
fi

FILE=AlCdr6hj5qHCJmp
SIZE=12000
# 数据总条数, 去掉wc前面的空格
ROWS=`cat $FILE | wc -l | sed 's/ //g'`
# 向下取整数(floor)
FLOOR=$(( $ROWS/$SIZE  ))
# 向上取整数(ceil)
CEIL=`echo "if ( $ROWS%$SIZE  ) $ROWS/$SIZE+1 else $ROWS/$SIZE" | bc`
# 文件名前缀
FILE_PREFIX=${FILE%.*}
echo "file:$FILE prefix:$FILE_PREFIX size:$SIZE rows:$ROWS FLOOR:$FLOOR CEIL:$CEIL"
# 先按整除的迭代
for i in `seq 1 $FLOOR`; do
    LOAD_CNT=$((i*$SIZE))
    echo "head -$LOAD_CNT $FILE | tail -$SIZE > ${FILE_PREFIX}_$i.part1"
    # execute split file
    head -$LOAD_CNT $FILE | tail -$SIZE > ${FILE_PREFIX}_$i.part1
done
# 如果最后还有余数
if [[ $FLOOR != $CEIL ]]; then
    LEFT_ROWS=$(( $ROWS - $FLOOR*$SIZE ))
    echo "tail -$LEFT_ROWS $FILE > ${FILE_PREFIX}_$CEIL.part1"
    tail -$LEFT_ROWS $FILE > ${FILE_PREFIX}_$CEIL.part1
fi
cd ..

cd ..
cp -rf Origin/. Target/


cd Target
git config --global user.name "fangxx3863"
git config --global user.email fang82099599@gmail.com
git add .
git commit -m "Auto Update"
git push origin master
echo "Finish!"
