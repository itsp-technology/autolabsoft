#!/bin/bash

## Colors
R="\e[31m"
B="\e[34m"
Y="\e[33m"
G="\e[32m"
BU="\e[1;4m"
BD="\e[1m"
BLU="\e[1;34m"
U="\e[4m"
IU="\e[7m"
LU="\e[2m"
N="\e[0m"

## Detect OS
OS=$(lsb_release -is 2>/dev/null)
OS_VERSION=$(lsb_release -rs 2>/dev/null)

if [[ "$OS" != "Ubuntu" ]]; then
    echo -e "${R}This script only supports Ubuntu 20.04 / 22.04${N}"
    exit 1
fi

## Common Functions

### Print Functions
hint() {
	echo -e "➜  Hint: $1$N"
}
export -f hint

info() {
	echo -e " $1$N"
}
export -f info

warning() {
	echo -e "${Y}☑  $1$N "
}
export -f warning

success() {
	echo -e "${G}✓  $1$N"
}
export -f success

error() {
	echo -e "${R}✗  $1$N"
}
export -f error

head_bu() {
	echo -e "  $BU$1$N\n"
}
export -f head_bu

### Check if User is Root
CheckRoot() {
    if [ "$(id -u)" -ne 0 ]; then
        error "You must be a root user to perform this command.."
        exit 1
    fi
}
export -f CheckRoot

### Disable Firewall (for Ubuntu)
CheckFirewall() {
    sudo ufw disable &>/dev/null
    success "Disabled FIREWALL Successfully"
}
export -f CheckFirewall

### Install Java (for Ubuntu)
DownloadJava() {
    if java -version &>/dev/null; then
        success "Java is already installed."
        return
    fi

    sudo apt update -y
    sudo apt install -y openjdk-11-jdk

    if java -version &>/dev/null; then
        success "Java installed successfully."
    else
        error "Java installation failed!"
        exit 1
    fi
}
export -f DownloadJava

### Enable EPEL (Not Needed for Ubuntu, but placeholder)
EnableEPEL() {
    success "EPEL is not required on Ubuntu."
}
export -f EnableEPEL

### Add Docker Repository for Ubuntu
DockerCERepo() {
    sudo apt update -y
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt update -y
    success "Enabled Docker CE Repository Successfully"
}
export -f DockerCERepo

### Print Status
Stat() {
    if [ "$1" -eq 0 ]; then
        success "$2"
    elif [ "$1" == "SKIP" ]; then
        warning "$2"
    else
        error "$2"
        exit 1
    fi
}
export -f Stat

### Print a Centered Message
PrintCenter() {
    TEXT=$1
    IFS=$','
    length=0
    for title in $TEXT; do
        l=${#title}
        if [ $length -lt $l ]; then
            length=$l
        fi
    done
    length=$((length + 4))
    header=$(printf '%*s\n' "$length" | tr ' ' '*')

    COLUMNS=$(tput cols)
    printf "%*s\n" $(((${#header}+$COLUMNS)/2)) "$header"
    for title in $TEXT; do
        printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$title"
    done
    printf "%*s\n" $(((${#header}+$COLUMNS)/2)) "$header"
}
export -f PrintCenter

### Print a Command Before Running
command_print() {
    echo -e "\n\e[0mRunning the following command now.\n"
    echo -e "#️⃣ \e[36m $1 \e[0m"
    echo
}
export -f command_print
