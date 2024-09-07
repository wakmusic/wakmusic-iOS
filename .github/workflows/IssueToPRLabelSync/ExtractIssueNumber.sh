#!/bin/bash

echo "issue_number=$(echo $PR_TITLE | grep -oP '\(#[0-9]+\)' | grep -oP '[0-9]+')"