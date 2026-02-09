#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import datetime
import re
import argparse

# --- Configuration ---
# Absolute path to your homepage content file.
MARKDOWN_FILE = "/home/wga/Documents/online_active_projects/hugo/wgahugo/content/_index.markdown"

def update_last_modified_date(lines):
    """Updates the 'Last update:' line in the content."""
    updated_lines = []
    today = datetime.date.today().isoformat()
    found_update_line = False
    for line in lines:
        if line.strip().startswith("Last update:"):
            updated_lines.append(f"Last update: {today}")
            found_update_line = True
        else:
            updated_lines.append(line)
    if not found_update_line:
        # If 'Last update' line isn't found, add it at the end (or another logical place if needed)
        updated_lines.append(f"Last update: {today}")
    return updated_lines

def add_link(url, desc):
    """Adds a new link to the Markdown file."""
    if not url or not desc:
        print("Error: Both URL and description are required to add a link.")
        return

    new_line = f"- [{url}]({url}) -- {desc}"

    if not os.path.exists(MARKDOWN_FILE):
        print(f"Error: Could not find content file at: {MARKDOWN_FILE}")
        return

    with open(MARKDOWN_FILE, 'r') as f:
        lines = f.read().splitlines()

    # Update last modified date
    lines = update_last_modified_date(lines)
            
    # Append the new link at the end
    lines.append(new_line)

    # Write everything back
    with open(MARKDOWN_FILE, 'w') as f:
        f.write('\\n'.join(lines))
        f.write('\\n') # Ensure file ends with a newline

    print(f"Success! Added: {new_line}")

def edit_link(old_url, new_url=None, new_desc=None):
    """Edits an existing link in the Markdown file."""
    if not old_url:
        print("Error: An old URL is required to edit a link.")
        return

    if not os.path.exists(MARKDOWN_FILE):
        print(f"Error: Could not find content file at: {MARKDOWN_FILE}")
        return

    with open(MARKDOWN_FILE, 'r') as f:
        lines = f.read().splitlines()

    link_pattern = re.compile(r'^- \[(?P<link_text>[^\]]+)\]\((?P<link_url>[^)]+)\)(?: -- (?P<description>.*))?$')
    
    updated_lines = []
    link_found = False

    for line in lines:
        match = link_pattern.match(line.strip())
        if match:
            current_url = match.group('link_url')
            current_link_text = match.group('link_text')
            current_description = match.group('description')

            if current_url == old_url:
                link_found = True
                # Use new_url and new_desc if provided, otherwise keep current values
                final_url = new_url if new_url is not None else current_url
                final_desc = new_desc if new_desc is not None else current_description

                if final_desc is None: # Handle case where original had no description and no new_desc is provided
                    updated_lines.append(f"- [{final_url}]({final_url})")
                else:
                    updated_lines.append(f"- [{final_url}]({final_url}) -- {final_desc}")
                print(f"Success! Edited link from '{old_url}' to: {updated_lines[-1]}")
            else:
                updated_lines.append(line)
        else:
            updated_lines.append(line)

    if not link_found:
        print(f"Error: Link with URL '{old_url}' not found in {MARKDOWN_FILE}.")
        return

    # Update last modified date
    updated_lines = update_last_modified_date(updated_lines)

    # Write everything back
    with open(MARKDOWN_FILE, 'w') as f:
        f.write('\\n'.join(updated_lines))
        f.write('\\n') # Ensure file ends with a newline


def main():
    parser = argparse.ArgumentParser(description="Manage links on your Hugo homepage.")
    subparsers = parser.add_subparsers(dest="command", help="Available commands", required=True)

    # Add subcommand
    add_parser = subparsers.add_parser("add", help="Add a new link.")
    add_parser.add_argument("url", help="The URL of the new link.")
    add_parser.add_argument("--desc", help="The description for the new link.", required=True)

    # Edit subcommand
    edit_parser = subparsers.add_parser("edit", help="Edit an existing link.")
    edit_parser.add_argument("old_url", help="The URL of the link to be edited.")
    edit_parser.add_argument("--new-url", help="The new URL for the link (optional).")
    edit_parser.add_argument("--new-desc", help="The new description for the link (optional).")

    args = parser.parse_args()

    if args.command == "add":
        add_link(args.url, args.desc)
    elif args.command == "edit":
        edit_link(args.old_url, args.new_url, args.new_desc)

if __name__ == "__main__":
    main()
