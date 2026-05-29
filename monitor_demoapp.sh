#!/usr/bin/env bash

STATE="/opt/demoapp/state"
LOGFILE="/opt/demoapp/alert.log"

# pokud stavový soubor neexistuje, vytvoříme ho
if [ ! -f "$STATE" ]; then
    echo 'LAST_STOP=""' > "$STATE"
    echo 'LAST_START=""' >> "$STATE"
fi

# načteme stav
source "$STATE"

# vezmeme posledních 200 řádků
LOG=$(journalctl -u demoapp -n 200)

# najdeme poslední STOP
STOP_LINE=$(echo "$LOG" | grep -E "Stopped[[:space:]]+demoapp\.service" | tail -n 1)
STOP_TIME=$(echo "$STOP_LINE" | awk '{print $1, $2, $3}')

# najdeme poslední START
START_LINE=$(echo "$LOG" | grep -E "Started[[:space:]]+demoapp\.service" | tail -n 1)
START_TIME=$(echo "$START_LINE" | awk '{print $1, $2, $3}')

# aktualizace stavu
if [ -n "$STOP_TIME" ] && [[ "$STOP_TIME" > "$LAST_STOP" ]]; then
    LAST_STOP="$STOP_TIME"
fi

if [ -n "$START_TIME" ] && [[ "$START_TIME" > "$LAST_START" ]]; then
    LAST_START="$START_TIME"
fi

# uložíme stav
echo "LAST_STOP=\"$LAST_STOP\"" > "$STATE"
echo "LAST_START=\"$LAST_START\"" >> "$STATE"

# vyhodnocení
if [[ "$LAST_STOP" > "$LAST_START" ]]; then
    echo "$(date): demoapp STOPPED and NOT restarted!" >> "$LOGFILE"
fi

