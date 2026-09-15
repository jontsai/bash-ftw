# Port-scoped Brave CDP restart

Goal: honor CDP_PORT (fallback 9222), restart only the current user's Brave listener on that exact TCP port, and preserve existing browser data.

Acceptance: invalid ports, foreign listeners, unrelated applications, and an already-open non-target Brave must not be killed. Gracefully stop the matched browser, wait for exit, launch with the selected port, and report readiness or failure.

Files: dotfiles/.bashrc.ftw.mac; tests/brave-cdp.sh.

Validation: bash syntax and mocked process/launch tests without touching real browser sessions. Do not run the broad installer against the live home during review.
