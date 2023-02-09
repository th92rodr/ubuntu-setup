#!/bin/bash

source ./func.sh

options=("Install and Configure" "Only Configure" "Ignore")

echo -e "\e[34mGIT\e[0m"
select do_git in "${options[@]}"
do
  case $do_git in
    ${options[0]}|${options[1]})
      echo -e "\e[32m$do_git\e[0m"
      fn_git $REPLY
      break
      ;;
    ${options[2]})
      break
      ;;
    *)
      echo -e "\e[31mInvalid option $REPLY\e[0m"
      ;;
  esac
done

exit

############

if [[ $is_git = y ]] ; then
  if [[ $is_git_ok = 1 ]] ; then
    echo -e "\e[34m \nGIT done \e[0m"
  else
    echo -e "\e[34m \nGIT error \e[0m"
  fi
fi

echo -e "\e[32m \n All set \e[0m"
