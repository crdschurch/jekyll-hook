#!/bin/bash

set -e

# This script is meant to be run automatically
# as part of the jekyll-hook application.
# https://github.com/developmentseed/jekyll-hook

repo=$1
branch=$2
owner=$3
giturl=$4
source=$5
giturlhttps=$6
build=$7
aa=$8

if [ -d "./scripts/temp" ]; then
 echo " Temp directory exists hence deleting it " 
 rm -rf ./scripts/temp/
fi

mkdir ./scripts/tempfors3
cd ./scripts/tempfors3/

git clone $giturlhttps
cd $1

files=$(shopt -s nullglob; echo app/img/*)

if (( ${#files} ))
then
  echo "contains some new files need to move to S3"
  aws s3 cp app/img/ s3://crossroads-media/images/ --recursive --acl public-read
  cd app/img/
  rm app/img/*.*
  git commit -m "Webhook removed images to S3" app/img/
  git push origin master
else
  echo "Files are empty so we dont need to do any thing"
fi

cd -
