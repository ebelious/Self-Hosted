#!/bin/bash
#       _          _ _
#   ___| |__   ___| (_) ___  _   _ ___
#  / _ \ '_ \ / _ \ | |/ _ \| | | / __|
# |  __/ |_) |  __/ | | (_) | |_| \__ \
#  \___|_.__/ \___|_|_|\___/ \__,_|___/
# https://github.com/ebelious
#
# This is a script to pull all pcaps off a Palo Alto firewall, does skip files that already in the directory
#
# Need to get an API from Palo Alto Firewall
#
# curl -H "Content-Type: application/x-www-form-urlencoded" -X POST https://firewall/api/?type=keygen -d 'user=<user>&password=<password>'
# Note: use the -k option if you are using a self-signed certificate on the firewall
#
# helpful Postman link: https://www.postman.com/paloaltonetworks/palo-alto-networks/example/2937330-7b757378-e0a3-442c-aafd-decfec057c5e
#
# Set DBUG to 'true' to see additional logging
#

# Variables
FW_IP="<MGME INTERFACE IP>"
API_KEY="<API Key>"
PCAP_LIST_OUTPUT="pcap_paths.txt"
DEBUG=false
# Modify 'dest_dir' variable for pcap storage location


# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Log functions print to stderr (>&2) so they don't pollute stdout
function log_debug {
  if [[ "$DEBUG" == true ]]; then
    echo -e "${CYAN}[DEBUG]${NC} $1" >&2
  fi
}

function log_info {
  echo -e "${GREEN}[INFO]${NC} $1" >&2
}

function log_warn {
  echo -e "${YELLOW}[WARN]${NC} $1" >&2
}

function log_error {
  echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Queries and forms PCAP list
function get_base_dirs {
  log_info "Requesting base directories from firewall..."
  response=$(curl -s -k -X POST "https://$FW_IP/api/?type=export&category=application-pcap&key=$API_KEY")
  if [[ -z "$response" ]]; then
    log_error "No response from firewall (Step 1)"
    return 1
  fi

  # Extract base dirs as separate lines — only print to stdout (no logs here)
  echo "$response" | awk -F'[<>]' '/<dir>/{print $3}' | sort -u
}

function get_pcaps_from_dir {
  local dir="$1"
  local stripped_dir="${dir#/}"  # Remove leading slash if present
  log_info "Listing PCAPs from directory: $stripped_dir"

  response=$(curl -s -k -X POST "https://$FW_IP/api/?type=export&category=application-pcap&from=/$stripped_dir&key=$API_KEY")
  if [[ -z "$response" ]]; then
    log_error "Failed to list PCAPs in $stripped_dir"
    return 1
  fi

  # Extract file names, strip any path prefixes so no duplication in output
  echo "$response" | awk -v base="$stripped_dir" -F'[<>]' '
    /<file>/ {
      fname = $3
      n = split(fname, parts, "/")
      file = parts[n]
      print base "/" file
    }
  '
}

function main {
  log_info "Generating list of PCAP paths..."
  > "$PCAP_LIST_OUTPUT"  # Clear previous output

  base_dirs=$(get_base_dirs)
  if [[ $? -ne 0 ]]; then
    log_error "Failed to get base directories."
    exit 1
  fi

  # Loop line by line over base directories, skipping empty lines
  while IFS= read -r dir; do
    [[ -z "$dir" ]] && continue

    pcaps=$(get_pcaps_from_dir "$dir")
    if [[ $? -ne 0 ]]; then
      log_warn "Skipping directory $dir due to error."
      continue
    fi

    echo "$pcaps" >> "$PCAP_LIST_OUTPUT"
    log_debug "Added $(echo "$pcaps" | wc -l) files from $dir"
  done <<< "$base_dirs"

  log_info "✅ PCAP list written to: $PCAP_LIST_OUTPUT"
}

main

# Doanloads the PCAPs
function download_pcaps {
  local input_file="$1"
  local dest_dir="pcaps"
  mkdir -p "$dest_dir"

  local count_downloaded=0
  local count_skipped=0
  local count_errors=0

  log_info "Starting download of PCAP files into '$dest_dir' directory..."

  while IFS= read -r pcap_path; do
    [[ -z "$pcap_path" ]] && continue

    local filename="${pcap_path##*/}"
    local dest_path="$dest_dir/$filename"

    if [[ -f "$dest_path" ]]; then
      log_info "${CYAN}Skipping existing file${NC}: $filename"
      ((count_skipped++))
      continue
    fi

    log_info "Downloading $pcap_path ..."
    curl -s -k -X POST "https://$FW_IP/api/?type=export&category=application-pcap&from=$pcap_path&key=$API_KEY" -o "$dest_path"
    if [[ $? -eq 0 ]]; then
      log_info "${GREEN}Downloaded: $filename${NC}"
      ((count_downloaded++))
    else
      log_error "Failed to download: $pcap_path"
      rm -f "$dest_path"  # Remove partial file on failure
      ((count_errors++))
    fi
  done < "$input_file"

  log_info "=== Download Summary ==="
  echo -e "${GREEN}Downloaded: $count_downloaded${NC}"
  echo -e "${YELLOW}Skipped (exists): $count_skipped${NC}"
  echo -e "${RED}Errors: $count_errors${NC}"
}

# Call download_pcaps with your list file
download_pcaps "$PCAP_LIST_OUTPUT"
