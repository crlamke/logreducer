#!/bin/bash
#Copyright   : 2021 Christopher R Lamke
#Project Home: https://github.com/crlamke/logreducer
#License     : MIT - See https://opensource.org/licenses/MIT

runDTG=$(date +"%Y-%m-%d-%H-%M-%S-%Z")
linesBeforeMatch=2
linesAfterMatch=2

if [[ $# -ne 3 ]]; then
  printf "\nUsage: %s target-file line-removal-pattern line-inclusion-pattern" $0
  printf "\n   Ex: %s ./log.txt \"success\" \"error\"\n" $0
  printf "\nThis script takes a log file as input, removes lines that match a pattern, \n"
  printf "and then creates a new file that includes only lines that match a second pattern\n"
  printf "plus a buffer of lines before and after the matching line.\n"
  printf "The goal is to reduce the lines in a log file to only those relevant for review or troubleshooting.\n\n"
  exit 0
fi

inputFile=$1
exclusionPattern=$2
inclusionPattern=$3

if [ ! -f $1 ]; then
  printf "Target log file $1 not found\n"
  exit 1
fi

origFileLines=$(wc -l <$inputFile)
printf "\n%s has %d lines. Exclusion pattern is \"%s\". Pattern to match is \"%s\"\n" \
  $inputFile $origFileLines $exclusionPattern $inclusionPattern

printf "Numbering file lines ...\n"
numberedFile="$inputFile-numbered.txt"
nl -b a $inputFile >./$numberedFile

strippedFile="$inputFile-stripped.txt"
grep -v $exclusionPattern ./$numberedFile >./$strippedFile
linesAfterExclusion=$(wc -l <./$strippedFile)
linesRemovedByExclusion=$(($origFileLines - $linesAfterExclusion))
printf "Applying exclusion pattern removed %d lines.\n" $linesRemovedByExclusion
strippedFileMatches="$inputFile-reduced-$runDTG"
grep -B $linesBeforeMatch -A $linesAfterMatch $inclusionPattern $strippedFile >./$strippedFileMatches
rm $numberedFile
rm $strippedFile
printf "Match file %s has %d lines.\n" $strippedFileMatches $(wc -l <$strippedFileMatches)

