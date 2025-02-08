#!/bin/bash

## Supported OS Check (Ubuntu Only)
OS=$(lsb_release -is 2>/dev/null)
if [[ "$OS" != "Ubuntu" ]]; then
    echo -e "\e[1;31mThis script only supports Ubuntu 20.04 / 22.04\e[0m"
    exit 1
fi

## Fetch Git Repository URL from a File
REPO_URL_FILE="/tmp/repo_url.txt"
if [[ ! -f "$REPO_URL_FILE" ]]; then
    echo "https://github.com/itsp-technology/autolabsoft.git" > "$REPO_URL_FILE"
fi
REPO_URL=$(cat "$REPO_URL_FILE")

echo -e "\n\e[1;33m You can find all the scripts in the following location:\e[0m\n$REPO_URL\n"

## Clone or Update Lab Automation Repository
if [ -d /tmp/labautomation ]; then
    cd /tmp/labautomation
    git stash &>/dev/null
    git pull &>/dev/null
else
    git clone "$REPO_URL" /tmp/labautomation &>/dev/null
fi

## Display the Menu for Tool Selection
if [ -z "$1" ]; then
    echo -e "\e[1;33m>>>>> Select a TOOL to Install\e[0m"
    ls -1 /tmp/labautomation/tools | cat -n
    echo -e "💡\e[1m You can choose number or tool name\e[0m"
    read -p 'Select Tool> ' tool

    TOOL_NAME_FROM_NUMBER=$(ls -1 /tmp/labautomation/tools | cat -n | grep -w "$tool" | awk '{print $NF}')
    if [[ ! -f "/tmp/labautomation/tools/$tool/install.sh" && -z "$TOOL_NAME_FROM_NUMBER" ]]; then
        echo -e "\e[1;31m Given Tool Not Found \e[0m"
        exit 1
    fi
    tool=${TOOL_NAME_FROM_NUMBER}
else
    tool=$1
fi

SCRIPT_COUNT=$(ls /tmp/labautomation/tools/$tool/*.sh 2>/dev/null | wc -l)
case $SCRIPT_COUNT in
    1)
        echo -e "\e[1;33m★★★ Installing $tool ★★★\e[0m"
        bash /tmp/labautomation/tools/$tool/install.sh
        ;;
    *)
        echo -e "\e[31m Found Multiple Scripts, Choose One.. "
        select script in $(ls -1 /tmp/labautomation/tools/$tool/*.sh | awk -F / '{print $NF}'); do
            echo -e "\e[1;33m★★★ Installing $tool ★★★\e[0m"
            bash "/tmp/labautomation/tools/$tool/$script"
            break
        done
        ;;
esac
