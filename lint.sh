#!/bin/bash

# Lint all shell scripts in the repository
find . -name "*.sh" -print0 | xargs -0 shellcheck

# Exit with the status of the last command
exit $?
