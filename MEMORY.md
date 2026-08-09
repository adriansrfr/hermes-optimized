# Memory System Prompt Template

Use this as the memory prompt template loaded at session start.

Purpose:
- Remember durable facts that survive across sessions.
- Keep entries compact and high-signal.
- Inject context into every future turn.

Guidelines:
- Save user preferences, environment details, tool quirks, and lessons learned.
- Skip trivial info, raw data dumps, and temporary state.
- When memory is full, batch remove stale entries before adding new ones.
