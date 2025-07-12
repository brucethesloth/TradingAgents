# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TradingAgents is a Python-based multi-agent LLM financial trading framework that simulates a trading firm with specialized AI agents. It uses LangGraph for agent orchestration and supports multiple LLM providers.

## Key Architecture

The system implements a collaborative multi-agent architecture:
- **Analysts**: Analyze company fundamentals, market trends, sentiment, and news
- **Researchers**: Bull and Bear researchers debate investment opportunities
- **Risk Managers**: Evaluate and debate risk levels
- **Research Manager**: Synthesizes research into actionable decisions
- **Trader**: Executes decisions based on collective intelligence

Agent communication flows through LangGraph workflows defined in `tradingagents/graph/`.

## Common Development Commands

```bash
# Install dependencies
pip install -r requirements.txt

# Install package in development mode
pip install -e .

# Run the CLI application
python -m cli.main
# or after installation:
tradingagents

# Start the API server
python -m tradingagents_api.start_server

# Run the main example script
python main.py
```

## Important Configuration

1. **API Keys**: Set in environment variables or `.env` file:
   - `OPENAI_API_KEY`
   - `ANTHROPIC_API_KEY`
   - `FINNHUB_API_KEY`
   - `OPENROUTER_API_KEY`
   - `LANGCHAIN_API_KEY` (for tracing)

2. **LLM Configuration**: Modify `tradingagents/default_config.py`:
   - Default model: "openai/gpt-4o-mini"
   - Supports OpenAI, Anthropic, Google, Ollama, OpenRouter
   - Temperature settings for each agent type

3. **Python Version**: Requires Python >=3.10 (3.12 recommended)

## Project Structure Guidelines

- Agent implementations: `tradingagents/agents/`
- Data fetching logic: `tradingagents/dataflows/`
- LangGraph workflows: `tradingagents/graph/`
- API endpoints: `tradingagents-api/app/api/v1/endpoints/`
- CLI interface: `cli/`

## API Development

The FastAPI application in `tradingagents-api/` provides REST endpoints:
- Market analysis: `/api/v1/reports/market`
- Sentiment analysis: `/api/v1/reports/sentiment`
- News analysis: `/api/v1/reports/news`
- Fundamentals: `/api/v1/reports/fundamentals`

API uses JWT authentication with API key fallback. See `tradingagents-api/README.md` for deployment details.

## Testing Approach

Currently no formal test suite exists. When implementing tests:
- Use pytest for unit testing
- Test agent logic in isolation
- Mock external API calls (FinnHub, Yahoo Finance)
- Test LangGraph workflow transitions

## Code Conventions

- Use type hints throughout
- Follow async/await patterns for I/O operations
- Implement Pydantic models for data validation
- Keep agent logic modular and testable
- Use environment variables for configuration
- Log important decisions and errors

## Key Dependencies

- **LangChain/LangGraph**: Agent orchestration
- **yfinance/finnhub**: Market data
- **backtrader**: Backtesting framework
- **FastAPI**: REST API
- **Chainlit**: UI interface
- **Rich**: CLI formatting