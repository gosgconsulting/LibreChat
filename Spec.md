# Spec.md — Project Specification

## 1) Purpose
Provide a single source of truth for the current tech stack and brand system (colors, typography, theming) to ensure consistent, future development.

## 2) Core Functionality
LibreChat monorepo containing a backend API and a React frontend UI. Feature details are tracked in code and issues; this doc focuses on stack and brand.

## 3) Architecture Overview
- Monorepo: npm workspaces (`package.json` → `api`, `client`, `packages/*`).
- Frontend (`client/`)
  - React 18 + Vite 6 (`client/vite.config.ts`)
  - TypeScript, Jest + Testing Library, Playwright (e2e)
  - Styling: TailwindCSS 3 + PostCSS (`client/tailwind.config.cjs`, `client/postcss.config.cjs`)
  - UI: Radix UI, Headless UI; TanStack Query/Table; i18next; Recoil/Jotai used in codebase
  - PWA: `vite-plugin-pwa` (manifest in `vite.config.ts`)
- Backend (`api/`)
  - Node.js + Express
  - Data: MongoDB via Mongoose; Redis (sessions/rate limit); Meilisearch (search)
  - Auth: Passport strategies (GitHub/Google/Facebook/Discord/etc.), JWT/OIDC
  - File/Media: Multer, Sharp
  - Logging: Winston
  - AI/LLM integrations present via LangChain and provider SDKs (OpenAI, Anthropic, Google, Vertex AI, etc.)

## 4) Brand System
### 4.1 Typography
- Tailwind font families (`client/tailwind.config.cjs`):
  - `sans`: Inter
  - `mono`: Roboto Mono
- Font files resolved via `$fonts` alias (see `client/vite.config.ts`) and declared in `client/src/style.css` with `@font-face`.
- Optional: Söhne family is supported if licensed (commented examples in `style.css`).
- Default decision: Inter (sans) + Roboto Mono (mono) are the defaults; Söhne is not enabled by default.

### 4.2 Color Tokens (CSS Variables)
Defined in `client/src/style.css` using CSS custom properties and consumed by Tailwind via `client/tailwind.config.cjs`.
 
- Primary brand accent: `--brand-purple: #ab68ff` (source: `client/src/style.css`). PWA `theme_color` (`#009688`) is for PWA UI chrome only.

- Base palette (excerpt):
```css
:root {
  --white: #fff;  --black: #000;
  /* Gray */
  --gray-20:#ececf1; --gray-50:#f7f7f8; --gray-100:#ececec; --gray-200:#e3e3e3;
  --gray-300:#cdcdcd; --gray-400:#999696; --gray-500:#595959; --gray-600:#424242;
  --gray-700:#2f2f2f; --gray-800:#212121; --gray-850:#171717; --gray-900:#0d0d0d;
  /* Green */
  --green-50:#ecfdf5; --green-100:#d1fae5; --green-200:#a7f3d0; --green-300:#6ee7b7;
  --green-400:#34d399; --green-500:#10b981; --green-600:#059669; --green-700:#047857;
  --green-800:#065f46; --green-900:#064e3b; --green-950:#022c22;
  /* Red */
  --red-50:#fef2f2; --red-100:#fee2e2; --red-200:#fecaca; --red-300:#fca5a5;
  --red-400:#f87171; --red-500:#ef4444; --red-600:#dc2626; --red-700:#b91c1c;
  --red-800:#991b1b; --red-900:#7f1d1d; --red-950:#450a0a;
  /* Amber */
  --amber-50:#fffbeb; --amber-100:#fef3c7; --amber-200:#fde68a; --amber-300:#fcd34d;
  --amber-400:#fbbf24; --amber-500:#f59e0b; --amber-600:#d97706; --amber-700:#b45309;
  --amber-800:#92400e; --amber-900:#78350f; --amber-950:#451a03;
  /* Brand */
  --brand-purple:#ab68ff;
}
```

- Semantic role tokens (light mode, `html`):
```css
--text-primary:#212121; --text-secondary:#424242; --text-secondary-alt:#595959;
--text-tertiary:#595959; --text-warning:#f59e0b; --ring-primary:#595959;
--header-primary:#fff; --header-hover:#f7f7f8; --header-button-hover:#f7f7f8;
--surface-active:#ececec; --surface-active-alt:#e3e3e3; --surface-hover:#e3e3e3;
--surface-hover-alt:#cdcdcd; --surface-primary:#fff; --surface-primary-alt:#f7f7f8;
--surface-primary-contrast:#ececec; --surface-secondary:#f7f7f8; --surface-secondary-alt:#e3e3e3;
--surface-tertiary:#ececec; --surface-tertiary-alt:#fff; --surface-dialog:#fff;
--surface-submit:#047857; --surface-submit-hover:#065f46; --surface-destructive:#b91c1c;
--surface-destructive-hover:#991b1b; --surface-chat:#fff;
--border-light:#e3e3e3; --border-medium:#cdcdcd; --border-medium-alt:#cdcdcd;
--border-heavy:#999696; --border-xheavy:#595959;
```

