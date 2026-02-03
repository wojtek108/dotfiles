#!/usr/bin/env python3
"""Token cost tracker for Claude Haiku 4.5"""
import json
import sys
import re

try:
    import tiktoken
except ImportError:
    import subprocess
    try:
        subprocess.check_call([sys.executable, "-m", "pip", "install", "--user", "tiktoken"])
    except subprocess.CalledProcessError:
        # Fallback: try with break-system-packages
        try:
            subprocess.check_call([sys.executable, "-m", "pip", "install", "--break-system-packages", "tiktoken"])
        except subprocess.CalledProcessError:
            print("Error: Could not install tiktoken. Please install manually with: pip install --user tiktoken")
            sys.exit(1)
    import tiktoken

def estimate_tokens(text):
    """Estimate tokens using cl100k_base encoding (approximate for Claude)"""
    encoding = tiktoken.get_encoding("cl100k_base")
    return len(encoding.encode(text))

def calculate_costs(input_tokens, output_tokens, model="claude-haiku-4-5"):
    """Calculate costs based on current pricing for Haiku 4.5"""
    pricing = {
        "claude-haiku-4-5": {
            "input": 0.80,    # per million tokens
            "output": 4.00    # per million tokens
        }
    }

    rates = pricing.get(model, pricing["claude-haiku-4-5"])
    input_cost = (input_tokens / 1_000_000) * rates["input"]
    output_cost = (output_tokens / 1_000_000) * rates["output"]

    return {
        "input_tokens": input_tokens,
        "output_tokens": output_tokens,
        "total_tokens": input_tokens + output_tokens,
        "input_cost": input_cost,
        "output_cost": output_cost,
        "total_cost": input_cost + output_cost
    }

def format_results(results):
    """Format results for display"""
    return f"""
Token Usage Summary (Haiku 4.5)
================================
Input tokens:  {results['input_tokens']:,}
Output tokens: {results['output_tokens']:,}
Total tokens:  {results['total_tokens']:,}

Cost Breakdown
==============
Input cost:  ${results['input_cost']:.4f}
Output cost: ${results['output_cost']:.4f}
Total cost:  ${results['total_cost']:.4f}
"""

def parse_conversation_data(data):
    """Parse conversation data and estimate tokens"""
    if isinstance(data, str):
        # If it's JSON string, parse it
        try:
            data = json.loads(data)
        except json.JSONDecodeError:
            # If it's just plain text, estimate directly
            return estimate_tokens(data), 0

    input_text = ""
    if isinstance(data, dict):
        # Extract all message content
        messages = data.get("messages", [])
        for msg in messages:
            if isinstance(msg, dict):
                input_text += msg.get("content", "") + " "
    elif isinstance(data, list):
        # List of messages
        for msg in data:
            if isinstance(msg, dict):
                input_text += msg.get("content", "") + " "
            else:
                input_text += str(msg) + " "

    return estimate_tokens(input_text), 0

def main():
    """Main entry point"""
    input_data = None

    # Try to read from command line arguments first
    if len(sys.argv) > 1:
        input_data = sys.argv[1]
    else:
        # Try to read from stdin
        try:
            input_data = sys.stdin.read()
        except:
            input_data = None

    if not input_data:
        # Default: demonstrate with sample data
        print("Token Cost Tracker (Claude Haiku 4.5)")
        print("=" * 40)
        print("\nUsage: python tracker_haiku.py '<conversation_data_or_json>'")
        print("\nExample: Calculate costs for a sample conversation...")

        sample_data = "This is a sample conversation text to estimate token costs."
        tokens = estimate_tokens(sample_data)
        results = calculate_costs(tokens, int(tokens * 0.3))  # Rough estimate for output
        print(format_results(results))
        return

    # Parse input and calculate
    input_tokens, _ = parse_conversation_data(input_data)

    # Estimate output tokens as roughly 30% of input
    output_tokens = max(100, int(input_tokens * 0.3))

    results = calculate_costs(input_tokens, output_tokens)
    print(format_results(results))

if __name__ == "__main__":
    main()
