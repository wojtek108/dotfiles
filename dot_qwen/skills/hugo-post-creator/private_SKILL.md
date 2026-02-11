---
name: hugo-post-creator
description: Automate creation of properly formatted Hugo blog posts with correct front matter, tags, and structure. Use when the user wants to create, write, or format Hugo blog posts, or mentions Hugo content creation.
allowed-tools: Read, Bash, Write, Glob
---

# Hugo Post Creator

This skill helps create properly formatted Hugo blog posts following the site's conventions and structure.

## Overview

This skill guides you through creating new Hugo blog posts with:
- Proper TOML front matter formatting
- Correct numerical prefixing for post ordering
- Appropriate tag selection from existing tags
- Standard Markdown content formatting

## Post Creation Workflow

### 1. Determine Next Post Number

Navigate to the posts directory and find the next available number:

```bash
cd /home/wga/Documents/online_active_projects/hugo/learningandrecalls/content/posts/
ls -1 | grep -E '^[0-9]+_' | sed 's/_.*//' | sort -n | tail -1
```

The new post should use the next sequential number (e.g., if last is `068_`, use `069_`).

### 2. Generate Post File

Use the Hugo command to create the new post:

```bash
hugo new posts/{{NEXT_NUMBER}}_{{POST_SLUG}}.md
```

This will:
- Create a new Markdown file in `content/posts/`
- Populate it with front matter from `archetypes/default.md`

### 3. Format Front Matter

Ensure the front matter follows the TOML template:

```toml
+++
title = "Your Post Title"
date = "YYYY-MM-DDTHH:MM:SS+ZZ:ZZ"
draft = false
tags = ["tag1", "tag2"]
+++
```

**Key fields:**
- `title`: The post title
- `date`: Use format `YYYY-MM-DDTHH:MM:SS+ZZ:ZZ` (e.g., `2025-12-21T15:30:00+01:00`)
  - **⚠️ CRITICAL**: Always set the date to today (or close to today) for new posts. Hugo filters pages based on their publication date—if you set a date far in the past, the post may not appear in site listings, even though the HTML file is generated. This can make it seem like a post was never published.
  - **For chronological ordering**: Posts appear in reverse chronological order (newest first) based on their `date` field. To control post ordering on the homepage, adjust the date accordingly.
- `draft`: Set to `false` to publish, `true` for draft
- `tags`: Lowercase tags from the existing tag list (see [formatting_guide.md](../formatting_guide.md))

### 4. Select Appropriate Tags

**IMPORTANT**: Always use existing tags when possible to maintain consistency. Reference the complete tag list in [formatting_guide.md](../formatting_guide.md).

Common tag categories:
- **Programming**: python, bash, cli, vim, neovim, tmux, docker, flask
- **AI/ML**: ai, llm, ai_agent, ai_tools, ai_projects, prompt_engineering
- **Business**: biz, entrepreneurship, startups, marketing, b2b_marketing, landing_page
- **Tools**: chezmoi, yazi, wezterm, ripgrep, n8n, lovable
- **Lifestyle**: health, longevity, healthspan, learning, culture

### 5. Content Formatting

Follow standard Markdown conventions:

- **Code blocks** (⚠️ **CRITICAL**): ALWAYS use triple backticks with language specification for ANY code (bash, python, etc.). NEVER paste code as plain text. Examples:
  ````markdown
  ```bash
  echo "Hello world"
  ```
  ````
  ````markdown
  ```python
  def example():
      pass
  ```
  ````
  ````markdown
  ```javascript
  console.log("Hello");
  ```
  ````

- **Headings**: Use hash notation (`#`, `##`, `###`)
- **Links**: Standard Markdown format `[text](URL)`
- **Images**: Place in `static/images/` and reference with relative paths

### 6. View Your Posts

After creating and formatting your posts, navigate to the Hugo site and verify they appear correctly:

```bash
cd /home/wga/Documents/online_active_projects/hugo/learningandrecalls
hugo server
```

The posts will be immediately available on your local server at `http://localhost:1313`.

## Quick Reference

For detailed formatting guidelines, see:
- [formatting_guide.md](../formatting_guide.md) - Complete front matter template and tag list
- [hugo_site_structure.md](../hugo_site_structure.md) - Site directory structure and archetypes

## Example Complete Workflow

```bash
# 1. Navigate to Hugo site
cd /home/wga/Documents/online_active_projects/hugo/learningandrecalls

# 2. Check next post number
cd content/posts/
NEXT_NUM=$(ls -1 | grep -E '^[0-9]+_' | sed 's/_.*//' | sort -n | tail -1)
NEXT_NUM=$((NEXT_NUM + 1))
cd /home/wga/Documents/online_active_projects/hugo/learningandrecalls

# 3. Create post with proper slug
hugo new posts/${NEXT_NUM}_my-new-post-title.md

# 4. Edit the file with proper front matter and content

# 5. View in browser
hugo server
```

## Best Practices

1. **Naming**: Use lowercase slugs with hyphens (e.g., `069_my-post-title.md`)
2. **Tags**: Select 2-5 relevant tags from existing list
3. **Date format**: Always include timezone offset
4. **Date recency**: ⚠️ **CRITICAL** - Always set the date to the current date for new posts. Historical dates (especially dates from the past that are far away) may cause Hugo to exclude the post from site listings. Posts with old dates may appear to be unpublished even though the HTML file is generated.
5. **Chronological ordering**: Posts appear in reverse chronological order (newest first) on the homepage based on their `date` field. Adjust dates to control post ordering.
6. **Draft status**: Start with `draft = true` for review, then change to `false` to publish
7. **Content structure**: Use clear headings to organize content
8. **Code formatting**: ⚠️ **ALWAYS use code blocks for code**. Never paste bash, python, javascript, or any other code as plain text. ALWAYS wrap with triple backticks and language identifier.

## Troubleshooting

### Post is generated but doesn't appear on homepage

**Symptom**: The post HTML file exists in `/public/posts/XXX_slug/index.html` but doesn't show up in the site listing.

**Root cause**: The post's `date` field is set to a date far in the past. Hugo filters pages based on their publication date and excludes old posts from `.Site.RegularPages` listings.

**Solution**:
1. Update the post's date to today (or a recent date)
2. Rebuild Hugo: `hugo` (or `hugo -D` if it's still in draft mode)
3. The post should now appear on the homepage

**Example**: Post 096 "Vibecoding Blueprint" had a date of `2025-02-16T10:00:00+01:00` (almost a year in the past). It was generated as HTML but filtered out from listings. After updating to `2026-01-27T12:00:00+01:00` (current date), it appeared immediately on the homepage.

## Supporting Files

- `formatting_guide.md` - Front matter template, existing tags list, formatting rules
- `hugo_site_structure.md` - Directory structure, archetype information, automation details
