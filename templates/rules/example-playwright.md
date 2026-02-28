# Playwright Automation Rules

> Auto-loaded when working in browser automation / E2E testing projects.

## Element Location Strategy

- Priority order: `data-testid` → `role` selector → CSS selector → XPath.
- Never use auto-generated class names (e.g., `css-1a2b3c`) — they break on rebuild.
- Always add a fallback selector. If primary selector fails, try the fallback before reporting error.

## Popup & Dialog Handling

- Register a dialog handler BEFORE the action that triggers it:
  ```js
  page.once('dialog', dialog => dialog.accept());
  await page.click('#delete-button');
  ```
- Handle cookie consent banners at the start of every test flow.
- Check for and dismiss overlay modals before interacting with page elements.

## Timeout Strategy

- Default navigation timeout: 30s. Action timeout: 10s.
- For slow-loading SPAs, use `waitForLoadState('networkidle')` after navigation.
- Never use `page.waitForTimeout()` (hard sleep) — use `waitForSelector()` or `waitForResponse()` instead.
- If an element isn't found within timeout, take a screenshot before failing.

## Screenshot & Evidence

- Take screenshots on every failure: `page.screenshot({ path: 'failure-${Date.now()}.png', fullPage: true })`.
- For visual regression tests, use `toHaveScreenshot()` with a threshold of 0.2.
- Store screenshots in a `screenshots/` directory that is gitignored.

## Browser Context

- Use `browser.newContext()` for test isolation — never share state between tests.
- Set a realistic viewport: `{ width: 1280, height: 720 }` minimum.
- Enable `acceptDownloads: true` if the flow involves file downloads.

## Authentication Flows

- Save auth state to a JSON file after first login, reuse in subsequent tests:
  ```js
  await context.storageState({ path: 'auth-state.json' });
  ```
- Never hardcode credentials in test files. Use environment variables or a `.env` file.

## CI/CD Considerations

- Always run with `--headed` locally, `--headless` in CI.
- Use `retries: 2` in CI config for flaky network-dependent tests.
- Set `CI=true` environment variable to enable CI-specific behaviors.