- Semantic role tokens (dark mode, `.dark`):
```css
--brand-purple:#ab68ff;
--presentation:var(--gray-800);
--text-primary:var(--gray-100); --text-secondary:var(--gray-300);
--text-secondary-alt:var(--gray-400); --text-tertiary:var(--gray-500);
--text-warning:var(--amber-500);
--header-primary:var(--gray-700); --header-hover:var(--gray-600);
--header-button-hover:var(--gray-700);
--surface-active:var(--gray-500); --surface-active-alt:var(--gray-700);
--surface-hover:var(--gray-600); --surface-hover-alt:var(--gray-600);
--surface-primary:var(--gray-900); --surface-primary-alt:var(--gray-850);
--surface-primary-contrast:var(--gray-850);
--surface-secondary:var(--gray-800); --surface-secondary-alt:var(--gray-800);
--surface-tertiary:var(--gray-700); --surface-tertiary-alt:var(--gray-700);
--surface-dialog:var(--gray-850);
--surface-submit:var(--green-700); --surface-submit-hover:var(--green-800);
--surface-destructive:var(--red-800); --surface-destructive-hover:var(--red-900);
--surface-chat:var(--gray-700);
--border-light:var(--gray-700); --border-medium:var(--gray-600);
--border-medium-alt:var(--gray-600); --border-heavy:var(--gray-500);
--border-xheavy:var(--gray-400);
```

- Tailwind color bridge (`client/tailwind.config.cjs` → `theme.extend.colors`):
  - Examples: `text-primary: var(--text-primary)`, `surface-primary: var(--surface-primary)`, `brand-purple: var(--brand-purple)`.
  - Use these names directly in classes: `text-text-primary`, `bg-surface-primary`, `border-border-medium`, etc.

### 4.3 Theming Mechanics
- Dark mode: class-based (`darkMode: ['class']`). Add/remove `.dark` on the root to toggle.
- Runtime/env overrides: `client/src/utils/getThemeFromEnv.js`
  - Reads `REACT_APP_THEME_*` to generate RGB tokens (e.g., `REACT_APP_THEME_TEXT_PRIMARY` → `rgb-text-primary`).
  - If unset, defaults from CSS variables are used.
- PWA manifest (in `vite.config.ts`):
  - `background_color: #000000`, `theme_color: #009688`.

### 4.4 Motion and Radius
- Tailwind animations and keyframes extended (accordion, slide-in/out, etc.).
- Radius tokens bridged from CSS: `--radius` → `borderRadius.lg/md/sm`.

## 5) Usage Guidelines (frontend)
- Prefer Tailwind utilities that map to theme tokens:
  - Text: `text-text-primary`, `text-text-secondary`, `text-text-warning`.
  - Surfaces: `bg-surface-primary`, `bg-surface-secondary`, `bg-surface-dialog`.
  - Borders: `border-border-light|medium|heavy|xheavy`.
  - Brand: `text-brand-purple`, `bg-brand-purple` when appropriate.
- For custom CSS, reference the variables directly, e.g. `color: var(--text-primary)`.
- Toggling dark mode: set/remove `.dark` on `html` or a top-level container.

## 6) Constraints / Notes
- Keep token names stable; Tailwind classes rely on the `tailwind.config.cjs` mapping.
- Ensure fonts under `client/public/fonts` to match declared `@font-face` in `style.css`.
- When theming via env: set only `REACT_APP_THEME_*` keys you need; unset keys fall back to defaults.

## 7) File Map (branding & build)
- `client/src/style.css` — All CSS variables, font faces, prose styles, and many utilities.
- `client/tailwind.config.cjs` — Tailwind theme, dark mode, color token bridge, plugins.
- `client/postcss.config.cjs` — PostCSS plugins (import, preset-env, tailwind, autoprefixer).
- `client/vite.config.ts` — Vite config, PWA manifest (theme/background colors), alias `$fonts`.
- `client/src/utils/getThemeFromEnv.js` — Env-driven theming support.
- `client/public/fonts/` — Font assets (Inter, Roboto Mono, optional Söhne).
- Backend & infra tech declared in `api/package.json` and `package.json` at root.

