# v1 — Industrial Utilitarian

First shipped design system for OWE: web3 token launch platform + pro/institutional trading terminal.

**Memorable thing:** Serious software for serious money.

**Created:** 2026-05-28 via `/design-consultation`

## Files

| File | Purpose |
|------|---------|
| [preview.html](./preview.html) | Visual proof — all product modes |
| [tokens.css](./tokens.css) | **Canonical CSS variables** — edit colors here |
| [TOKENS.md](./TOKENS.md) | Human-readable token tables + v1 rationale |
| [globals.css](./globals.css) | Tailwind v4 `@theme inline` |

## Open preview

```bash
open design/v1/preview.html
```

## shadcn setup notes

When initializing shadcn in the app:

```bash
npx shadcn@latest init
```

Use **New York** or **Default** style (either works; v1 is flat/minimal). Point `css` to your app globals that import `design/v1/globals.css` or copy tokens into `app/globals.css`.

Map trading-specific tokens (`--success`, `--curve-fill`, font roles) alongside shadcn base variables — see `tokens.css`.
