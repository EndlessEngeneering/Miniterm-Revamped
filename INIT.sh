#!/bin/bash
VER="v1.0"
clear
# Color Definitions
BOLD=$'\033[1m'
GREEN=$'\033[32m'
BLUE=$'\033[34m'
CYAN=$'\033[36m'
RESET=$'\033[0m'

get_local_ip() {
    for iface in en0 en1 eth0 wlan0 bridge0; do
        local ip
        ip=$(ipconfig getifaddr "$iface" 2>/dev/null || ifconfig "$iface" 2>/dev/null | awk '/inet / {print $2; exit}')
        if [ -n "$ip" ] && [ "$ip" != "127.0.0.1" ]; then
            printf '%s\n' "$ip"
            return 0
        fi
    done

    ifconfig 2>/dev/null | awk '/inet / {print $2; exit}' | grep -v '^127\.' | head -n 1
}

main() {
    # Start the continuous runtime loop
    while true; do
        printf '%s%sMiniterm revamped ver %s%s\n' "$BOLD" "$CYAN" "$VER" "$RESET"
        TMP_FILE=$(mktemp)

        # Run the Ruby nested menu framework
        PATH="/opt/homebrew/opt/ruby/bin:$PATH" USER_NAME=$(whoami) ./1.rb > "$TMP_FILE"

        method1=$(tr -d '\r' < "$TMP_FILE")
        rm -f "$TMP_FILE"

        case "$method1" in
            "SYS_DISK")
                echo -e "\e[1;34m📂 Storage Usage Profiles:\e[0m"
                df -h | grep -E '^/dev/'
                echo "-----------------------------------"
                echo "Press Enter to continue..." && read -r
                ;;

            "SYS_MEM")
                printf "\e[1;34m🧠 Active Memory Allocation:\e[0m\n"

                if command -v sysctl >/dev/null 2>&1; then
                    sysctl hw.memsize 2>/dev/null | awk '{print "Total Hardware Memory: " $2 / 1024 / 1024 / 1024 " GB"}'
                else
                    echo "Total Hardware Memory: unavailable"
                fi

                vm_stat 2>/dev/null | awk '
                    /Pages free/ {printf "Free Memory: %.2f MB\n", $3 * 4096 / 1024 / 1024}
                    /Pages active/ {printf "Active Memory: %.2f MB\n", $3 * 4096 / 1024 / 1024}
                    /Pages inactive/ {printf "Inactive Memory: %.2f MB\n", $3 * 4096 / 1024 / 1024}
                    /Pages wired down/ {printf "Wired Memory: %.2f MB\n", $4 * 4096 / 1024 / 1024}
                '

                echo "-----------------------------------"
                echo "Press Enter to continue..." && read -r
                ;;

            "LCL")
                echo "Fetching network details..."
                LOCAL_IP=$(get_local_ip)
                echo "Your local IP address is: ${LOCAL_IP:-unknown}"
                echo "Press Enter to continue..." && read -r
                ;;

            "ONL")
                echo "Fetching online network details..."
                ONLINE_IP=$(curl -fsSL icanhazip.com)
                echo "Your online IP address is: ${ONLINE_IP:-unknown}"
                echo "Press Enter to continue..." && read -r
                ;;
            "sub_back")
                # Nested IP menu requested to return to the main menu.
                ;;
            "exit_menu")
                echo "Exiting cleanly. Goodbye!"
                exit 0
                ;;
            *)
                # If they hit Ctrl+C or something went wrong, clean up and stay in menu.
                ;;
        esac

        clear
    done
}

init() {
    printf "\e[1mInitialising Miniterm Revamped...\e[0m\n"

    bar_width=24
    for ((i=0; i<=bar_width; i++)); do
        filled=$((i * 100 / bar_width))
        printf '\r['
        printf '\033[32m'
        for ((j=0; j<i; j++)); do
            printf '#'
        done
        printf '\033[0m'
        for ((j=i; j<bar_width; j++)); do
            printf ' '
        done
        printf '] (%d%%)' "$filled"
        sleep 0.03
    done
    printf '\n'

    # Quick dependency verification check
    if ! gem list -i tty-prompt > /dev/null 2>&1; then
        printf "\e[33m📦 'tty-prompt' gem missing. Installing...\e[0m\n"
        gem install tty-prompt --no-document
    fi

    printf "\e[1;32m%s\e[0m\n" "✓ All dependencies verified."
    printf "\e[1mVersion: %s\e[0m\n" "$VER"
    sleep 0.5
    clear
    main
}

init
