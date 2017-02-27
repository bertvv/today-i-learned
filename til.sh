#! /usr/bin/env bash
#
# Author: Bert Van Vreckem <bert.vanvreckem@gmail.com>
#
# Adds an entry in this "Today I Learned" repo. The repo is structured as
# follows:
#
# 2017/
#   03/
#     01-how-to-foo-a-bar.md
#     02-reversing-the-polarity-of-the-flux-capacitor.md
#     ...
#
# I.e. subdirectories per year/month, and entries per day.

#{{{ Bash settings
# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
# don't hide errors within pipes
set -o pipefail
#}}}
#{{{ Variables
readonly script_name=$(basename "${0}")
readonly script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

readonly debug_on='yes'

# Color definitions
readonly reset='\e[0m'
readonly cyan='\e[0;36m'
readonly red='\e[0;31m'
readonly yellow='\e[0;33m'

# Template
#}}}

main() {
  print_usage_if_requested "${@}"

  # Determine entry date
  if [ "${#}" -ge '1' ] && is_iso_date "${1}"; then
    readonly entry_date="${1}"
    shift
  else
    readonly entry_date="$(date +'%F')"
  fi
  debug "Date:  ${entry_date}"

  # Determine topic
  if [ "${#}" -ge '1' ]; then
    readonly entry_topic="${*}"
  else
    info 'No topic specified, please enter one here:'
    read -r entry_topic
    readonly entry_topic
  fi
  debug "Topic: ${entry_topic}"

  readonly month_dir=$(month_dir "${entry_date}")
  ensure_dir_exists "${month_dir}"

  readonly entry_file=$(entry_filename "${entry_date}" "${entry_topic}")
  debug "File: ${entry_file}"

  create_entry_file "${month_dir}/${entry_file}" "${entry_date}" "${entry_topic}"
  ${EDITOR} "${month_dir}/${entry_file}"
  #git add  "${month_dir}/${entry_file}"
  #git commit --message "Added: ${topic}"
}

#{{{ Helper functions

print_usage_if_requested() {
  if [ "${#}" -ge '1' ]; then
    if [ "${1}" = '-h' ] || [ "${1}" = '--help' ]; then
      usage
      exit 0
    fi
  fi
}

# Usage: month_dir YYYY-MM-DD
# Returns YYYY/MM
month_dir() {
  local date="${1}"
  local year_month="${date%-*}"
  local entry_dir="${year_month/-//}"
  debug "month_dir() ${date} -> ${year_month} -> ${entry_dir}"
  printf "%s" "${entry_dir}"
}

# Usage: is_iso_date STRING
# Checks whether STRING is a date in YYYY-MM-DD format (ISO 8601).
is_iso_date() {
  [[ "${1}" =~ ^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$ ]]
}

# Usage: ensure_dir_exists DIR
#
# Checks if directory DIR exists, and if not, creates it, including any
# nonexistent parents.
ensure_dir_exists() {
  local dir="${1}"
  if [ ! -d "${dir}" ]; then
    mkdir -p "${dir}"
  fi
}

# Usage: entry_filename YYYY-MM-DD TOPIC
# Returns a file name in the form DD-TOPIC.md, where TOPIC is turned into
# lowercase characters and spaces into dashes.
entry_filename() {
  local day="${1##*-}"
  shift
  local topic
  topic=$(to_lowercase "${*// /-}")
  debug "entry_filename() day = ${day}, topic = ${topic}"

  printf "%s-%s.md" "${day}" "${topic}"
}

to_lowercase() {
  echo "${*}" | tr '[:upper:]' '[:lower:]'
}

# Usage: create_entry_file FILE DATE TOPIC
create_entry_file() {
  file_name="${1}"
  date="${2}"
  shift; shift
  topic="${*}"

cat > "${file_name}" << _EOF_
+++
date = "${date}"
tags = ["TAG"]
title = "${topic}"

+++

# ${topic}


_EOF_
}

# Usage: info [ARG]...
#
# Prints all arguments on the standard output stream
info() {
  printf "${yellow}>>> %s${reset}\n" "${*}"
}

# Usage: debug [ARG]...
#
# Prints all arguments on the standard error stream
debug() {
  [ "${debug_on}" = 'yes' ] && \
    printf "${cyan}### %s${reset}\n" "${*}" 1>&2
}

# Usage: error [ARG]...
#
# Prints all arguments on the standard error stream
error() {
  printf "${red}!!! %s${reset}\n" "${*}" 1>&2
}

# Print usage message on stdout
usage() {
cat << _EOF_
Usage: ${script_name} [DATE] [TOPIC]

  Adds an entry to this Today I Learned journal.

ARGUMENTS:

  DATE   is a date in YYYY-MM-DD format. If the day was not specified, today's
         date is selected.

  TOPIC  is the title of the entry. If none was specified, the user is prompted
         to enter one.

EXAMPLES:

  ${script_name} 
_EOF_
}

#}}}

main "${@}"

