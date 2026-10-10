#!/bin/bash
VER="v1.0"
clear
# Color Definitions
BOLD="\e[1m"
GREEN="\e[32m"
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m" # Always use reset to keep the terminal background default

main() {
    # Start the continuous runtime loop
    while true; do
        echo "${BOLD}${CYAN}Miniterm revamped ver $VER${RESET}"
	    TMP_FILE=$(mktemp)
        
        # Run the Ruby nested menu framework
        PATH="/opt/homebrew/opt/ruby/bin:$PATH" USER_NAME=$(whoami) ./1.rb > "$TMP_FILE"
        
        method1=$(cat "$TMP_FILE")
        rm -f "$TMP_FILE"
        
        case "$method1" in
            "SYS_DISK")
                echo -e "\e[1;34m📂 Storage Usage Profiles:\e[0m"
                # Displays clean, human-readable disk consumption percentages
                df -h | grep -E '^/dev/'
                echo "-----------------------------------"
                echo "Press Enter to continue..." && read -r
                ;;
                
            "SYS_MEM")
                # Clear standard terminal colors and formats cleanly
                printf "\e[1;34m🧠 Active Memory Allocation:\e[0m\n"
                
                # Correctly read hardware specification limits
                sysctl hw.memsize | awk '{print "Total Hardware Memory: " $2 / 1024 / 1024 / 1024 " GB"}'
                
                # Fixed vm_stat extraction loop for modern macOS layouts
                vm_stat | awk '
                    /Pages free/ {printf "Free Memory: %.2f MB\n", $3 * 4096 / 1024 / 1024}
                    /Pages active/ {printf "Active Memory: %.2f MB\n", $3 * 4096 / 1024 / 1024}
                    /Pages inactive/ {printf "Inactive Memory: %.2f MB\n", $3 * 4096 / 1024 / 1024}
                    /Pages wired down/ {printf "Wired Memory: %.2f MB\n", $4 * 4096 / 1024 / 1024}
                '
                
                echo "-----------------------------------"
                echo "Press Enter to continue..." && read -r
                ;;            "LCL")
                echo "Fetching network details..."
                LOCAL_IP=$(ipconfig getifaddr en0 2>/dev/null || ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -n 1)
                echo "Your local IP address is: $LOCAL_IP"
                echo "Press Enter to continue..." && read -r
                ;;
            "ONL")
                echo "Fetching online network details..."
                ONLINE_IP=$(curl -s icanhazip.com)
                echo "Your online IP address is: $ONLINE_IP"
                echo "Press Enter to continue..." && read -r
                ;;
            "exit_menu")
                echo "Exiting cleanly. Goodbye!"
                exit 0 # This breaks the loop completely and closes the script
                ;;
            *)
                # If they hit Ctrl+C or something went wrong, clean up and stay in menu
                ;;
        esac
        
        # Wipes the canvas clean before restarting the options block selection grid
        clear
    done
}

init() {
    printf "\e[1mInitialising Miniterm Revamped...\e[0m\n"
    
    # Simple animated progress bar loop
    echo -ne ' [######################] (100%)\r'
    for i in {1..24}; do
        echo -ne " \e[32m#\e[0m"
        sleep 0.03
    done
    echo -e "\n"

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

