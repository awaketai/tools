#!/bin/bash
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa
BLACK="\033[30m " 
RED="\033[31m " 
GREEN="\033[32m "
YELLOW="\033[33m "
BLUE="\033[34m "
VIOLET="\033[35m " 
SKYEBLUE="\033[36m " 
WHITE="\033[37m " 
END=" \033[0m"

CUR_FOLDER=$(dirname $(readlink -f "$0"))
# the file user and group
user="www"
group="staff"

# branch name
branchArr=(
    main
    master
    develop
)

gitExec(){
    sudo git fetch -p
    for i in ${branchArr[@]}
        do
            echo -e "${GREEN} Switched to branch${END} ${RED} $i ${END} \033[32m start pull...${END}"
            sudo git checkout $i
            sudo git pull
        done
    
}

updatePermission(){
    sudo chown -R $user":"$group $1
    sudo chmod -R o+w $1
}

codePull(){
    echo -e "${GREEN} start code pull... ${END}"
    echo "|------------------|"
    echo -e "${GREEN} item : ${END} ${RED} $1 ${END}"
    echo "|------------------|"
    cd $1
    gitExec
    echo -e "${GREEN} item ${END}  ${RED} $1 ${END} ${GREEN} end... ${END}"

    echo -e "${GREEN} start update file permission... ${END}"
    echo "|-------------------------------|"
    updatePermission $1
    cd $CUR_FOLDER
}   

function readDir(){
    for dir in `ls .`
    do 
        if [ -d $dir ]
        then
            echo -e "${SKYEBLUE}${dir}${END}"
            codePull $CUR_FOLDER"/"$dir 
        fi
    done
}

urlLocal="http://127.0.0.1/"
urlProjLocal="http://127.0.0.1/proj/"
urlRemote=""
function setUrl(){
    cd $CUR_FOLDER"/"$1
    # git remote set-url origin 
    if [ $1 == "deploy" ];then
        urlRemote="${urlProjLocal}$1.git"
    else
        urlRemote="${urlLocal}$1.git"
    fi
    git remote set-url origin ${urlRemote}
    cd $CUR_FOLDER
}

function setConfig() {
    cd $1
    git config user.name username
    git config user.email useremail
    cd $CUR_FOLDER
}

# if [ ${#itemArr[@]} == 0 ];
# then
#     echo -e "\033[31m there no items neet to ge updated \033[0m"
# else
#     for i in ${itemArr[@]}
#         do
#             if [ ! -d "$prefix$i" ];
#             then
#                 echo $prefix$i ": No such file or directory"
#             else
#                 codePull $prefix$i
#             fi
#         done
# fi

readDir