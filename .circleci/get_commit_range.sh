#!/usr/bin/env bash
# Check CIRCLE_COMPARE_URL first and if its not set, check for diff with master.

source $BASH_ENV
echo "BRANCH=$BRANCH"

echo_blue "checking CIRCLE_COMPARE_URL":
echo_blue "=== $CIRCLE_COMPARE_URL"

if [[ ! -z "$CIRCLE_COMPARE_URL" ]]; then
    # CIRCLE_COMPARE_URL is not empty, use it to get the diff
    if [[ $CIRCLE_COMPARE_URL = *"commit"* ]]; then
        COMMIT_RANGE=$(echo $CIRCLE_COMPARE_URL | sed 's:^.*/commit/::g')~1
    else
        COMMIT_RANGE=$(echo $CIRCLE_COMPARE_URL | sed 's:^.*/compare/::g')
    fi
    echo_blue "Diff: $COMMIT_RANGE"
    changes="$(git diff $COMMIT_RANGE --name-only)"
else
    # CIRCLE_COMPARE_URL is not set, diff with origin/HEAD
    COMMIT_RANGE=$CIRCLE_SHA1..$CIRCLE_SHA1
    echo_blue "Diff: $CIRCLE_SHA1"
    changes="$(git diff-tree --no-commit-id --name-only -r $CIRCLE_SHA1)"
fi

echo_blue "Changes in this build:"
echo_blue $changes
echo
# Return commit range
echo 'export COMMIT_RANGE=$COMMIT_RANGE' >> $BASH_ENV
export COMMIT_RANGE=$COMMIT_RANGE

