---
name: token-cost-tracker
description: Calculate total token usage and costs for the current Claude Code project. Use when the user asks about token costs, API usage, or spending on the project.
---

# Token Cost Tracker

This skill analyzes the conversation history to estimate total tokens used and calculate the associated costs for the current Claude Code project.

## When to Use

- User asks "how much have I spent on tokens?"
- User wants to know total API costs
- User asks about token usage statistics

## Instructions

1. Access the conversation history from Claude Code's context
2. Run `tracker.py` to calculate token counts
3. Calculate costs based on current model pricing
4. Present the results in a clear format showing:
   - Total input tokens
   - Total output tokens
   - Estimated cost in USD
   - Breakdown by model if multiple models were used

## Implementation

The tracker uses the `tracker.py` script which:
- Estimates tokens using tiktoken library
- Applies current pricing for Claude Sonnet 4.5
- Formats results for easy reading

## Pricing Reference

Current pricing (verify at https://anthropic.com/pricing):
- Claude Sonnet 4.5: $3.00 per million input tokens, $15.00 per million output tokens
