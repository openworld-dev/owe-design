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

One visual system across account, launch, and trading flows. Decoration level increases in **onboarding** (trust-building) and **Home launch spotlight** (investment decision — cinematic atmosphere, data-forward overlay). All other modes stay minimal per aesthetic direction.

### Mode map

| Group | Mode | Purpose | Primary layout |
|-------|------|---------|----------------|
| **Account** | Onboarding | Regulated signup — auth, profile, KYC | Multi-step wizard |
| **Account** | Login | Returning user auth | Centered auth card |
| **Platform** | Notifications | Feedback for actions and system events | Sonner toasts (overlay) |
| **Launch** | Home spotlight | Time-sensitive launch decisions (pending + live) | Full-screen carousel (1–2 slides) |
| **Launch** | Catalog explore | Browse all launches by phase | Filterable card grid (§07) |
| **Launch** | Auction | Live bonding curve bidding | Curve chart + bid panel |
| **Trading** | Terminal | Post-launch open market | 3-column terminal |

Navigation after onboarding (mobile bottom tabs / desktop top nav): **Home** · **Launches** · **Trade** · **Portfolio**

Markets are reached from the Trade screen (pair picker / market list) — not a bottom-tab slot. Keeps four tabs at 44px+ touch targets on mobile.

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

Version-agnostic UX — applies to every `design/vN/` iteration. Token values (colors, fonts) come from the active version folder; behavior and layout live here.

| Surface | Phase | Primary layout | Preview section |
|---------|-------|----------------|-----------------|
| **Home** | Registration + Live auction (spotlight) | Full-screen `LaunchSpotlight` carousel | §06 |
| **Launches** | All phases (explore) | Filterable card grid | §07 |
| **Auction detail** | Live bonding curve | Curve chart + bid panel | §08 |
| **Trade** | Post-launch open market | 3-column terminal | §09 |

Shared chrome on §06–§09: top bar (OWE wordmark · desktop nav · account menu), mobile bottom tabs (Home · Launches · Trade · Portfolio). **No wallet-connect CTA** in app chrome — users authenticate via passkey/OAuth; wallet linking is a later settings action if needed.

**Two launch surfaces — different jobs:**

| Surface | Route (conceptual) | When to use |
|---------|-------------------|-------------|
| Home spotlight | Home tab | 1–2 time-sensitive launches — where users *decide* where to invest |
| Launch catalog | Launches tab | Full catalog — filter, compare, find Trading tokens |

---

#### §06 — Home launch spotlight

The nucleus of the product. Optimized for **rich, one-at-a-time interaction** when there are only one or two pending or live launches — not a repetitive grid. Trading-phase tokens do **not** appear here; they live in the §07 catalog and §09 terminal.

**Design intent:** Full viewport per slide. Cinematic background (muted looped video or still — infrastructure, markets, institutional; never memecoin rockets). Data and copy anchored in the bottom third. Feels like an auction preview, not a SaaS dashboard.

**Information hierarchy (first → third):**

1. Background visual — atmosphere, not content
2. Token name + `LifecycleBadge` + 2-line description clamp
3. Metric row (`font-data`) → primary CTA → carousel chrome (when N > 1)

**Page structure:**

```
┌─ Top bar: OWE | Home·Launches·Trade·Portfolio | Account ────────┐
├─ FULL VIEWPORT LaunchSpotlight slide                              │
│   ┌─ background: video/still + gradient scrim (bottom-heavy) ─┐ │
│   │  [Registration] or [Live ●] badge                           │ │
│   │  Alpha Fund — Institutional vault                           │ │
│   │  Short description (max 2 lines mobile)                     │ │
│   │  847 interested · $2.1M committed · Starts Jun 12           │ │
│   │  [ View details ]  (primary, full-width mobile)             │ │
│   │  ‹ ›  ·  ● ○  ·  All launches →                           │ │
│   └─────────────────────────────────────────────────────────────┘ │
└─ Bottom tabs (mobile): Home active                                ┘
```

**Carousel scope:**

| Included on Home | Excluded from Home |
|------------------|-------------------|
| `Registration` (pending) | `Trading` — use §07 grid / §09 terminal |
| `Live` (active auction) | Bulk catalog browse — use §07 |

Typically **1–2 slides**. Design for N=1 and N=2; do not optimize for long lists.

**Per-slide content by lifecycle:**

| Badge | Background | Metrics (metric row) | Primary CTA | Emotional beat |
|-------|------------|----------------------|-------------|----------------|
| `Registration` | Token-specific muted video or poster | Interest count · Committed capital · Starts date | View details | Curiosity → trust |
| `Live` | Same treatment; optional subtle pulse on badge dot | Raised · Curve price · Time remaining (`AuctionCountdown`) | View details | Urgency → precision |
| `Ended` (fallback when no pending/live) | Desaturated poster/video | Final raised · End date · Outcome label | View results / Trade now | Closure → handoff |

