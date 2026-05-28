# Design System — OWE

**Active iteration:** [v1 Industrial Utilitarian](./design/v1/)  
**Implementation:** Tailwind CSS v4 + [shadcn/ui](https://ui.shadcn.com/)

## Product Context

- **What this is:** Regulated web3 token launch and trading platform — users onboard with identity verification, register interest in launches, bid in auction-style bonding curve sales, and trade tokens post-launch.
- **Who it's for:** Professional and institutional traders.
- **Space/industry:** DeFi / crypto trading and token launchpads (peers: Hyperliquid, dYdX, Fjord Foundry, CoinList).
- **Project type:** Responsive web app with mobile-native design language (not a native app yet, but mobile-first UX).
- **Memorable thing:** *Serious software for serious money.*

## Aesthetic Direction

- **Direction:** Industrial Utilitarian — terminal density with mobile-native calm.
- **Decoration level:** Minimal — typography, spacing, and data visualization carry the design. No gradients in data areas, no memecoin aesthetics.
- **Mood:** Trustworthy, precise, institutional. Feels like placing a structured bid at an auction house, not chasing a memecoin.
- **Reference sites:** Hyperliquid, dYdX, Kraken Pro (trading); Fjord Foundry (launch mechanics — anti-reference for visual style).

## Product Modes

One visual system across account, launch, and trading flows. Decoration level increases only in **onboarding** (trust-building); all other modes stay minimal per aesthetic direction.

### Mode map

| Group | Mode | Purpose | Primary layout |
|-------|------|---------|----------------|
| **Account** | Onboarding | Regulated signup — auth, profile, KYC | Multi-step wizard |
| **Account** | Login | Returning user auth | Centered auth card |
| **Platform** | Notifications | Feedback for actions and system events | Sonner toasts (overlay) |
| **Launch** | Discovery | Pre-launch interest registration | Launch catalog (card grid) |
| **Launch** | Auction | Live bonding curve bidding | Curve chart + bid panel |
| **Trading** | Terminal | Post-launch open market | 3-column terminal |

Navigation after onboarding (mobile bottom tabs / desktop top nav): **Launches** · **Markets** · **Trade** · **Portfolio**

---

### Onboarding

Regulated exchange signup. Target: **complete in under 1 minute** for a prepared user. Visually rich and reassuring — the one place we use intentional polish (progress UI, step illustrations, subtle surface depth) without crossing into marketing fluff.

**Auth methods (step 1):**

- **Passkey** — primary CTA; WebAuthn registration; label: “Create passkey”
- **Google OAuth** — secondary; “Continue with Google” with standard Google button styling on neutral surface

Do not offer email/password. Do not surface wallet connect during onboarding — account is fintech-style first; wallet linking is a later step if needed.

**Wizard steps:**

| Step | Fields | Notes |
|------|--------|-------|
| 1 — Account | Passkey or Google OAuth | Single screen; both options visible; no other fields |
| 2 — Profile | Full name, email | Email pre-filled and locked if from Google OAuth |
| 3 — Address | Street, city, state/province, postal code, country | Country select + structured address; inline validation |
| 4 — Phone | Phone number | E.164 input with country code picker; SMS verify stubbed for now |
| 5 — Identity | KYC | **Stubbed** — show “Verify identity” panel with placeholder upload zone and “Coming soon” or simulated success; do not block app entry in dev |

**UX requirements:**

- **Progress indicator** — horizontal stepper at top (5 steps); completed steps show checkmark; current step highlighted with `--primary`
- **One primary action per step** — “Continue” full-width button, min 48px height on mobile
- **Back** — ghost button or chevron; preserves entered data
- **Time estimate** — subtle copy under stepper: “About 1 minute”
- **Save progress** — persist partial onboarding to session/local storage; resume if user refreshes
- **Inline validation** — errors on blur, not on every keystroke; shadcn `Form` + `FormMessage`
- **Layout** — centered column, max-width 480px mobile / 440px desktop; full viewport height; optional subtle gradient on `--background` (auth surfaces only — not used in trading views)
- **Light mode default** for onboarding — regulated signup reads more trustworthy on light surfaces; user can switch theme after entry

**Visual richness (onboarding only):**

- Step transition: slide + fade, 200ms ease-out
- Card elevation: `--surface-elevated` with soft shadow
- Optional icon or minimal illustration per step (identity, location, phone) — line-style, monochrome + accent, not stock photos
- Success confetti **disabled** — use a simple checkmark animation on completion

---

### Login

Returning users. **Simple and clean** — no wizard, no decoration beyond the auth card.

**Auth methods:**

- **Passkey** — primary: “Sign in with passkey”
- **Google OAuth** — secondary: “Continue with Google”

**Layout:**

- Centered card, max-width 400px
- OWE wordmark above card
- Both auth options stacked vertically with 12px gap
- Footer link: “Create an account” → onboarding
- No password field, no “forgot password”

**States:**

- Loading — disable buttons, spinner on active method
- Error — Sonner toast (see Notifications) + inline message on card if auth fails

---

### Notifications

System-wide feedback via **[Sonner](https://sonner.emilkowal.ski/)** (install through shadcn: `npx shadcn@latest add sonner`).

**Placement:**

| Viewport | Position |
|----------|----------|
| Desktop | `top-center`, 16px from top |
| Mobile | `top-center`, `env(safe-area-inset-top) + 12px` offset |

**Stacking:** max 3 visible; expand downward; dismiss via swipe (mobile) or close button.

**Toast variants** — map to design tokens:

| Variant | Use | Styling |
|---------|-----|---------|
| `success` | Bid placed, order filled, onboarding step complete | `--success` icon/border accent |
| `error` | Failed tx, validation block, auth failure | `--destructive` |
| `info` | Auction starting, registration reminder | `--primary` |
| `warning` | Approaching liquidation, low balance | `--warning` |
| `loading` | Pending tx, KYC processing | `--muted-foreground` + spinner |
| `default` | Neutral system messages | `--foreground` on `--card` |

**Trading-specific toasts** (use `font-data` for numbers in description):

- Order filled: “Bought 10,000 OWE @ $0.0847”
- Bid confirmed: “Bid placed — 58,912 OWE expected”
- Tx pending: loading toast with link to explorer (stub ok)

**Rules:**

- Toasts are **non-blocking** — never gate critical UI behind a toast
- Destructive actions (cancel order) use `AlertDialog`, not toast
- Duplicate suppression — same message within 3s collapses to one toast
- `richColors: false` — use token-mapped borders/icons, not Sonner default saturated fills
- Theme follows app: pass `theme={resolvedTheme}` from next-themes or equivalent

**Sonner + shadcn setup:**

```tsx
// app/layout.tsx
import { Toaster } from "@/components/ui/sonner"

<Toaster
  position="top-center"
  toastOptions={{
    classNames: {
      toast: "bg-card text-foreground border-border font-sans",
      description: "text-muted-foreground",
    },
  }}
/>
```

Extend `components/ui/sonner.tsx` to apply `--success`, `--destructive`, `--warning` border-left accents per variant.

---

### Launch & trading modes

Unchanged core flows — same component families as v1:

| Mode | Phase | Primary layout |
|------|-------|----------------|
| **Discovery** | Pre-launch interest registration | Launch catalog (card grid) |
| **Auction** | Live bonding curve bidding | Curve chart + bid panel |
| **Trading** | Post-launch open market | 3-column terminal |

## Visual tokens

Colors, typography, spacing, and radius are **version-scoped** — they live in the active iteration folder, not here.

| Active (v1) | Purpose |
|-------------|---------|
| [`design/v1/tokens.css`](./design/v1/tokens.css) | Canonical CSS variables (edit to change colors) |
| [`design/v1/TOKENS.md`](./design/v1/TOKENS.md) | Human-readable token tables + v1 rationale |
| [`design/v1/globals.css`](./design/v1/globals.css) | Tailwind v4 `@theme inline` |
| [`design/v1/preview.html`](./design/v1/preview.html) | Visual proof |

**Rules that apply to all versions:**

- **Color approach:** Restrained — neutrals dominate; accent is rare; green/red **only** for P&L and market direction
- **Data typography:** IBM Plex Mono with `tabular-nums` for all prices and quantities
- Apply `font-data` or `data-financial` on financial values

To iterate colors or fonts, fork `design/v1/` → `design/v2/` and edit tokens there. See [`design/README.md`](./design/README.md) for the full v2 process. Promote v2 by updating the **Active iteration** pointer at the top of this file.

## Layout

- **Approach:** Hybrid — grid-disciplined terminal on desktop; stacked cards + bottom sheets on mobile
- **Launch catalog:** Responsive card grid (1 col mobile → 2 → 3 desktop)
- **Auction detail:** Chart (1.4fr) + bid panel (1fr) on desktop; stacked + bottom sheet on mobile
- **Trading terminal:** Markets (200px) | Chart (flex) | Order panel (260px) on desktop; stacked on mobile
- **Max content width:** Full-bleed for trading/launch views; 1280px for settings/marketing; **440px** for onboarding/login auth columns
- **Border radius:** See [`design/v1/TOKENS.md`](./design/v1/TOKENS.md) — sm 4px · md 8px · lg 12px

## Motion

- **Approach:** Minimal-functional — only transitions that aid comprehension
- **Easing:** enter ease-out · exit ease-in · move ease-in-out
- **Duration:** micro 50–100ms · short 150–250ms · medium 250–400ms
- **Patterns:** Order/bid confirmation tick; throttled price ticks; auction countdown; onboarding step slide-fade (200ms)
- **Accessibility:** Respect `prefers-reduced-motion`

## shadcn/ui Components

Build on [shadcn/ui](https://ui.shadcn.com/) primitives. Prefer composing existing components over custom CSS.

| Domain component | shadcn building blocks |
|------------------|------------------------|
| `OnboardingWizard` | `Card`, `Form`, `Input`, `Button`, `Select`, `Progress` |
| `OnboardingStepper` | Custom horizontal stepper — 5 steps, checkmarks on complete |
| `PasskeyButton` | `Button` variant `default` + fingerprint icon |
| `GoogleOAuthButton` | `Button` variant `outline` + Google logo (official colors on icon only) |
| `KYCStubPanel` | `Card`, dashed `border`, `Button` “Verify identity” (no-op in dev) |
| `LoginCard` | `Card`, `PasskeyButton`, `GoogleOAuthButton` |
| `LaunchCard` | `Card`, `Badge`, `Progress` |
| `BondingCurveChart` | Custom (Canvas/SVG) + `Card` wrapper |
| `BidPanel` / `OrderPanel` | `Card`, `Input`, `Slider`, `Button`, `Tabs` |
| `InterestRegistrationForm` | `Form`, `Input`, `Button`, `Checkbox` |
| `LifecycleBadge` | `Badge` variants: `upcoming`, `live`, `trading` |
| `AuctionCountdown` | `Badge` + monospace `font-data` |
| `AppToaster` | Sonner via `components/ui/sonner` — themed to tokens |
| Bottom tab nav (mobile) | Custom — 44px touch targets, safe-area padding |

Register custom Badge variants in `components/ui/badge.tsx` for lifecycle states.

**Third-party:** [Sonner](https://sonner.emilkowal.ski/) for toasts — add via shadcn CLI, theme with `design/v1/tokens.css` variables.

## Tailwind v4

Import from the **active iteration** folder:

```css
@import "../design/v1/globals.css";  /* change to v2 when promoted */
```

See [`design/v1/globals.css`](./design/v1/globals.css). Use semantic utilities: `bg-background`, `text-muted-foreground`, `bg-primary`, `text-market-up`, `font-data`.

## Design iterations

Versioned token + preview explorations live in [`design/`](./design/). **Do not duplicate hex values in this file.**

| Step | Action |
|------|--------|
| Fork | `cp -r design/v1 design/v2` |
| Edit | `v2/tokens.css` → `v2/TOKENS.md` → `v2/preview.html` |
| Compare | Open both previews side by side |
| Promote | Update **Active iteration** header above; app imports `v2/globals.css` |

Full workflow: [`design/README.md`](./design/README.md)

Preview v1: `open design/v1/preview.html`

## Decisions Log

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-05-28 | v1 Industrial Utilitarian shipped | `/design-consultation` — pro/institutional launch + trade platform |
| 2026-05-28 | IBM Plex Mono for all financial data | Terminal credibility vs generic crypto sans |
| 2026-05-28 | Unified bid panel → order panel | One component family across auction and trade lifecycle |
| 2026-05-28 | Light mode as equal citizen | Institutional desk traders expect polished light mode |
| 2026-05-28 | Tailwind v4 + shadcn/ui stack | User requirement; tokens mapped in `design/v1/` |
| 2026-05-28 | Steel blue `#4A7BF7` accent | Avoid purple/teal crypto convergence (dYdX, Hyperliquid) |
| 2026-05-28 | Passkey + Google OAuth only | Regulated fintech onboarding; no email/password |
| 2026-05-28 | Onboarding light-mode default | Trust signal for regulated signup |
| 2026-05-28 | Sonner for notifications | shadcn-compatible; web + mobile safe-area |
| 2026-05-28 | KYC stubbed in onboarding | Identity step present in UX; backend stubbed for now |

## Anti-patterns (never use)

- Purple/violet gradients as default accent
- Memecoin / pump.fun aesthetics on launch cards
- 3-column SaaS feature grids with icon circles
- Green/red anywhere except P&L and market direction
- Inter, Roboto, Space Grotesk as primary fonts
- Gamified launch leaderboards (conflicts with institutional positioning)
- Email/password login (passkey + OAuth only)
- Blocking modal alerts for success/error (use Sonner toasts or `AlertDialog` for confirmations)
- Wallet-connect as first onboarding step (account before chain)
