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
cd /home/wga/Documents/online_python_projects/hugo/learningandrecalls/content/posts/
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

- **Code blocks**: Use triple backticks with language specification:
  ````markdown
  ```python
  def example():
      pass
  ```
  ````

- **Headings**: Use hash notation (`#`, `##`, `###`)
- **Links**: Standard Markdown format `[text](URL)`
- **Images**: Place in `static/images/` and reference with relative paths

## Quick Reference

For detailed formatting guidelines, see:
- [formatting_guide.md](../formatting_guide.md) - Complete front matter template and tag list
- [hugo_site_structure.md](../hugo_site_structure.md) - Site directory structure and archetypes

## Example Complete Workflow

```bash
# 1. Check next post number
cd /home/wga/Documents/online_python_projects/hugo/learningandrecalls/content/posts/
NEXT_NUM=$(ls -1 | grep -E '^[0-9]+_' | sed 's/_.*//' | sort -n | tail -1)
NEXT_NUM=$((NEXT_NUM + 1))

# 2. Create post with proper slug
hugo new posts/${NEXT_NUM}_my-new-post-title.md

# 3. Edit the file with proper front matter and content
```

## Best Practices

1. **Naming**: Use lowercase slugs with hyphens (e.g., `069_my-post-title.md`)
2. **Tags**: Select 2-5 relevant tags from existing list
3. **Date format**: Always include timezone offset
4. **Draft status**: Start with `draft = true` for review, then change to `false` to publish
5. **Content structure**: Use clear headings to organize content

## Supporting Files

- `formatting_guide.md` - Front matter template, existing tags list, formatting rules
- `hugo_site_structure.md` - Directory structure, archetype information, automation details