**LaunchSpotlight anatomy:**

- **Background layer** — full-bleed video (loop, muted, no audio) or high-res still; dark gradient scrim from `transparent` → `rgba(12,13,15,0.92)` over bottom 55% for text legibility
- **Content stack** — bottom-aligned, max-width 640px on desktop, 16px horizontal padding mobile, `padding-bottom` clears bottom tab bar + safe area
- **Description** — `--font-body`, 0.9375rem, `--foreground`, max 2 lines (`line-clamp-2`) on mobile so CTA stays above fold
- **Metric row** — `--font-mono`, `tabular-nums`, dot-separated inline items; Live slides use `--primary` on countdown only
- **Primary CTA** — `Button` default, full-width mobile, min 48px height; label **View details** (token detail page spec'd in a later design cycle)
- **Carousel chrome** — prev/next chevron buttons (44px), dot indicators, ghost **All launches →** link to Launches tab grid; **hidden entirely when N=1**
- **Ended fallback slide** — 60% desaturation on background, no pulse animation, `Ended` badge variant, CTAs never imply live bidding

**Carousel interaction:**

- Swipe horizontal on touch; chevron buttons on desktop and as visible affordance on mobile
- Dot tap jumps to slide (when N=2)
- Slide transition: 250ms ease-in-out horizontal translate; `prefers-reduced-motion`: instant cut, no parallax
- Swipe zone: full viewport except top bar and primary CTA hit area

**Visual richness (Home only — extends aesthetic direction):**

- Allowed: muted stock/loop video, gradient scrim, 2–3 intentional motions (video fade-in, slide transition, Live badge pulse)
- Not allowed: purple gradients, decorative blobs, emoji, generic 3-column feature grids, memecoin aesthetics
- Video is **atmosphere** — metrics and badge remain the trust layer; if video fails, poster + content still work

**Wayfinding to §07 catalog:**

- Persistent **All launches →** ghost link in carousel footer (desktop + mobile)
- Launches tab always opens §07 grid — never the carousel

**Interaction states:**

| State | User sees |
|-------|-----------|
| Loading media | Poster frame + shimmer on metric row; video crossfades in when ready |
| Media error | Static poster only; no broken player chrome |
| N=1 active launch | Full-screen slide, no arrows/dots |
| N=2 active launches | Swipe + chevrons + 2 dots |
| No pending/live | Read-only **Ended** spotlight (most recent ended launch) OR educational placeholder — never a blank screen |
| Ended spotlight | Desaturated visual, `Ended` badge, CTA → View results / Trade now if graduated |

**Deferred (later design cycle):** Token detail page — full copy, documents, register/bid actions. Carousel primary CTA targets that page; depth not spec'd here.

---

#### §07 — Launch catalog (explore grid)

Browse surface on the **Launches tab**. Filterable catalog for all phases including Trading — the general explore use case. Complements §06 Home spotlight; does not replace it.

**Information hierarchy (first → third):**

1. Page title + lifecycle filter tabs (what am I looking at?)
2. Launch card grid — name, `LifecycleBadge`, primary metric pair
3. Per-card primary CTA (lifecycle-specific action)

**Page structure:**

```
┌─ Top bar: OWE | Home·Launches·Trade·Portfolio | Account ─┐
├─ "Token launches" (h1)                                      │
├─ Filter tabs: [All] [Registration] [Live] [Trading]           │
├─ Card grid (1 → 2 → 3 cols)                                   │
│   LaunchCard × N                                            │
└─ Bottom tabs (mobile): Launches active                        ┘
```

**Lifecycle routing** — badge sets destination; card CTA matches phase:

| Badge | Card metrics (2-col) | Primary CTA | Tap destination |
|-------|------------------------|-------------|-----------------|
| `Registration` | Interest count · Starts date | Register interest | `/launches/:id/register` (inline sheet or dedicated step) |
| `Live` | Raised · Curve price + progress bar | View auction | §08 auction detail |
| `Trading` | Price · 24h volume | Trade | §09 terminal, pair pre-selected |

Whole card is tappable; CTA button duplicates the same action (larger hit target on mobile).

**LaunchCard anatomy:** token name + subtitle · `LifecycleBadge` · 2 metric cells (`font-data`) · optional progress bar (Registration/Live only) · full-width secondary/outline CTA at card foot.

**Filters:** horizontal `Tabs` — All (default), Registration, Live, Trading. No search in v1; defer search to Markets/Trade.

**Interaction states:**

| State | User sees |
|-------|-----------|
| Loading | 3 skeleton cards, pulse on metrics |
| Empty (filtered) | "No launches in this phase" + link to clear filter |
| Empty (global) | "No token launches yet" + muted illustration line icon |
| Error | Inline alert above grid + Retry button |
| Success (interest registered) | Sonner info + badge updates to show "Registered" chip on card |

---

#### §08 — Live bonding curve auction

**Information hierarchy:**

1. Token header + `LifecycleBadge` (Live Auction) + `AuctionCountdown`
2. Header stat row — Raised · Curve price · Your allocation (if any)
3. Bonding curve chart (primary visual anchor)
4. `BidPanel` — amount · slider · summary · Confirm bid

**Layout:**

| Viewport | Structure |
|----------|-----------|
| Desktop (≥768px) | Chart `1.4fr` + bid panel `1fr`; stats inline in header |
| Mobile | Chart full-width → sticky summary strip → bid panel in **bottom sheet** (min 44px drag handle, 60vh default height) |

**BondingCurveChart:** SVG or canvas; curve stroke `--primary`; fill `--primary` at 12–30% opacity; current position marker uses `--market-up` (position on curve, not P&L — allowed green). Dashed vertical at user bid position. Legend: "Bonding curve" · "Your bid position". Throttle live price tick animation to ≥500ms; respect `prefers-reduced-motion` (static marker only).

**BidPanel** (shared shell with §09 `OrderPanel`):

| Field | Auction mode |
|-------|----------------|
| Title | "Place bid" |
| Input label | Bid amount (USDC) |
| Slider | 0–100% of available USDC |
| Summary rows | Expected tokens · Avg. price · Curve position % |
| CTA | Confirm bid (`Button` primary, full-width) |

**Lifecycle substates on same route:**

| Substate | Chart | Bid panel | Header |
|----------|-------|-----------|--------|
| Registration (pre-live) | Preview curve, muted | Disabled + "Auction starts {date}" | Countdown to start |
| Live | Live curve + marker | Active bid form | Countdown to end |
| Ended | Final curve, frozen | Read-only allocation summary | "Auction ended" badge |

**Interaction states:**

| State | User sees |
|-------|-----------|
| Loading | Chart skeleton + panel skeleton |
| Bid pending | CTA → spinner; loading Sonner |
| Bid success | Sonner success + allocation row updates |
| Bid error | Sonner error + inline `FormMessage` on amount |
| Insufficient balance | Warning Sonner + disabled CTA |

---

#### §09 — Trading terminal

**Information hierarchy:**

1. Selected pair + 24h change (in chart toolbar area)
2. Candlestick chart (primary workspace)
3. Order panel — side toggle · size · est. cost

Secondary: market list (left rail) — pair picker, not the hero.

**Layout:**

| Viewport | Column order |
|----------|--------------|
| Desktop (≥900px) | Markets `200px` \| Chart `flex` \| Order panel `260px` |
| Tablet (768–899px) | Chart full width; markets + order panel side-by-side below |
| Mobile | Chart → order panel (sticky foot) → markets in **Sheet** (trigger: "Markets" in toolbar) |

**OrderPanel** (same component family as §08 `BidPanel`):

| Tab | v1 scope |
|-----|----------|
| Market | Buy/Sell toggle · Size input · slider · Est. cost · Available balance · CTA |
| Limit | Price + Size · Good-til-cancelled (stub label ok in preview) |
| Pro | Disabled tab + "Coming soon" tooltip |

Buy CTA: `--success` fill; Sell CTA: `--destructive` outline (not filled red — avoids mis-tap). Active market row: `--primary` at 8% bg tint.

**Interaction states:**

| State | User sees |
|-------|-----------|
| Loading | Chart skeleton; market list skeleton rows |
| Empty markets | "No markets available" in list panel |
| Order pending | CTA spinner; loading Sonner |
| Order filled | Success Sonner with `font-data` fill details |
| Order rejected | Error Sonner + inline message |

---

#### §06–§09 — User journey (emotional arc)

**Home spotlight path (decision nucleus):**

| Step | User does | User feels | Design supports |
|------|-----------|------------|-----------------|
| 1 | Opens app → Home tab | Immersed — one opportunity fills the screen | Full-bleed visual + bottom-aligned data stack |
| 2 | Reads name, badge, metrics | Trust — "others are committing" | `font-data` metric row; Registration vs Live badge sets expectation |
| 3 | Swipes to second launch (if any) | Comparing — "which fits my thesis?" | Carousel dots + chevrons; only when N=2 |
| 4 | Taps View details | Intent — ready to go deeper | Primary CTA; detail page (later cycle) |
| 5 | Taps All launches | Exploring — "what else exists?" | Escape hatch to §07 grid without breaking immersion |

**Live slide variant:** Step 2 adds urgency via `AuctionCountdown` in metric row — same layout, different emotional accent. Registration slides never show countdown.

**Launches catalog path (explore):**

| Step | User does | User feels | Design supports |
|------|-----------|------------|-----------------|
| 1 | Opens Launches tab or All launches link | Oriented — "full catalog" | Filter tabs + card grid |
| 2 | Filters by phase | In control | Registration / Live / Trading tabs |
| 3 | Taps card or CTA | Committed to a token | Lifecycle-routed action per card |
| 4 | Returns for live auction | Urgency, precision | §08 countdown + curve |
| 5 | Trades post-launch | Flow state, terminal calm | §09 dense terminal |

**Cross-surface journey (launch lifecycle):**

```
Home spotlight (decide) → Token details (learn)* → Register / §08 bid → §09 trade
                              ↓
                    Launches grid (browse anytime)
* Token details — later design cycle
```

**5-second tests:**

- **Home:** User identifies (a) token name, (b) phase badge, (c) primary metric and CTA — from a static screenshot.
- **Launches grid:** User identifies (a) which launches are live, (b) filter state, (c) card CTA for one token.

---

#### §06–§09 — Responsive & accessibility

| Requirement | Spec |
|-------------|------|
| Touch targets | 44px min on tabs, CTAs, carousel chevrons, market rows, slider thumbs |
| Home carousel | Swipe + chevrons; `aria-roledescription="carousel"`; slide `aria-label` includes token name + phase; dots are `tablist` |
| Keyboard (Home) | Tab order: nav → chevrons → dots → CTA → All launches link; Left/Right arrow when carousel focused |
| Keyboard (Launches) | Tab order: nav → filters → cards → in-page CTAs; arrow keys in market list (§09) |
| Landmarks | `nav` (top + bottom), `main`, `aside` (market list / bid panel) |
| Chart | `aria-label` describing pair + last price; table fallback for screen readers (defer v1 impl, document in eng plan) |
| Color | Body ≥16px; contrast ≥4.5:1 on scrim text; market direction never sole indicator (add +/- prefix) |
| Motion | Carousel 250ms; countdown 1s; price ticks throttled; reduced-motion disables video autoplay tick + slide animation |
| Video | `prefers-reduced-motion`: poster only, no autoplay; always provide poster fallback |

---

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

- **Approach:** Hybrid — grid-disciplined terminal on desktop; stacked cards + bottom sheets on mobile; full-bleed spotlight on Home
- **Home spotlight:** Full viewport height minus top bar (and bottom tabs on mobile); content bottom-aligned
- **Launch catalog:** Responsive card grid (1 col mobile → 2 → 3 desktop) on Launches tab
- **Auction detail:** Chart (1.4fr) + bid panel (1fr) on desktop; stacked + bottom sheet on mobile
- **Trading terminal:** Markets (200px) | Chart (flex) | Order panel (260px) on desktop; stacked on mobile
- **Max content width:** Full-bleed for trading/launch views; 1280px for settings/marketing; **440px** for onboarding/login auth columns
- **Border radius:** See [`design/v1/TOKENS.md`](./design/v1/TOKENS.md) — sm 4px · md 8px · lg 12px

## Motion

- **Approach:** Minimal-functional — only transitions that aid comprehension
- **Easing:** enter ease-out · exit ease-in · move ease-in-out
- **Duration:** micro 50–100ms · short 150–250ms · medium 250–400ms
- **Patterns:** Order/bid confirmation tick; throttled price ticks; auction countdown; onboarding step slide-fade (200ms); Home carousel slide (250ms); media crossfade (300ms); Live badge pulse (2s, Registration slides never pulse)
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
| `LaunchSpotlight` | Full-viewport carousel — background video/still, gradient scrim, `LifecycleBadge`, metric row, `Button` CTA, chevrons, dots |
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
| 2026-05-28 | Lifecycle-routed launch cards | Badge + CTA match phase; Registration → interest, Live → auction, Trading → terminal |
| 2026-05-28 | BidPanel / OrderPanel unified | Same component shell across §08 auction and §09 trade |
| 2026-05-28 | No wallet-connect in app chrome | Passkey/OAuth account first; wallet is settings-level later |
| 2026-05-28 | §07–§09 spec in DESIGN.md | Version-agnostic launch/trade UX; `/plan-design-review` sections 7–9 |
| 2026-05-28 | §06 Home launch spotlight | Full-screen carousel for 1–2 pending/live launches; §07 grid stays on Launches tab for explore |
| 2026-05-28 | Home · Launches · Trade · Portfolio nav | Markets folded into Trade; four mobile tabs at 44px targets |
| 2026-05-28 | Token detail page deferred | Carousel CTA = View details; detail page spec'd in later design cycle |

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
