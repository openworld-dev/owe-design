# OWE Design

AI-assisted design and implementation for the OWE web3 token launch and trading platform.

## Design System

Always read [DESIGN.md](./DESIGN.md) before making any visual or UI decisions.

- **Active iteration:** `design/v1/` (preview, tokens, Tailwind v4 globals)
- **Stack:** Tailwind CSS v4 + [shadcn/ui](https://ui.shadcn.com/)
- All font choices, colors, spacing, and aesthetic direction are defined in DESIGN.md
- Do not deviate without explicit user approval
- In QA mode, flag any code that doesn't match DESIGN.md

### Quick paths

```bash
open design/v1/preview.html          # visual preview
# Tokens: design/v1/tokens.css         # shadcn CSS variables
# Tailwind: design/v1/globals.css    # v4 @theme inline
```

## Skill routing

When the user's request matches an available skill, invoke it via the Skill tool. When in doubt, invoke the skill.

Key routing rules:

- Product ideas/brainstorming → invoke `/office-hours`
- Strategy/scope → invoke `/plan-ceo-review`
- Architecture → invoke `/plan-eng-review`
- Design system/plan review → invoke `/design-consultation` or `/plan-design-review`
- Full review pipeline → invoke `/autoplan`
- Bugs/errors → invoke `/investigate`
- QA/testing site behavior → invoke `/qa` or `/qa-only`
- Code review/diff check → invoke `/review`
- Visual polish → invoke `/design-review`
- HTML mockups from design system → invoke `/design-html`
- Ship/deploy/PR → invoke `/ship` or `/land-and-deploy`
- Save progress → invoke `/context-save`
- Resume context → invoke `/context-restore`
- Author a backlog-ready spec/issue → invoke `/spec`

See [AGENTS.md](./AGENTS.md) for gstack setup and full skill list.
