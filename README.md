# logreducer

Usage: logreducer target-file line-removal-pattern line-inclusion-pattern

Example: logreducer ./log.txt "success" "error"

This script takes a log file as input, removes lines that match a pattern, and then creates a new file that includes only lines that match a second pattern plus a buffer of lines before and after the matching line. The goal is to reduce the lines in a log file to only those relevant for review or troubleshooting.
