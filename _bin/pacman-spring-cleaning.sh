#!/bin/bash

confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Continue? [y/N]} " response
    case "$response" in
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

packages_to_file "$packages_file"

echo "Total packages:    $(pacman -Qq  | wc -l)"
echo "Official packages: $(pacman -Qqn | wc -l) ($(pacman -Qeqn | wc -l) explicitly installed)"
echo "AUR/misc packages: $(pacman -Qqm | wc -l)"
echo

if [ -s "$previous_file" ]; then
    deleted_packages=($(comm -13 $packages_file <(cat $previous_file $ignore_file | sort -u)))
    if [ "${#deleted_packages[@]}" -gt 0 ]; then
        echo
        echo '--------------------------------'
        echo "Packages deleted since last time:"
        printf "%s\n" "${deleted_packages[@]}"
        echo
    fi

    manual_packages=($(comm -23 $packages_file <(cat $previous_file $ignore_file | sort -u)))
    if [ "${#manual_packages[@]}" -gt 0 ]; then
        echo
        echo '-------------------------------'
        echo 'Packages added since last time:'
        printf "%s\n" "${manual_packages[@]}"
        echo
    fi

    if [ "${#deleted_packages[@]}" -eq 0 ] && [ "${#manual_packages[@]}" -eq 0 ]; then
        echo "No changes to packages."
        echo "To spring-clean all packages, delete ${previous_file} and rerun."
        exit 0
    fi
else
    manual_packages=($(comm -23 <(pacman -Qeq | sort -u)  <(pacman -Qgq base base-devel | cat "$ignore_file" - | sort -u)))
fi

confirm || exit 0

i=0
while [ $i -lt ${#manual_packages[@]} ]; do
    p="${manual_packages[$i]}"
    clear
    echo -e "----- $i / ${#manual_packages[@]} -----"
    pacman -Qi "$p" | grep -E --color=auto "$p|$"

    echo '  [r]emove'
    echo '  [b]ack'
    echo '  mark as [d]ependency'
    echo '  add to [i]gnore list'
    echo '  [q]uit'
    echo '  skip (Enter)'
    echo

    read -r -p '  Enter choice: ' response
    case "$response" in
        [rR]) sudo pacman -Rsn "$p" ;;
        [bB]) i=$((i-2)) ;;
        [iI]) echo "$p" >> $ignore_file ;;
        [dD])
            echo
            echo "About to run 'pacman -D --asdeps $p'."
            echo "You should only run this if you know what you're doing."
            if confirm "Do you? [y/N] "; then
                sudo pacman -D --asdeps "$p"
                echo
                read -r -p 'Press any key to continue'
            fi
            ;;
        [qQ]) break ;;
    esac
    i=$((i + 1))
done

echo
echo "The following packages are marked as dependecy-installs,"
echo "but aren't required by any package:"
sudo pacman -Rsn $(pacman -Qdtq)

packages_to_file "$previous_file"

