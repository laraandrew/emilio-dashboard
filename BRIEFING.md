# Morning Briefing Format

## When
7:00 AM America/Los_Angeles, daily. Delivered via Telegram to Andrew (8389365775).

## Tools to run (in order)
1. `weather-current` — today's weather
2. `calendar-today work` and `calendar-today personal` — today's events
3. `calendar-week work` — next 7 days (for upcoming prep note)
4. `todoist-today` — tasks due today
5. `gmail-digest work` and `gmail-digest personal` — unread counts
6. `lichess-account` — current ratings

## Message format

```
Good morning, Andrew. [Day], [Date].

🌤 Weather: [temp]°F, [description]. [Wind if notable.]

📅 Today ([count] events):
• [Time] – [Event name] [location if present]
• [Time] – [Event name]
(or: Nothing on the calendar today.)

✅ Tasks due today ([count]):
• [!] [Task] (priority 4 = urgent marker)
• [Task]
(or: No tasks due today.)

📬 Email: [N] unread work, [M] unread personal
[If any were flagged overnight by triage: ⚠️ Flagged: [From] – [Subject]]

♟ Chess: Blitz [rating] · Rapid [rating]

💡 [One proactive note — e.g.: "You have 3 tasks due and a meeting at 2pm — want me to block focus time?" or "Pay electricity bill is due in 5 days." or "You have nothing scheduled — good day to push on [top project]."]
```

## Rules
- Keep it under 4096 chars (Telegram limit)
- Use emoji sparingly — only the section markers above
- If an event has a location, include it briefly
- Proactive note: pick ONE most relevant observation. Don't list multiple suggestions.
- Don't add filler or pleasantries beyond "Good morning"
- Priority 4 tasks (urgent) get the [!] marker
- If nothing is due, say so — don't pad with low-priority tasks
- Temps in °F, wind in mph
