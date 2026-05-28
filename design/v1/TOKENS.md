# v1 Tokens — Industrial Utilitarian

**Canonical source:** [`tokens.css`](./tokens.css) (machine-readable) · this file (human-readable)  
**Preview:** [`preview.html`](./preview.html) · **Tailwind:** [`globals.css`](./globals.css)

When iterating v2, copy this folder and edit `tokens.css` + this file first — then update `preview.html` to match.

## Color

- **Approach:** Restrained — neutrals dominate; accent is rare and meaningful; green/red **only** for P&L and market direction.

### Dark mode (primary for traders)

| Token | Hex | CSS variable | Usage |
|-------|-----|--------------|-------|
| background | `#0C0D0F` | `--background` | Page bg |
| card / surface | `#151619` | `--card` | Panels, cards |
| surface-elevated | `#1C1D21` | `--surface-elevated` | Nested panels, inputs |
| border | `#2A2B30` | `--border` | 1px dividers |
| foreground | `#F4F4F5` | `--foreground` | Primary text |
| muted-foreground | `#8B8D97` | `--muted-foreground` | Labels, secondary |
| primary (accent) | `#4A7BF7` | `--primary` | CTAs, links, curve |
| success / market-up | `#22C55E` | `--success`, `--market-up` | Gains, buy confirm |
| destructive / market-down | `#EF4444` | `--destructive`, `--market-down` | Losses, sell, errors |
| warning | `#F59E0B` | `--warning` | Low balance, cautions |

### Light mode

| Token | Hex | CSS variable |
|-------|-----|--------------|
| background | `#FAFAFA` | `--background` |
| card | `#FFFFFF` | `--card` |
| border | `#E4E4E7` | `--border` |
| foreground | `#18181B` | `--foreground` |
| muted-foreground | `#71717A` | `--muted-foreground` |
| primary | `#4A7BF7` | `--primary` |
| success | `#16A34A` | `--success` |
| destructive | `#DC2626` | `--destructive` |

### Sonner toast accents

| Variant | Maps to |
|---------|---------|
| success | `--toast-success` → `--success` |
| error | `--toast-error` → `--destructive` |
| warning | `--toast-warning` → `--warning` |
| info | `--toast-info` → `--primary` |

## Typography

| Role | Font | CSS variable |
|------|------|--------------|
| Display/Hero | General Sans | `--font-display` |
| Body/UI | DM Sans | `--font-body`, `--font-sans` |
| Data/Tables/Prices | IBM Plex Mono | `--font-mono` |
| Code | JetBrains Mono | `--font-code` |

**Scale:** 0.6875rem · 0.8125rem · 0.9375rem · 1rem · 1.25rem · 1.5rem · 2.5rem

## Spacing

- **Base unit:** 4px
- **Scale:** 1(4) · 2(8) · 3(12) · 4(16) · 5(24) · 6(32) · 7(48) · 8(64)
- **Touch targets:** 44px minimum on mobile

## Radius

| Token | Value |
|-------|-------|
| sm | 4px |
| md / `--radius` | 8px |
| lg | 12px |
| full | 9999px (badges only) |

## v1 rationale (why these values)

- **Steel blue `#4A7BF7`** — avoids purple/teal crypto convergence (dYdX, Hyperliquid)
- **Near-black `#0C0D0F`** — not pure black; easier on eyes for long sessions
- **IBM Plex Mono for data** — institutional terminal credibility
