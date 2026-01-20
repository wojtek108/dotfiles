# tracker.py
import json

try:
    import tiktoken
except ImportError:
    import subprocess
    import sys
    subprocess.check_call([sys.executable, "-m", "pip", "install", "tiktoken"])
    import tiktoken

def estimate_tokens(text):
    """Estimate tokens using cl100k_base encoding (approximate for Claude)"""
    encoding = tiktoken.get_encoding("cl100k_base")
    return len(encoding.encode(text))

def calculate_costs(input_tokens, output_tokens, model="claude-sonnet-4-5"):
    """Calculate costs based on current pricing"""
    pricing = {
        "claude-sonnet-4-5": {
            "input": 3.00,   # per million tokens
            "output": 15.00  # per million tokens
        }
    }
    
    rates = pricing.get(model, pricing["claude-sonnet-4-5"])
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
Token Usage Summary
==================
Input tokens:  {results['input_tokens']:,}
Output tokens: {results['output_tokens']:,}
Total tokens:  {results['total_tokens']:,}

Cost Breakdown
==============
Input cost:  ${results['input_cost']:.4f}
Output cost: ${results['output_cost']:.4f}
Total cost:  ${results['total_cost']:.4f}
"""

if __name__ == "__main__":
    # This would be called by Claude with conversation data
    # For now, just export the functions
    pass
