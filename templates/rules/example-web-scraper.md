# Web Scraper Project Rules

> Auto-loaded when working in web scraper project directories.

## Anti-Ban Strategy

- Always rotate User-Agent headers. Maintain a pool of at least 10 recent browser UAs.
- Implement exponential backoff on 429/503 responses. Start at 2s, max 60s.
- Respect `robots.txt` unless explicitly told otherwise by the user.
- Never send more than 1 request/second to the same domain by default.

## Cookie Management

- Store cookies in a shared JSON file, not hardcoded.
- Cookie path: `<YOUR_PROJECT_PATH>/shared_cookies/cookies.json`
- Always check cookie expiry before use. Re-authenticate if expired.
- Never log or commit cookie values — treat them as secrets.

## Data Pipeline

- Raw HTML → parsed data → validated output. Never skip validation.
- Use CSS selectors as primary strategy, XPath as fallback.
- If a selector breaks (empty result on a page that should have data), stop and report — do not silently continue.

## Error Handling

- Log failed URLs to `failed_urls.json` with timestamp and error type.
- Retry failed requests up to 3 times before marking as failed.
- On captcha detection: stop immediately, notify user, do not attempt to solve.

## Environment

- Always use `aiohttp` or `httpx` for async HTTP (Python).
- For JS projects, use `got` or `axios` — never raw `fetch` without timeout.
- Proxy configuration via environment variable `HTTP_PROXY`, never hardcoded.