## 8) Appendix — Color Tokens (Authoritative)

### 8.1 Base Palette (`:root` in `client/src/style.css`)
```css
--white:#fff; --black:#000;
/* Gray */
--gray-20:#ececf1; --gray-50:#f7f7f8; --gray-100:#ececec; --gray-200:#e3e3e3;
--gray-300:#cdcdcd; --gray-400:#999696; --gray-500:#595959; --gray-600:#424242;
--gray-700:#2f2f2f; --gray-800:#212121; --gray-850:#171717; --gray-900:#0d0d0d;
/* Green */
--green-50:#ecfdf5; --green-100:#d1fae5; --green-200:#a7f3d0; --green-300:#6ee7b7;
--green-400:#34d399; --green-500:#10b981; --green-600:#059669; --green-700:#047857;
--green-800:#065f46; --green-900:#064e3b; --green-950:#022c22;
/* Red */
--red-50:#fef2f2; --red-100:#fee2e2; --red-200:#fecaca; --red-300:#fca5a5;
--red-400:#f87171; --red-500:#ef4444; --red-600:#dc2626; --red-700:#b91c1c;
--red-800:#991b1b; --red-900:#7f1d1d; --red-950:#450a0a;
/* Amber */
--amber-50:#fffbeb; --amber-100:#fef3c7; --amber-200:#fde68a; --amber-300:#fcd34d;
--amber-400:#fbbf24; --amber-500:#f59e0b; --amber-600:#d97706; --amber-700:#b45309;
--amber-800:#92400e; --amber-900:#78350f; --amber-950:#451a03;
/* Brand */
--brand-purple:#ab68ff;
```

### 8.2 Semantic Tokens — Light Mode (`html`)
```css
--brand-purple:#ab68ff; --presentation:#fff;
--text-primary:#212121; --text-secondary:#424242; --text-secondary-alt:#595959;
--text-tertiary:#595959; --text-warning:#f59e0b; --ring-primary:#595959;
--header-primary:#fff; --header-hover:#f7f7f8; --header-button-hover:#f7f7f8;
--surface-active:#ececec; --surface-active-alt:#e3e3e3; --surface-hover:#e3e3e3;
--surface-hover-alt:#cdcdcd; --surface-primary:#fff; --surface-primary-alt:#f7f7f8;
--surface-primary-contrast:#ececec; --surface-secondary:#f7f7f8; --surface-secondary-alt:#e3e3e3;
--surface-tertiary:#ececec; --surface-tertiary-alt:#fff; --surface-dialog:#fff;
--surface-submit:#047857; --surface-submit-hover:#065f46; --surface-destructive:#b91c1c;
--surface-destructive-hover:#991b1b; --surface-chat:#fff;
--border-light:#e3e3e3; --border-medium:#cdcdcd; --border-medium-alt:#cdcdcd;
--border-heavy:#999696; --border-xheavy:#595959;
```

### 8.3 Semantic Tokens — Dark Mode (`.dark`)
```css
--brand-purple:#ab68ff; --presentation:var(--gray-800);
--text-primary:var(--gray-100); --text-secondary:var(--gray-300);
--text-secondary-alt:var(--gray-400); --text-tertiary:var(--gray-500);
--text-warning:var(--amber-500);
--header-primary:var(--gray-700); --header-hover:var(--gray-600);
--header-button-hover:var(--gray-700);
--surface-active:var(--gray-500); --surface-active-alt:var(--gray-700);
--surface-hover:var(--gray-600); --surface-hover-alt:var(--gray-600);
--surface-primary:var(--gray-900); --surface-primary-alt:var(--gray-850);
--surface-primary-contrast:var(--gray-850);
--surface-secondary:var(--gray-800); --surface-secondary-alt:var(--gray-800);
--surface-tertiary:var(--gray-700); --surface-tertiary-alt:var(--gray-700);
--surface-dialog:var(--gray-850);
--surface-submit:var(--green-700); --surface-submit-hover:var(--green-800);
--surface-destructive:var(--red-800); --surface-destructive-hover:var(--red-900);
--surface-chat:var(--gray-700);
--border-light:var(--gray-700); --border-medium:var(--gray-600);
--border-medium-alt:var(--gray-600); --border-heavy:var(--gray-500);
--border-xheavy:var(--gray-400);
```

## 9) Open Questions
- Document API I/O contracts and module boundaries (add to this spec).

## 10) Last Updated
2025-08-25 — Cascade
