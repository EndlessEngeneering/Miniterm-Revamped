#!/bin/bash
VER="v1.0"
clear
# Color Definitions
BOLD=$'\033[1m'
GREEN=$'\033[32m'
BLUE=$'\033[34m'
CYAN=$'\033[36m'
RESET=$'\033[0m'

print_banner() {
    local title="Miniterm Revamped"
    local title_padding=$((44 - ${#title}))

    printf '%s╭──────────────────────────────────────────────╮%s\n' "$CYAN" "$RESET"
    printf '%s│%s %s%s%s%*s %s│%s\n' \
        "$CYAN" "$RESET" "$BOLD" "$title" "$RESET" "$title_padding" '' "$CYAN" "$RESET"
    printf '%s│%s %-44s %s│%s\n' \
        "$CYAN" "$RESET" "System utilities - version $VER" "$CYAN" "$RESET"
    printf '%s╰──────────────────────────────────────────────╯%s\n\n' "$CYAN" "$RESET"
}

print_section() {
    printf '\n%s── %s ──%s\n\n' "$BLUE" "$1" "$RESET"
}

pause() {
    printf '\n%sPress Enter to return to the menu...%s' "$BOLD" "$RESET"
    read -r
}

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
    menu_level="main"

    # Start the continuous runtime loop
    while true; do
        print_banner
        TMP_FILE=$(mktemp)

        # Run the Ruby nested menu framework
        PATH="/opt/homebrew/opt/ruby/bin:$PATH" USER_NAME=$(whoami) MENU_LEVEL="$menu_level" ./1.rb > "$TMP_FILE"

        method1=$(tr -d '\r' < "$TMP_FILE")
        rm -f "$TMP_FILE"

        case "$method1" in
            "check_ip")
                menu_level="network"
                ;;

            "SYS_DISK")
                menu_level="main"
                print_section "DISK USAGE"
                df -h | grep -E '^/dev/'
                pause
                ;;

            "SYS_MEM")
                menu_level="main"
                print_section "MEMORY USAGE"

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

                pause
                ;;

            "LCL")
                menu_level="network"
                print_section "LOCAL NETWORK"
                LOCAL_IP=$(get_local_ip)
                printf '%sLocal IP:%s %s\n' "$BOLD" "$RESET" "${LOCAL_IP:-unknown}"
                pause
                ;;

            "ONL")
                menu_level="network"
                print_section "PUBLIC NETWORK"
                ONLINE_IP=$(curl -fsSL icanhazip.com)
                printf '%sPublic IP:%s %s\n' "$BOLD" "$RESET" "${ONLINE_IP:-unknown}"
                pause
                ;;
            "sub_back")
                menu_level="main"
                ;;
            "exit_menu")
                printf '\n%sGoodbye!%s\n' "$CYAN" "$RESET"
                exit 0
                ;;
            *)
                menu_level="main"
                # If they hit Ctrl+C or something went wrong, clean up and stay in menu.
                ;;
        esac

        clear
    done
}

init() {
    printf '%sInitialising Miniterm Revamped%s\n\n' "$BOLD" "$RESET"

    bar_width=30
    for ((i=0; i<=bar_width; i++)); do
        filled=$((i * 100 / bar_width))
        printf '\r  %s[%s' "$BLUE" "$RESET"
        printf '%s' "$GREEN"
        for ((j=0; j<i; j++)); do
            printf '='
        done
        if (( i < bar_width )); then
            printf '>'
        fi
        printf '%s' "$RESET"
        for ((j=i; j<bar_width; j++)); do
            if (( j > i )); then
                printf ' '
            fi
        done
        printf '%s] %3d%%%s' "$BLUE" "$filled" "$RESET"
        sleep 0.025
    done
    printf '\n\n'

    # Quick dependency verification check
    if ! gem list -i tty-prompt > /dev/null 2>&1; then
        printf '%s[setup]%s tty-prompt gem missing. Installing...\n' "$BLUE" "$RESET"
        gem install tty-prompt --no-document
    fi

    printf '%s[ready]%s Dependencies verified.\n' "$GREEN" "$RESET"
    sleep 0.4
    clear
    main
}

init
