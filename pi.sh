#!/bin/bash
 
# Synopsis : A simple bash script to install packages for web dev at work

# -> Package selection by Paulson P.S
# -> This is a shitty script, that for the time being gets shit done.
#	 there will be an update to this :)

DEBS_DIR="./debs"
MAIN_DIR="$PWD"

printBanner() {
	echo "
╺┳┓┏━╸╻ ╻┏━┓┏━┓┏━╸╻┏    ╻┏┓╻┏━┓╺┳╸┏━┓╻  ╻  ┏━╸┏━┓
 ┃┃┣╸ ┃┏┛┣━┛┣━┫┃  ┣┻┓   ┃┃┗┫┗━┓ ┃ ┣━┫┃  ┃  ┣╸ ┣┳┛
╺┻┛┗━╸┗┛ ╹  ╹ ╹┗━╸╹ ╹   ╹╹ ╹┗━┛ ╹ ╹ ╹┗━╸┗━╸┗━╸╹┗╸

 - This script will install a few packages needed to make your ubuntu system kickass - 
 - keep your admin password ready
"
}

# https://stackoverflow.com/questions/17291233/how-to-check-internet-access-using-bash-script-in-linux
net_ok=0
checkNet() {
	echo -n " 1/7 Checking for internet connectivity ... "
	wget -q --tries=10 --timeout=20 --spider http://google.co.in
	if [[ $? -eq 0 ]]; then
	    net_ok=1
		echo "[ok]"
	fi
}

## Start of script

printBanner
checkNet
if [ $net_ok -eq 0 ]
	then
	echo "[error]"
	echo " * no internet :("
	exit 1
fi

echo
read -p " - Shall we continue? (y/n) " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Nn]$ ]]
then
    echo "exiting script ..."
    exit
fi


clear
echo " 2/7 Updating ubuntu repo cache ... "
sudo apt update

clear
echo " 3/7 Installing dev-tools ... "
sudo apt install git-core git vim tmux htop

clear
if [ ! -d $DEBS_DIR ]
	then
	echo -n " -> making a directory for downloads ... "
	mkdir $DEBS_DIR
	echo "[ok]"
fi
cd $DEBS_DIR
echo " 4/7 Downloading vs-code, sublime-text and google-chrome ... "
echo " -> VS Code - Sweet editor for all things TypeScript"
wget "https://az764295.vo.msecnd.net/stable/19222cdc84ce72202478ba1cec5cb557b71163de/code_1.12.2-1494422229_amd64.deb"
echo " -> Google Chrome - Everything else is a shadow"
wget "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
echo " -> Sublime Text - The editor of a life time"
wget "https://download.sublimetext.com/sublime-text_build-3126_amd64.deb"

clear
echo " 5/7 Installing vs-code, sublime-text and google-chrome ... "
sudo dpkg -i *.deb
# if we failed to install the debs, fix that by installing missing deps
if [[ $? -ne 0 ]]; then
	echo "[warning] .debs installation met errors, trying a hack to fix this ... "
    sudo apt install -f
fi
cd $MAIN_DIR

clear
echo " 6/7 Installing nodejs ... "
sudo apt-get install python-software-properties
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -

clear
echo " 7/7 Installing angularjs ... "
sudo npm install -g "@angular/cli" # @ causing problems

## End of script

echo
echo
echo " - Package installation complete "
echo 

exit
