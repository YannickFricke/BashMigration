function info() {
    echo "${BLUE}[$LEVEL_INFO] $@${RESET}"
}

function warning() {
    echo "${YELLOW}[$LEVEL_WARN] $@${RESET}"
}

function error() {
    echo "${RED}[$LEVEL_ERROR] $@${RESET}"
}

function success() {
    echo "${GREEN}[$1] ${@:2}${RESET}"
}

function debug() {
    if [[ $DEBUG != "1" ]]; then
        return 0
    fi

    echo "${CYAN}[$LEVEL_DEBUG] $@${RESET}"
}
