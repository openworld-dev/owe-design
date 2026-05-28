# owe-design

AI-assisted design work in this repo uses [gstack](https://github.com/garrytan/gstack).

## gstack

gstack skills are installed **in this repo** at `.cursor/skills/gstack-*`. Read the matching `SKILL.md` when a workflow below applies.

**Web browsing:** Use the gstack `/browse` skill for all web browsing. Prefer gstack browser tooling over generic browser MCP tools when both are available.

**Install / refresh (project-local):**

```bash
# one-time: clone and build gstack source (defaults to ~/gstack)
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/gstack
cd ~/gstack && ./setup && bun run gen:skill-docs --host cursor

# link skills into this repo
./scripts/setup-gstack.sh
```

**Upgrade:** `cd ~/gstack && git pull && ./setup && bun run gen:skill-docs --host cursor && cd - && ./scripts/setup-gstack.sh`

### Workflow skills

| Skill | When to use |
|-------|-------------|
| `/office-hours` | Start here — reframe the product before writing code |
| `/plan-ceo-review` | Strategic scope and product challenge |
| `/plan-eng-review` | Architecture, data flow, edge cases, tests |
| `/plan-design-review` | Design quality review (0–10 rubric) |
| `/plan-devex-review` | Developer experience review |
| `/autoplan` | CEO → design → eng → DX review in one pass |
| `/design-consultation` | Build a design system from scratch |
| `/design-shotgun` | Generate and compare design variants |
| `/design-html` | Production-quality HTML/CSS mockups |
| `/design-review` | Live-site visual audit and fix loop |
| `/review` | Pre-merge PR review |
| `/investigate` | Root-cause debugging before fixes |
| `/qa` | Browser QA on a URL — find and fix bugs |
| `/qa-only` | Browser QA report only (no code changes) |
| `/ship` | Test, review, push, open PR |
| `/land-and-deploy` | Merge, wait for deploy, verify production |
| `/canary` | Post-deploy monitoring |
| `/cso` | Security audit (OWASP + STRIDE) |
| `/browse` | Headless browser automation |
| `/retro` | Engineering retrospective |
| `/document-release` | Update docs after a release |
| `/gstack-upgrade` | Update gstack to latest |

### Safety

| Skill | When to use |
|-------|-------------|
| `/careful` | Warn before destructive commands |
| `/freeze` | Lock edits to one directory |
| `/guard` | Careful + freeze together |
| `/unfreeze` | Remove edit restrictions |
