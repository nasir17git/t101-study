#!/bin/bash

if [[ $(cat ./full.txt) =~ "Plan: " ]]; then
  export RESULT=$(sed -n '/Plan:/p' full.txt)
  echo $RESULT
else 
  export RESULT=$(cat full.txt | grep "No changes." | cut -d "." -f1)
  echo $RESULT
fi