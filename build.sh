#!/bin/sh
COLOR=yellow
# -e: Stop on error
# -u: Raise error on unknown variable interpolation
set -eo pipefail

DEBUG=TRUE
RELEASE=FALSE
DEPLOY=FALSE

function usage()
{
    echo "FUNCSS build Script"
    echo ""
    echo "./build.sh"
    echo "\t-h --help"
    echo "\t--debug [default=true]"
    echo "\t--release [default=false]"
    echo "\t--deploy [default=false]"
    echo ""
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --debug)
            DEBUG=TRUE
            ;;
        --release)
            RELEASE=TRUE
            DEBUG=FALSE
            ;;
        --deploy)
			RELEASE=TRUE
            DEPLOY=TRUE
            DEBUG=FALSE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

printf '\033[1;95m \033[5mFeeling \033[4mSassy\033[0m?\n\n'

# i=1
# sp="/-\|"
# echo -n ' '
until sass css/_all.scss:styles.css
do
	printf "\033[10mAAAA"
done
printf "\033[106;30m                                          \n"
printf "\033[106;30m ▄▄▄▄· ▄• ▄▌.▄▄ ·     ▄▄·       • ▌ ▄ ·.  \n"
printf "\033[106;30m ▐█ ▀█▪█▪██▌▐█ ▀.    ▐█ ▌▪▪     ·██ ▐███▪ \n"
printf "\033[106;30m ▐█▀▀█▄█▌▐█▌▄▀▀▀█▄   ██ ▄▄ ▄█▀▄ ▐█ ▌▐▌▐█· \n"
printf "\033[106;30m ██▄▪▐█▐█▄█▌▐█▄▪▐█   ▐███▌▐█▌.▐▌██ ██▌▐█▌ \n"
printf "\033[106;30m ·▀▀▀▀  ▀▀▀  ▀▀▀▀  ▀ ·▀▀▀  ▀█▄▀▪▀▀  █▪▀▀▀ \n"
printf "\033[106;30m                                          \n"
printf "\033[106;30m      styles.css has been compiled        \n"

if [ DEBUG == TRUE ]; then
	open index.html
fi


