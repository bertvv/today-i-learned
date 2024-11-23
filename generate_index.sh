#! /bin/bash
#
# Author: Bert Van Vreckem <bert.vanvreckem@gmail.com>
#
# Generates a Markdown index of all TIL entries in this repository, with headers
# for each year and month.

#-------------------------------------------------------------------------------
# Bash strict mode
#-------------------------------------------------------------------------------

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------

IFS=$'\t\n'   # Split on newlines and tabs (but not on spaces)
script_name=$(basename "${0}")
script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
target_file="${script_dir}/README.md"
readonly script_name script_dir target_file


#-------------------------------------------------------------------------------
# Main function
#-------------------------------------------------------------------------------

main() {
  print_header
  list_years
}

#-------------------------------------------------------------------------------
# Helper functions
#-------------------------------------------------------------------------------

# Usage: print_header
#  Print the header of the Markdown index file
print_header() {
cat > "${target_file}" << _EOF_
# Today, I learned...

A journal inspired by Dean Wilson's blog post "[Development Diaries and Today I Learned Repositories](https://www.unixdaemon.net/career/developer-diaries-and-til/)".
_EOF_
}

# Usage: list_years
#  Find directories with a 4-digit name (presumably years) and iterate over them
#  to list months (and entries).
list_years() {
  years=$(find . -type d -name '[0-9][0-9][0-9][0-9]' | sort)
  
  while read -r year; do
    year=$(basename "${year}")
    printf '\n## %s\n' "${year}" >> "${target_file}"
    list_months "${year}"
  done <<< "${years}"
}

# Usage: list_months YEAR
#  Find directories with a 2-digit name (presumably months) in the given year
#  directory and iterate over them to list entries.
list_months() {
  local year="${1}"

  months=$(find "${year}" -type d -name '[0-9][0-9]' | sort)

  while read -r month; do
    month=$(basename "${month}")
    printf '\n### %s\n\n' "${month}" >> "${target_file}"
    list_entries "${year}/${month}"
    #printf '\n' >> "${target_file}"
  done <<< "${months}"
}

# Usage: list_entries YEAR/MONTH
#  Find all Markdown files in the given directory and list them, creating a
#  link with the entry title as link text.
list_entries() {
  local year_month="${1}"
  local entries entry entry_title

  entries=$(find "${year_month}" -type f -name '*.md' | sort)

  while read -r entry; do
    entry=$(basename "${entry}" .md)
    entry_title=$(get_title "${year_month}/${entry}.md")

    printf -- '- [%s](%s/%s.md)\n' \
      "${entry_title}" "${year_month}" "${entry}" \
      >> "${target_file}"
  done <<< "${entries}"
}

# Usage: title_to_filename TITLE
#  Search for the title in a Markdown file.
get_title() {
  local entry="${1}"
  local title
  title=$(grep -m 1 '^# ' "${entry}" | sed 's/^# //')
  printf "%s" "${title}"
}

# Usage: log [ARG]...
#
# Prints all arguments on the standard error stream
log() {
  printf '📑 \e[0;33m%s\e[0m\n' "${*}" 1>&2
}

# Usage: debug [ARG]...
#
# Prints all arguments on the standard error stream
debug() {
  if [ "${debug_output}" = 'yes' ]; then
    printf '🪲 \e[0;36m%s\e[0m\n' "${*}" 1>&2
  fi
}

# Usage: error [ARG]...
#
# Prints all arguments on the standard error stream
error() {
  printf '💥 \e[0;31m%s\e[0m\n' "${*}" 1>&2
}

# Call the main function with all command line arguments
main "${@}"
