STEP=0
SUBSTEP=0
SUBSUBSTEP=0

function step() {
    STEP=$((STEP + 1))
    SUBSTEP=0
    SUBSUBSTEP=0
	echo ""
	echo "STEP ${GREEN}$STEP${RESET}: ${CYAN}$@${RESET}"
    echo ""
}

function substep() {
    SUBSTEP=$((SUBSTEP + 1))
    SUBSUBSTEP=0
	echo "STEP ${GREEN}$STEP${RESET}.${YELLOW}$SUBSTEP${RESET}: ${CYAN}$@${RESET}"
    echo ""
}

function subsubstep() {
    SUBSUBSTEP=$((SUBSUBSTEP + 1))
	echo "STEP ${GREEN}$STEP${RESET}.${YELLOW}$SUBSTEP${RESET}.${MAGENTA}$SUBSUBSTEP${RESET}: ${CYAN}$@${RESET}"
    echo ""
}
