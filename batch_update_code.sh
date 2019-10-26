#!/bin/bash
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

item1="/var/www/project/item1"
item2="/var/www/project/item2"
item3="/var/www/project/item3"

itemArr=(
    $item1
    $item2
    $item3
)
#itemArr=()

gitExec(){
    sudo git fetch -p
    sudo git checkout master
    sudo git pull
    sudo git checkout test
    sudo git pull
    sudo git checkout develop
    sudo git pull
}

codePull(){
    echo "start code pull..."
    echo "item : $1"
    cd $1
    #gitExec
    echo "item $1 end..."
}   

if [ ${#itemArr[@]} == 0 ];
then
    echo "there no items neet to ge updated"
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

