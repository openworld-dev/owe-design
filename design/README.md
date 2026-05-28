# Design iterations

Versioned design system explorations for OWE. Each `design/vN/` folder is a **self-contained iteration** — tokens, preview, and rationale live together.

| Version | Name | Status | Preview |
|---------|------|--------|---------|
| [v1](./v1/) | Industrial Utilitarian | Active | [preview.html](./v1/preview.html) |
| [v2](./v2/) | Arctic Signal | **Draft** | [preview.html](./v2/preview.html) — same layouts as v1, Arctic palette + Bricolage/Outfit |

## Source of truth hierarchy

| Layer | Location | What it holds |
|-------|----------|---------------|
| **Tokens (machine)** | `design/vN/tokens.css` | Hex values, CSS variables — **edit this to change colors** |
| **Tokens (human)** | `design/vN/TOKENS.md` | Same values + rationale for that iteration |
| **Tailwind v4** | `design/vN/globals.css` | `@theme inline` mapping |
| **Visual proof** | `design/vN/preview.html` | All screens using those tokens |
| **Product UX** | root `DESIGN.md` | Modes, flows, components — stable across versions |
| **Active pointer** | root `DESIGN.md` header | Which `vN` the app should import |

Root `DESIGN.md` describes *what* the product looks like and *how* it behaves. Version folders hold *which exact values* implement that — colors, fonts, spacing. Do not duplicate hex tables in `DESIGN.md`.

## Process: create v2

```bash
# 1. Fork the active iteration
cp -r design/v1 design/v2

# 2. Edit token sources (in this order)
#    design/v2/tokens.css   ← change --primary, neutrals, etc.
#    design/v2/TOKENS.md    ← document changes + rationale
#    design/v2/preview.html ← update inline CSS OR link tokens.css (see v2 README)
#    design/v2/README.md    ← name the direction (e.g. "Warmer institutional")

# 3. Register the iteration
#    Add a row to the table above (status: Draft)

# 4. Compare
open design/v1/preview.html
open design/v2/preview.html
# Side-by-side in browser, or run /design-consultation for a guided v2 proposal

# 5. Promote when approved
#    - Update DESIGN.md header: Active iteration → v2
#    - Update all token path references (tokens.css, globals.css)
#    - Mark v1 Archived, v2 Active in this table
#    - App imports design/v2/globals.css (or design/active → symlink)
```

### What to iterate in v2

Typical experiments — each lives entirely in the v2 folder:

- **Accent color** — e.g. cooler `#3B6FD4` vs warmer `#4A7BF7`
- **Neutral temperature** — warm grays vs cool grays in dark mode
- **Typography** — swap General Sans for Cabinet Grotesk
- **Density** — tighter spacing scale for terminal views
- **Onboarding decoration** — more/less gradient on auth shell

Product modes (onboarding steps, launch flows) stay in root `DESIGN.md` unless v2 explicitly changes UX structure.

### Optional: `/design-consultation` for v2

Run the skill with context: *"Fork v1, explore [direction]. Compare against design/v1/TOKENS.md."* It will research, propose, and generate a new preview in `design/v2/`.

### Optional: `/design-shotgun` for variants

Generate multiple color/font variants quickly, then codify the winner as `design/v2/`.

## Implementation stack

All iterations target:

- **Tailwind CSS v4** — `design/vN/globals.css`
- **[shadcn/ui](https://ui.shadcn.com/)** — theme from `design/vN/tokens.css`

When the app exists, import the **active** version:

```css
/* app/globals.css */
@import "../design/v1/globals.css";  /* swap to v2 when promoted */
```

Or symlink for cleaner swaps:

```bash
ln -sfn v2 design/active
# app imports design/active/globals.css
```

## File checklist per version

Every `design/vN/` folder should contain:

- [ ] `tokens.css` — canonical CSS variables
- [ ] `TOKENS.md` — human-readable token reference + iteration rationale
- [ ] `globals.css` — Tailwind v4 entry
- [ ] `preview.html` — visual proof of all product modes
- [ ] `README.md` — iteration name, status, what changed from previous version
