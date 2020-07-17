#!/bin/bash
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

# the item absolute path,actual path will be prefix join item file name
prefix="/www/project"
item1="item1"
item2="item2"
item3="item3"

# the file user and group
user="_www"
group="_www"

# branch name
branchArr=(
    dev
    prepub
    master
)


itemArr=(
    $item1
    $item2
    $item3
)

gitExec(){
    sudo git fetch -p
    for i in ${branchArr[@]}
        do
            echo -e "\033[32m Switched to branch\033[0m \033[31m $i \033[0m \033[32m start pull...\033[0m"
            sudo git checkout $i
            sudo git pull
        done
    
}

updatePermission(){
    sudo chown -R $user":"$group $1
    sudo chmod -R o+w $1
}

codePull(){
    echo -e "\033[32m start code pull... \033[0m"
    echo "|------------------|"
    echo -e "\033[32m item : \033[0m \033[31m $1 \033[0m"
    echo "|------------------|"
    cd $1
    gitExec
    echo -e "\033[32m item \033[0m  \033[31m $1 \033[0m \033[32m end... \033[0m"

    echo -e "\033[32m start update file permission... \033[0m"
    echo "|-------------------------------|"
    updatePermission $1
}   

if [ ${#itemArr[@]} == 0 ];
then
    echo -e "\033[31m there no items neet to ge updated \033[0m"
else
    for i in ${itemArr[@]}
        do
            if [ ! -d "$prefix$i" ];
            then
                echo $prefix$i ": No such file or directory"
            else
                codePull $prefix$i
            fi
        done
fi

