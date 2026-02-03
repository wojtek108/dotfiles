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

### 6. Generate Bash Script for Post Deployment

**CRITICAL**: After creating Hugo posts in a staging/learning directory, ALWAYS generate a bash script that deploys these posts to the main Hugo site.

The script must perform a **two-step process**:

**Step 1: Create posts with Hugo**
- Change to the Hugo site directory
- Run `hugo new posts/<filename>` for each post
- This applies the archetype template and creates proper structure

**Step 2: Replace with actual content**
- Copy the actual post content from staging directory
- Overwrite the empty posts created in Step 1
- This preserves Hugo structure while using your real content

The script should:
- Detect the current working directory and locate the posts
- List all created post files in an array
- Provide clear feedback for each step
- Handle errors gracefully (e.g., Hugo site not accessible)
- Be executable (`chmod +x`)

**Script Template:**

```bash
#!/bin/bash

# Hugo site directory
HUGO_SITE="/home/wga/Documents/online_python_projects/hugo/learningandrecalls"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/hugo_posts"
TARGET_DIR="$HUGO_SITE/content/posts"

# List of post files to create and copy
POST_FILES=(
    "090_example_post.md"
    "091_another_post.md"
)

echo "════════════════════════════════════════════════"
echo "Hugo Post Deployment Script"
echo "════════════════════════════════════════════════"
echo "Hugo Site: $HUGO_SITE"
echo "Source: $SOURCE_DIR"
echo ""

# Change to Hugo site directory
cd "$HUGO_SITE" || { echo "Error: Cannot access Hugo site directory"; exit 1; }

echo "Step 1: Creating posts with Hugo (applying archetypes)..."
echo "────────────────────────────────────────────────"

# Loop through each file and create it with hugo new
for file in "${POST_FILES[@]}"; do
    if [ -f "$SOURCE_DIR/$file" ]; then
        echo "  → hugo new posts/$file"
        hugo new "posts/$file" 2>/dev/null
    else
        echo "  ✗ Warning: $file not found in source directory, skipping"
    fi
done

echo ""
echo "Step 2: Replacing with actual content..."
echo "────────────────────────────────────────────────"

# Loop through each file and replace with actual content
for file in "${POST_FILES[@]}"; do
    if [ -f "$SOURCE_DIR/$file" ]; then
        echo "  → Replacing $file with actual content"
        cp "$SOURCE_DIR/$file" "$TARGET_DIR/$file"
    fi
done

echo ""
echo "════════════════════════════════════════════════"
echo "✓ All posts deployed successfully!"
echo "════════════════════════════════════════════════"
echo "Next steps:"
echo "  cd $HUGO_SITE"
echo "  hugo server"
echo ""
```

**When to generate this script:**
- After creating multiple posts in a learning/staging directory
- When working in any directory OTHER than the main Hugo site
- Name the script descriptively (e.g., `copy_posts_to_hugo.sh`)
- Make it executable immediately after creation

**IMPORTANT - POST_FILES Array Management:**
- **Always clear the entire `POST_FILES` array** before adding new entries
- **Add ONLY the posts you just created** in the current session
- Do NOT append to existing posts from previous sessions
- Each time you create new posts, replace the entire array with only those new post filenames
- This keeps the deployment script focused on deploying only what was just created in that session

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
4. **Date recency**: ⚠️ **CRITICAL** - Always set the date to the current date for new posts. Historical dates (especially dates from the past that are far away) may cause Hugo to exclude the post from site listings. Posts with old dates may appear to be unpublished even though the HTML file is generated.
5. **Chronological ordering**: Posts appear in reverse chronological order (newest first) on the homepage based on their `date` field. Adjust dates to control post ordering.
6. **Draft status**: Start with `draft = true` for review, then change to `false` to publish
7. **Content structure**: Use clear headings to organize content
8. **Deployment script**: Always generate a bash script to copy posts from staging to the main Hugo site
9. **Script naming**: Use descriptive names like `copy_posts_to_hugo.sh` or `deploy_posts_YYYYMMDD.sh`

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
