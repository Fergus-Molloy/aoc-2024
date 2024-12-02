#!/usr/bin/env bash

# More safety, by turning some bugs into errors.
set -o errexit -o pipefail -o noclobber -o nounset

# ignore errexit with `&& true`
getopt --test > /dev/null && true
if [[ $? -ne 4 ]]; then
    echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
fi

# option --output/-o requires 1 argument
LONGOPTS=output:,day:,year:,cookie:
OPTIONS=o:d:y:c:

# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
# -if getopt fails, it complains itself to stdout
PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@") || exit 2
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

# setup default values
day=$(date "+%_d" | sed 's/ //') # trim off leading space if day is 1-9
year=$(date "+%Y")
output=""
cookie=""

while true; do
    case "$1" in
        -c|--cookie)
            cookie="$2"
            shift 2
            ;;
        -d|--day)
            day="$2"
            shift 2
            ;;
        -y|--year)
            year="$2"
            shift 2
            ;;
        -o|--output)
            output="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

# try really hard to find a cookie if one hasn't already been given
if [[ -z $cookie ]]; then

    # look for a file containing the cookie
    if [[ -f ./.cookie ]]; then
        cookie=$(cat ./.cookie)

    # look for an env var containing the cookie
    elif [ -z ${COOKIE+x} ]; then
        # no cookie env is set
        echo "$0: A cookie is required to fetch your input"
        exit 4
    else
        cookie=$COOKIE
    fi
fi

# if output is not given use this default
if [[ -z $output ]]; then
    output="./inputs/$day"
fi

FULL_URL="https://adventofcode.com/$year/day/$day/input"


echo "Downloading input for day $day year $year to $output"

if [[ -f $output ]]; then
    echo "input file detected, overwriting..."
    rm -v $output
fi

curl -H "Cookie:session=$cookie" $FULL_URL -o "$output"
