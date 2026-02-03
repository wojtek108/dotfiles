---
name: token-cost-tracker
description: Calculate total token usage and costs for the current Claude Code project. Use when the user asks about token costs, API usage, or spending on the project.
---

# Token Cost Tracker

This skill analyzes the conversation history to estimate total tokens used and calculate the associated costs for the current Claude Code project. Supports multiple Claude models including Sonnet 4.5 and Haiku 4.5.

## When to Use

- User asks "how much have I spent on tokens?"
- User wants to know total API costs
- User asks about token usage statistics
- User specifies a model like "calculate the session cost for haiku!"
- User wants cost breakdown by model

## How It Works

The skill runs Python scripts that:
1. Accept conversation data (via command-line args or stdin)
2. Parse the text/JSON using `tiktoken` for accurate token counting
3. Calculate costs based on current pricing
4. Display formatted results with cost breakdown

## Scripts

**tracker_haiku.py** (default)
- Estimates tokens using tiktoken library (cl100k_base encoding)
- Applies current pricing for Claude Haiku 4.5
- Outputs formatted results with token and cost breakdown
- Can run standalone or accept input data

**tracker_sonnet.py**
- Estimates tokens using tiktoken library (cl100k_base encoding)
- Applies current pricing for Claude Sonnet 4.5
- Outputs formatted results with token and cost breakdown
- Can run standalone or accept input data

## Usage

To check costs for a conversation:
```bash
python tracker_haiku.py "your conversation text here"
# or
python tracker_sonnet.py "your conversation text here"
```

The scripts will output:
- Total input/output tokens
- Individual costs for input and output
- Combined total cost in USD

## Pricing Reference

Current pricing (verify at https://anthropic.com/pricing):
- Claude Sonnet 4.5: $3.00 per million input tokens, $15.00 per million output tokens
- Claude Haiku 4.5: $0.80 per million input tokens, $4.00 per million output tokens
