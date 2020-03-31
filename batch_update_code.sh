#!/bin/bash
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

item1="/var/www/project/item1"
item2="/var/www/project/item2"
item3="/var/www/project/item3"

# user and group
user="www"
group="www"

itemArr=(
    $item1
    $item2
    $item3
)

gitExec(){
    sudo git fetch -p
    sudo git checkout master
    sudo git pull
    sudo git checkout test
    sudo git pull
    sudo git checkout develop
    sudo git pull
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
           if [ ! -d "$i" ];
           then
               echo $i ": No such file or directory"
           else
               codePull $i
           fi
         done
fi
