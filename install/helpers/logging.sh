unbloarchy_log_to_stdout() {
  [[ ${UNBLOARCHY_LOG_TO_STDOUT:-} == "1" || -z ${UNBLOARCHY_INSTALL_LOG_FILE:-} ]]
}

unbloarchy_log_line() {
  if unbloarchy_log_to_stdout; then
    echo "$1"
  else
    echo "$1" >>"$UNBLOARCHY_INSTALL_LOG_FILE"
  fi
}

start_install_log() {
  if ! unbloarchy_log_to_stdout; then
    mkdir -p "$(dirname "$UNBLOARCHY_INSTALL_LOG_FILE")"
    touch "$UNBLOARCHY_INSTALL_LOG_FILE"
    chmod 666 "$UNBLOARCHY_INSTALL_LOG_FILE" 2>/dev/null || true
  fi

  export UNBLOARCHY_START_TIME="${UNBLOARCHY_START_TIME:-$(date '+%Y-%m-%d %H:%M:%S')}"
  export UNBLOARCHY_START_EPOCH="${UNBLOARCHY_START_EPOCH:-$(date +%s)}"

  unbloarchy_log_line "=== Unbloarchy Setup Started: $UNBLOARCHY_START_TIME ==="
}

stop_install_log() {
  local end_time end_epoch duration mins secs
  end_time=$(date '+%Y-%m-%d %H:%M:%S')
  end_epoch=$(date +%s)

  unbloarchy_log_line "=== Unbloarchy Setup Completed: $end_time ==="

  if [[ -n ${UNBLOARCHY_START_EPOCH:-} ]]; then
    duration=$((end_epoch - UNBLOARCHY_START_EPOCH))
    mins=$((duration / 60))
    secs=$((duration % 60))
    unbloarchy_log_line "Unbloarchy setup: ${mins}m ${secs}s"
  fi
}

run_logged() {
  local script="$1"
  local exit_code errexit_was_set=0

  unbloarchy_log_line "[$(date '+%Y-%m-%d %H:%M:%S')] Starting: $script"

  case $- in
    *e*)
      errexit_was_set=1
      set +e
      ;;
  esac

  local runner=(bash -eE)
  if [[ ${UNBLOARCHY_INSTALL_DEBUG:-} == "1" ]]; then
    runner=(bash -x -eE)
  fi

  if unbloarchy_log_to_stdout; then
    PS4='+ ${BASH_SOURCE[0]##*/}:${LINENO}:${FUNCNAME[0]:-main}: ' \
      "${runner[@]}" -c 'source "$1"' bash "$script" </dev/null 2>&1
  else
    PS4='+ ${BASH_SOURCE[0]##*/}:${LINENO}:${FUNCNAME[0]:-main}: ' \
      "${runner[@]}" -c 'source "$1"' bash "$script" </dev/null >>"$UNBLOARCHY_INSTALL_LOG_FILE" 2>&1
  fi

  exit_code=$?
  (( errexit_was_set )) && set -e

  if (( exit_code == 0 )); then
    unbloarchy_log_line "[$(date '+%Y-%m-%d %H:%M:%S')] Completed: $script"
  else
    unbloarchy_log_line "[$(date '+%Y-%m-%d %H:%M:%S')] Failed: $script (exit code: $exit_code)"
  fi

  return $exit_code
}
