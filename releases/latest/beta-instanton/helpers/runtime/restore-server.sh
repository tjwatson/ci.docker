#!/bin/bash

# For restore use a copy of criu that does not have sys_ptrace
export CRIU_RESTORE_PATH=/opt/criu/criu

USER_ID="$(id -u)"
if [ "$USER_ID" = 1001 ] || [ "$USER_ID" = 0 ]; then
  exec "$@"
else
  # TODO These traps don't seem to work at all
  trap "echo I was SIGINT terminated; server stop; exit" SIGINT
  trap "echo I was SIGQUIT terminated; server stop; exit" SIGQUIT
  trap "echo I was SIGTERM terminated; server stop; exit" SIGTERM
  export RESTORE_CMD="$@"
  su --session-command='$RESTORE_CMD' default
fi

