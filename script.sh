# /bin/bash

# description
# create user and assing a group to it
echo "Enter username"
read username

echo "Enter Group Name"
read group_name

# check if the scirpt is executed as root user
if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    echo "Please execute the script as root user"
    exit 0
fi

# check if the user already exists
if [[ "$(getent passwd $username)" ]]; then
    echo "A user with this name already exists"
    exit 0
else
    echo "adding user $username"
    useradd -m $username
fi

# if group does not exists then create it
if [[ $(getent group $group_name) ]]; then
    echo "$group_name already exists.."
else
    echo "creating group $group_name"
    groupadd $group_name
fi

# check if the user is not already in the group then add it
if [[ $(id -Gn $username) =~ "$group_name" ]]; then
    echo "the user $username is already in the $group_name"
else
    echo "adding $username to $group_name"
    usermod -a -G $group_name $username
fi
echo "exiting...."
