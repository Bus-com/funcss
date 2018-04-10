#!/bin/sh
# this script assumes you are on macOS
# -e: Stop on error
# -o: ?

set -eo pipefail

DEBUG=true
DEPLOY=false
TAG_NAME=""
OUTPUT_STYLE="expanded"
OUTPUT_PATH="./dist"
OUTPUT_NAME="funcss"

function usage() {
    echo "\033[38;5;87mFUNCSS build Script\033[0m"
    echo ""
    echo "\033[0m./build.sh"
    echo "\033[38;5;13m\t-h --help"
    echo "\033[38;5;166m\t--debug [default=true]"
    echo "\033[38;5;196m\t--deploy [default=false]"
    echo ""
}

# replace with the new tagged name in the index file.
function replace_style_import() {
    sed -i .bak "s/.*<link rel='stylesheet' href='.*'>.*/<link rel='stylesheet' href='$OUTPUT_NAME'>/g" index.html
    #not sure why; does not work without .bak syntax
    rm index.html.bak
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
            DEBUG=true
            DEPLOY=false
            OUTPUT_STYLE="expanded"
            ;;
        # --release)
        #     RELEASE=true
        #     DEBUG=false
        #     DEPLOY=false
        #     OUTPUT_STYLE="compact" #release mode is in compact mode
        #     ;;
        --deploy)
            DEPLOY=true
            DEBUG=false
            TAG_NAME=$VALUE
            OUTPUT_STYLE="compressed"
            OUTPUT_NAME="funcss-$TAG_NAME"
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

printf "\033[95;5m Feeling         \033[4mSassy\033[0m?\033[0m\n"
printf "\033[106;30m        $OUTPUT_NAME is being compiled      \033[0m\n"

if [ "$DEBUG" = true ]; then
    # replace with the new tagged name in the index file.
    replace_style_import
    # open the demo page
    printf "\033[166;5m             opening index.html           \033[0m\n"
    open index.html
    # Open a new terminal and launch sass --watch
    # open -a terminal -e $PWD ""
    sass --scss --watch css/_all.scss:$OUTPUT_PATH/$OUTPUT_NAME.css --style $OUTPUT_STYLE
else
    sass --scss css/_all.scss:$OUTPUT_PATH/$OUTPUT_NAME.css --style $OUTPUT_STYLE

    printf "\033[166;5m          minifying $OUTPUT_NAME           \033[0m\n"
        
    MIN_OUTPUT_NAME="$PWD$OUTPUT_PATH/$OUTPUT_NAME.min.css"
        
    curl -X POST -s --data-urlencode "input@$PWD$OUTPUT_PATH$OUTPUT_NAME.css" https://cssminifier.com/raw > $MIN_OUTPUT_NAME    
    # replace with the new tagged name in the index file.
    OUTPUT_NAME=MIN_OUTPUT_NAME
    replace_style_import

    if [ "$DEPLOY" = true ]; then
        
        git add dist/*
        git add css/*
        read commitmessage
        git commit dist/* -m "$commitmessage"
        git push
        # printf "\033[106;30m        tag $TAG_NAME has been tagged        \033[0m\n"
        # TODO: phil; find a way to auto inc. tag ?
        # git tag TAG_NAME
        # git push --all
    fi
fi

printf "\033[106;30m                                          \033[0m\n"
printf "\033[106;30m ▄▄▄▄· ▄• ▄▌.▄▄ ·     ▄▄·       • ▌ ▄ ·.  \033[0m\n"
printf "\033[106;30m ▐█ ▀█ █ ██▌▐█ ▀.    ▐█ ▌       ·██ ▐███▪ \033[0m\n"
printf "\033[106;30m ▐█▀▀█▄█▌▐█▌▄▀▀▀█▄   ██ ▄▄ ▄█▀▄ ▐█ ▌▐▌▐█· \033[0m\n"
printf "\033[106;30m ██▄▪▐█▐█▄█▌▐█▄▪▐█   ▐███▌▐█▌.▐▌██ ██▌▐█▌ \033[0m\n"
printf "\033[106;30m ·▀▀▀▀  ▀▀▀  ▀▀▀▀  ▀ ·▀▀▀  ▀█▄▀▪▀▀  █▪▀▀▀ \033[0m\n"
printf "\033[106;30m                                          \033[0m\n"
printf "\033[106;30m      $OUTPUT_NAME has been compiled        \033[0m\n"

