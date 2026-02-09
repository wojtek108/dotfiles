# Hugo Site Structure for Post Creation Automation

This document outlines the key directories and files within a Hugo site relevant for automating post creation. It serves as a reference for an AI CLI application to understand the project's layout and generate appropriate bash scripts.

## Key Directories and Their Purpose:

### `content/`
This directory holds all the content for your Hugo site.

-   **`content/posts/`**: This is where all your blog posts (or similar content types) are stored. Each post is typically a Markdown file (e.g., `001_list_multiplication.md`). The naming convention often includes a numerical prefix for ordering.

### `archetypes/`
Archetypes are template files that Hugo uses to pre-populate new content files.

-   **`archetypes/default.md`**: This file serves as the default template for new content. When you create a new post using `hugo new posts/my-new-post.md`, Hugo will use this archetype to pre-fill the front matter (metadata like title, date, draft status).

### `hugo.toml`
This is the main configuration file for your Hugo site.

-   **`hugo.toml`**: Contains global site settings, such as base URL, title, theme, and output formats. While not directly involved in *creating* a post file, it dictates how posts are processed and rendered.

## Post Creation Workflow (for automation):

1.  **Determine New Post Path**: New posts should typically go into `content/posts/`. A common pattern is to use a numerical prefix (e.g., `069_new_post_title.md`) to maintain order. The AI should determine the next available number.
2.  **Generate Content File**: Use `hugo new posts/{{NEXT_NUMBER}}_{{POST_SLUG}}.md`. This command will:
    *   Create a new Markdown file in `content/posts/`.
    *   Populate it with front matter defined in `archetypes/default.md`.
3.  **Edit Content**: The generated file will then be ready for content to be added.

## Post Title
1. Go to "/home/wga/Documents/online_active_projects/hugo/learningandrecalls/content/posts/"
    to determin next post number.
2. Create "Tag_list.md" with tags used in "content/posts". Use this list to tag new posts.
## Example `archetypes/default.md` Structure:

A typical `archetypes/default.md` might look like this:

```markdown
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
tags: []
categories: []
---
```

This structure ensures that new posts automatically get a title derived from the filename, the current date, and are marked as drafts by default.
