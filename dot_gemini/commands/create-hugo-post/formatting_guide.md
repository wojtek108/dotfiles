# Hugo Content Formatting Guide

This guide provides a template and best practices for creating new blog posts to ensure consistency across the site.

## Front Matter Template

All posts should begin with a TOML front matter block (`+++`). Below is the required structure.

```toml
+++
title = "Your Post Title"
date = "YYYY-MM-DDTHH:MM:SS+ZZ:ZZ"
draft = false
tags = ["tag1", "tag2"]
+++
```

### Field Explanations:

*   **`title`**: The title of your post.
*   **`date`**: The publication date and time. Use the format `YYYY-MM-DDTHH:MM:SS+ZZ:ZZ` (e.g., `2025-12-21T15:30:00+01:00`).
*   **`draft`**: Set to `false` to publish the post. Set to `true` to keep it as a draft.
*   **`tags`**: A list of relevant tags. Please use lowercase tags and choose from the existing list where possible to maintain consistency.

## Existing Tags

Here is a list of all tags currently used on the site. Please use these tags when possible to avoid creating duplicates.

- ads
- ai
- ai_ads
- ai_agent
- ai_project
- ai_projects
- ai_tools
- algorithms
- b2b_marketing
- b2c_marketing
- backup
- bash
- biz
- biz_idea_validation
- cheatsheet
- chezmoi
- cli
- cmus
- culture
- data_structures
- data_structures_in_action
- dictionary
- diy
- docker
- dotfiles
- entrepreneurship
- flash_drive
- flask
- funtion_default_arguments
- future-of-work
- generators
- google_app_script
- health
- healthspan
- idea_to_develop
- landing_page
- leadership
- learning
- life_hacks
- linear_search
- linux
- list
- lla
- llm
- longevity
- lovable
- marketing
- mikrus
- miroburn
- mp3
- music
- n8n
- naval
- neovim
- nextcloud
- no_code
- one-person_business
- prompt
- prompt_engineering
- prompting
- pullups
- python
- rclone
- recruiting
- ripgrep
- rsync
- set
- sorting
- startups
- strenght
- tina_huang
- tmux
- vibecoding
- vim
- vps
- wezterm
- yazi
- yield

## Content Formatting

*   **Markdown**: All content should be written in standard Markdown.
*   **Code Blocks**: Use triple backticks (``````) for code blocks, and specify the language for syntax highlighting (e.g., ```python`).
*   **Headings**: Use hashes (`#`, `##`, `###`) for section headings.
*   **Links**: Use standard Markdown link format: `[link text](URL)`.
*   **Images**: If you include images, place them in the `static/images` directory and reference them with a relative path.

By following this guide, we can maintain a clean and consistent structure for all content on the site.
