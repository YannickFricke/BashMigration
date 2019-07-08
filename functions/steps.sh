STEP=0
SUBSTEP=0

function step() {
    STEP=$((STEP + 1))
	echo ""
	echo "STEP ${GREEN}$STEP${RESET}: ${CYAN}$@${RESET}"
    echo ""
}

function substep() {
    SUBSTEP=$((SUBSTEP + 1))
	echo "STEP ${GREEN}$STEP${RESET}.${YELLOW}$SUBSTEP${RESET}: ${CYAN}$@${RESET}"
    echo ""
}