#!/bin/bash
# Shortcut script to rename scripts and rewrite files with a new JRN data package id
# Change the CURRENT and NEW variables and then run the script to rename files and text

CURRENT='210000000'

NEW='210111111'

#Rename build script
mv build_$CURRENT.R build_$NEW.R

# Replace package id in 2 files with NEW
sed -i .bkp -e "s/$CURRENT/$NEW/g" README.md

sed -i .bkp -e "s/$CURRENT/$NEW/g" build_$NEW.R

# Rename current directory (CAUTION)
#mv ../pkg${CURRENT}_example ../pkg${NEW}_example

