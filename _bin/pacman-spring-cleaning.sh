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
ignore_file=~/.spring_ignore.txt
[ -f "$ignore_file" ] || touch "$ignore_file"

packages_to_file $packages_file

echo -e "Total number of packages:  $(pacman -Qq  | wc -l)"
echo -e "Official packages:         $(pacman -Qqn | wc -l)"
echo -e "AUR/misc packages:         $(pacman -Qqm | wc -l)\n"

if [ -f $previous_file ]; then
    deleted=$(comm -13 $packages_file <(cat $previous_file $ignore_file | sort -u))
    [ -n "$deleted" ] && echo -e "Packages deleted since last time:\n$deleted"

    manual_packages=($(comm -23 $packages_file <(cat $previous_file $ignore_file | sort -u)))
    [ -n "$manual_packages" ] && echo -e "\nPackages added since last time:" && printf "%s\n" ${manual_packages[@]}

    if [ -z "$deleted" ] && [ -z "$manual_packages" ]; then
        echo -e "No changes to packages.\nTo spring-clean all packages, delete ${previous_file} and rerun."
        exit 0
    fi
    echo && confirm || exit 0
else
    manual_packages=($(comm -23 <(pacman -Qeq | sort -u)  <(pacman -Qgq base base-devel | cat "$ignore_file" - | sort -u)))
fi

i=0
while [ $i -lt ${#manual_packages[@]} ]; do
    p="${manual_packages[$i]}"
    clear
    echo -e "----- $i / ${#manual_packages[@]} -----"
    pacman -Qi $p | grep -E --color "$p|$"

    echo -e '  [r]emove\n  [b]ack\n  [q]uit\n  always [i]gnore\n  ignore once (default)\n'
    read -r -p '  Enter choice: ' response
    case $response in
        [rR]) sudo pacman -Rsn $p ;;
        [iI]) echo "$p" >> $ignore_file ;;
        [bB]) i=$((i-2)) ;;
        [qQ]) break ;;
    esac
    i=$((i + 1))
done

packages_to_file $previous_file

