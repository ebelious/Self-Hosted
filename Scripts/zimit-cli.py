#!/usr/bin/env python3
#       _          _ _
#   ___| |__   ___| (_) ___  _   _ ___
#  / _ \ '_ \ / _ \ | |/ _ \| | | / __|
# |  __/ |_) |  __/ | | (_) | |_| \__ \
#  \___|_.__/ \___|_|_|\___/ \__,_|___/
# https://github.com/ebelious
#
# Requires: docker python3
#
# This is a script to run Zimit. Zimit will scrape websites and convert them into zim files for archiving purposes.
# The script will save the options, and you can change the variables if you would like
# Give the user permissions to run docker 'usermod -aG docker $USER'
# 
# Usage: python3 zimit-cli.py
#
# You can use a program called Kiwix to view the zim files and navigate the offline archived site
#

import json
import os
import subprocess
import sys
from pathlib import Path

CONFIG_FILE = Path.home() / ".zimit_config.json"

def load_config():
    """Load configuration from JSON file."""
    if CONFIG_FILE.exists():
        with open(CONFIG_FILE, 'r') as f:
            return json.load(f)
    return {
        "seeds": "",
        "name": "",
        "host_volume": "/output",  # Default host volume path
        "depth": "-1",  # Default to infinite depth
        "pageLimit": "",
        "scopeExcludeRx": [],
        "workers": "",
        "waitUntil": "load",
        "keep": False
    }

def save_config(config):
    """Save configuration to JSON file."""
    CONFIG_FILE.parent.mkdir(parents=True, exist_ok=True)
    with open(CONFIG_FILE, 'w') as f:
        json.dump(config, f, indent=2)

def display_menu():
    """Display the main menu."""
    print("\nZimit CLI Interface")
    print("1. Run Zimit Container")
    print("2. View/Edit Variables")
    print("3. Exit")

def get_user_input(prompt, default=""):
    """Get user input with optional default value."""
    value = input(f"{prompt} [{default}]: ").strip()
    return value if value else default

def edit_variables(config):
    """Edit configuration variables with examples."""
    print("\nEditing Variables (press Enter to keep current value)")
    print("Examples are provided for each option.")

    config['seeds'] = get_user_input(
        "Seeds URL(s) (comma-separated, e.g., https://example.com,https://example.org)",
        config['seeds']
    )
    config['name'] = get_user_input(
        "ZIM file name (e.g., example_com)",
        config['name']
    )
    config['host_volume'] = str(Path(get_user_input(
        "Host volume directory (absolute path, e.g., /home/user/zim-output)",
        config['host_volume']
    )).resolve())
    config['depth'] = get_user_input(
        "Depth (number of hops, e.g., 2, -1 for infinite)",
        config['depth']
    )
    config['pageLimit'] = get_user_input(
        "Page limit (max URLs to capture, e.g., 1000)",
        config['pageLimit']
    )
    scope_exclude = ",".join(config['scopeExcludeRx'])
    config['scopeExcludeRx'] = [r.strip() for r in get_user_input(
        "Scope exclude regex (comma-separated, e.g., \\?q=,signup-landing\\?)",
        scope_exclude
    ).split(",") if r.strip()]
    config['workers'] = get_user_input(
        "Number of workers (e.g., 4)",
        config['workers']
    )
    config['waitUntil'] = get_user_input(
        "Wait until (load/domcontentloaded, e.g., domcontentloaded for faster static sites)",
        config['waitUntil']
    )
    keep = get_user_input(
        "Keep WARC files? (y/n, e.g., y to keep files even on success)",
        "y" if config['keep'] else "n"
    )
    config['keep'] = keep.lower() == 'y'

    # Verify host volume directory exists
    if not os.path.isdir(config['host_volume']):
        print(f"Warning: Host volume directory {config['host_volume']} does not exist. Creating it...")
        os.makedirs(config['host_volume'], exist_ok=True)

    save_config(config)
    print("Variables saved successfully!")

def build_docker_command(config):
    """Build the Docker command based on configuration."""
    # Verify host volume directory exists
    if not os.path.isdir(config['host_volume']):
        print(f"Error: Host volume directory {config['host_volume']} does not exist!")
        return None

    cmd = [
        "docker", "run", "--shm-size", "1gb",
        "-v", f"{config['host_volume']}:/output",
        "ghcr.io/openzim/zimit", "zimit"
    ]

    if not config['seeds'] or not config['name']:
        print("Error: Seeds URL and ZIM file name are required!")
        return None

    cmd.extend(["--seeds", config['seeds']])
    cmd.extend(["--name", config['name']])
    cmd.extend(["--output", "/output"])  # Always /output inside container
    cmd.extend(["--depth", config['depth']])

    if config['pageLimit']:
        cmd.extend(["--pageLimit", config['pageLimit']])
    for regex in config['scopeExcludeRx']:
        cmd.extend(["--scopeExcludeRx", regex])
    if config['workers']:
        cmd.extend(["--workers", config['workers']])
    if config['waitUntil'] != "load":
        cmd.extend(["--waitUntil", config['waitUntil']])
    if config['keep']:
        cmd.append("--keep")

    return cmd

def run_zimit(config):
    """Run the Zimit Docker container."""
    cmd = build_docker_command(config)
    if not cmd:
        return

    print("\nRunning command:", " ".join(cmd))
    try:
        subprocess.run(cmd, check=True)
        print("Zimit container executed successfully!")
    except subprocess.CalledProcessError as e:
        print(f"Error running Docker container: {e}")
    except FileNotFoundError:
        print("Error: Docker not found. Please ensure Docker is installed.")

def main():
    config = load_config()

    while True:
        display_menu()
        choice = input("Enter choice (1-3): ").strip()

        if choice == "1":
            run_zimit(config)
        elif choice == "2":
            edit_variables(config)
        elif choice == "3":
            print("Exiting...")
            sys.exit(0)
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main()
