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
# max process
MAX_JOBS=5
# the file user and group
user="www"
group="staff"

# branch name
branchArr=(
    main
    master
    develop
)

function gitPull(){
    sudo git fetch -p
    for i in ${branchArr[@]}
        do
            echo -e "${GREEN} Switched to branch${END} ${RED} $i ${END} \033[32m start pull...${END}"
            sudo git checkout $i
            sudo git pull
        done
    
}

function updatePermission(){
    sudo chown -R $user":"$group $1
    sudo chmod -R o+w $1
}

function codePull(){
    echo -e "${GREEN} start code pull... ${END}"
    echo "|------------------|"
    echo -e "${GREEN} item : ${END} ${RED} $1 ${END}"
    echo "|------------------|"
    cd $1
    gitPull
    echo -e "${GREEN} item ${END}  ${RED} $1 ${END} ${GREEN} end... ${END}"

    echo -e "${GREEN} start update file permission... ${END}"
    echo "|-------------------------------|"
    updatePermission $1
    cd $CUR_FOLDER
}   

function codePullMultiProcess(){
    local jobList=()
    # the first parmam is env config
    # if env param=remote,will be set remote url
    for dir in `ls .`
    do 
        if [ -d $dir ]
        then
            echo -e "${SKYEBLUE}${dir}${END}"
            # 并行执行
            # $! 代表最后一个进程id
            codePull $CUR_FOLDER"/"$dir $dir &
            jobList+=($!)
            # 控制最大并发数近一个后进程的id
            if [ ${#jobList[@]} -ge $MAX_JOBS ];then 
                waitingProcess
                jobList=()
            fi
            # 修改配s置
            # set_config $CUR_FOLDER"/"$dir
            # 设置remote url
            #  set_url $dir
        fi
    done
    # waiting other process
    waitingProcess
}

function waitingProcess() {
    for j in "${job_list[@]}";do 
        wait "$j" || echo "process $j failed"
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

codePullMultiProcess