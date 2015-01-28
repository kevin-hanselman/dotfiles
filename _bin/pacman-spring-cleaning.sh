#!/bin/bash

confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Continue? [y/N]} " response
    case $response in
        [yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}

packages_to_file() {
    comm -23 <(pacman -Qeq|sort) <(pacman -Qgq base base-devel|sort) > "$1"
}

packages_file=~/.spring_current.txt
previous_file=~/.spring_previous.txt

packages_to_file $packages_file

if [ -f $previous_file ]; then
    deleted=$(comm -13 $packages_file $previous_file)
    [ -n "$deleted" ] && echo -e "Packages deleted since last time:\n$deleted"

    manual_packages=($(comm -23 $packages_file $previous_file))
    [ -n "$manual_packages" ] && echo -e "\nPackages added since last time:" && printf "%s\n" ${manual_packages[@]}

    if [ -z "$deleted" ] && [ -z "$manual_packages" ]; then
        echo -e "No changes to packages.\nTo spring-clean all packages, delete ${previous_file} and rerun."
        exit 0
    fi
    echo && confirm || exit 0
else
    manual_packages=($(comm -23 <(pacman -Qeq|sort) <(pacman -Qgq base base-devel|sort)))
fi

i=1
for p in "${manual_packages[@]}"; do
    clear
    echo -e "----- $i / ${#manual_packages[@]} -----"
    pacman -Qi $p | grep -E --color "$p|$"

    read -r -p "[r]emove  -  mark as [d]ependency  -  [q]uit  -  do [n]othing (default) " response
    case $response in
        [rR]) sudo pacman -Rsn $p ;;
        [dD]) confirm "Mark $p as a dependency install? [y/N]" && sudo pacman -D --asdeps $p ;;
        [qQ]) break
    esac
    i=$((i + 1))
done

packages_to_file $previous_file

