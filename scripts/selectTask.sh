#!/bin/bash

# rewrite to python!

# _term() { 
#   echo "Caught SIGTERM signal!" 
#   kill -TERM "$child" 2>/dev/null
# }

# trap _term SIGTERM SIGINT

DEBUG=false

function log() {
    if ${DEBUG}; then echo "$1"; fi
}

COMMAND=""

function selectTask() {
    local lvl=1
    local modules=""
    local module=""
    local command_tmp=""
    local count_modules=""

    while true; do
      log "Level: ${lvl}"
      modules=$(task --list-all -s | grep "^${module}" | cut -f ${lvl} -d ":" | uniq | xargs)
      log "Modules: ${modules}"
      module=$(gum choose 000-end ${modules})
      log "Module: ${module}"

      [ "${module}" == "000-end" ] && return 1

      command_tmp="${COMMAND}"
      [ -z ${COMMAND} ] && COMMAND="${module}" || COMMAND="${command_tmp}:${module}"
      log "Command: ${COMMAND}"
    
      count_modules=$(task --list-all -s | grep "^${COMMAND}" | egrep -o ":" | wc -l)
      log "Module count: ${count_modules}"
      [ "${count_modules}" == "$((lvl-1))" ] && break
      lvl=$((lvl+1))

    done
}

selectTask && task ${COMMAND} || true

# child=$! 
# wait "$child"
