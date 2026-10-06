---
name: soft-pop-design
description: >-
  Design system for building websites, web apps, dashboards and mobile UI in the
  Soft Pop style (warm off-white paper, one light blue accent, subtle puffy
  relief on small controls and data, connected motion). Use whenever a task asks
  for Soft Pop, this house style, or UI that must match an existing Soft Pop
  product.
---
# Soft Pop design

This file is the complete Soft Pop specification for any agent that builds interfaces: a website, a web app, a dashboard, a mobile screen, a component library or a single component. Follow it exactly; do not improvise a look, mix in another design system, or "improve" values. When the product needs something this file doesn't cover, extend the closest pattern using the same tokens, materials and motion.

## How to work

1. **Read the product first.** Decide what the screen is for and what the person operates on it. Structure follows the product (a player, a dashboard, a form); the materials, colour, type and motion never change.
2. **Install the foundations once:** the fonts (§4.1), the theme (§13), and the relief SVG (§6.4) at the top of `<body>` (or in the root layout of a framework app). Components use roles and scale steps from §13 only; never write a raw hex, size or duration.
3. **Choose a container for every block** (§5.1), top to bottom: a panel for anything the person operates and for every self-contained unit with its own title (a chart, a list, a table, a plan, a widget); a panel each for side-by-side siblings; paper for heroes, intros, prose and short figure rows; at most one band to set apart a major section of a long page. Never leave a screen with several independent units as bare paper, and never nest panels. Relief only on small or thin things (§6.4); controls have no outlines.
4. **Build controls with the shape-layer pattern** (§7.0): a positioned control, a separate shape layer that carries colour and relief (`.btn__body`, `.well`, `.knob`), content above it. Never put a relief filter on an element that contains text.
5. **Make all data puffy** (§6.5, §7.5): beads for units and categories, pills for steps, chapters and shares, round-topped bars with a flat base (`border-radius: 11px 11px 3px 3px`) for charts.
6. **Add motion last** (§9): only motions that explain a change, under 300 ms for UI, interruptible transitions, overlays from their trigger, button morphs in place.
7. **Verify before handing back:** render the result (a headless browser screenshot is enough) in light and dark side by side, at 400 px width, and with reduced motion. Each control must look like the same object in both themes, lit from the top left; nothing may scroll sideways. Then run the checklist in §15 and fix anything that fails.

Hard rules: light theme by default; one light blue primary per screen; destructive buttons filled rose; no outlines on controls; text on the accent is ink; no `·`, `|` or `/` separators between items; no uppercase eyebrow labels; no cards around everything; no glows, gradients, characters, mascots or decorative blobs; shadows warm and faint; relief subtle (a millimetre high). Every element has one job and appears once.

## Adapting to your stack

- **Plain HTML/CSS:** use the snippets as written.
- **React, Vue, Svelte:** render the relief SVG once in the root layout; make each control a component that outputs the same markup (control, shape layer, content). Keep the CSS in a global stylesheet or CSS modules; the tokens stay CSS custom properties so the theme switch works without re-rendering.
- **Tailwind:** keep the tokens as CSS variables and reference them (`bg-[var(--paper)]`, or map them in `theme.extend` from the JSON in §13). Add the three relief classes (`.f-raise`, `.f-raise-s`, `.f-press`) as plain CSS or a small plugin; Tailwind has no utility for SVG filters.
- **Framer Motion / GSAP:** equivalents are listed in §9.2.
- **iOS, Android, Flutter and other native UI:** SVG filters are not available. Use the flat fallback in §6.4 (a 1 px top highlight, a 1 px contact shadow and a 3 px soft shadow for raised shapes; an inner top shadow for pressed shapes) with the same colours, sizes, radii and timings.
- **Theme switching:** light is the default and does not follow the operating system; dark applies only when the person chooses it, by setting `data-theme="dark"` on the root element (remember the choice).

---

> **Eye candy, nice to see, recognizable, clean, and everything serves a purpose.**
> Before adding anything, ask what job it does. If it has none, leave it out. If the same information is already on screen, don't show it twice.

## 1. Style summary

Soft Pop is a warm, quiet interface style for professional products. Pages are warm off-white paper with generous space; headings, intros and prose sit directly on it. White panels hold the things you operate and the self-contained units of a screen (a chart, a list, a form), and they stay flat with a wide, faint, warm shadow; a warmer band can set apart one major section of a long page. The small things you touch (buttons, knobs, thumbs, checks, fills) and every piece of data (beads, pills, chart bars) have a soft, puffy volume, lit from the top left and resting on the page with a short contact shadow, in the same way in light and dark. Tracks, fields and sockets are gently pressed in. One light blue accent marks the primary action, the current selection and the highlighted value. Motion connects states: things move to their new place, overlays grow from what opened them, and buttons morph through loading and success.

**North star:** *A calm, flat page where only the small things you touch and read have soft, puffy volume, and every change visibly connects to the last.*

### How this file is organised

- **§13 is the theme.** Every value is defined there once, as a token. All other sections describe how to use the tokens and never introduce a raw value of their own.
- **Light is the default theme.** Dark is opt-in: it applies only when the person chooses it (`data-theme="dark"` on the root element, set by a theme switch and remembered), never automatically from the operating system.
- Tokens come in two layers. **Primitives** (`--cream-50`, `--blue-400`, `--fs-4`, `--s-5`…) hold the raw values. **Roles** (`--paper`, `--accent`, `--ink-muted`…) say what a value is for and point at a primitive. Components only use roles and scale steps. Dark mode remaps roles to dark primitives and adds no new values.

---

## 2. Signature moves

| # | Move | How to apply |
|---|---|---|
| 1 | Warm paper and space | `--paper`, wide margins, few elements per screen. |
| 2 | Paper, panels, bands | Reading content sits on paper; things you operate and self-contained units sit in panels; a band sets apart one major section of a long page (§5.1). |
| 3 | Soft relief on small things | Raised: keys, knobs, thumbs, pips, fills, beads, pills, chart bars. Pressed: tracks, fields, sockets. Only on things whose shorter side is 56 px or less. |
| 4 | One brand colour | Light blue `--accent` for the primary action, the current selection, on-states and the highlighted value. No secondary brand colour. Text on it is ink. |
| 5 | Clean buttons that morph | `--h-lg`, `--r-lg`, press `scale(0.97)`, hover changes colour only, loading and success in place. |
| 6 | Puffy data | Beads for units and categories, pills for steps, chapters and shares, round-topped bars with a flat base for charts. Never squares, sharp bars or flat dots. |
| 7 | Muted, warm colour | Sage, honey, rose and blue for state; peach, lilac, blush, mist, sand for categories. |
| 8 | Outfit headings, Inter text | DM Mono only for a running clock. |
| 9 | Connected motion | Shared elements, sliding thumbs and indicators, reflow, overlays from their trigger, a circular theme change. |

---

## 3. Colour

### 3.1 Roles

| Role | Light | Dark | Use |
|---|---|---|---|
| `--paper` | `--cream-50` | `--night-950` | Page background |
| `--surface` | `--white` | `--night-900` | Panels, popovers, dialogs, toasts |
| `--well` | `--cream-100` | `--night-850` | Pressed tracks, fields, sockets, tags, table hover, well groups |
| `--band` | `--cream-100` | `--night-925` | Full-width bands that set apart one page section |
| `--raised` | `--white` | `--night-800` | Secondary buttons, selected thumbs |
| `--raised-hover` | `--cream-25` | `--night-750` | Hover on raised things and clickable rows |
| `--knob` | `--white` | `--night-100` | Toggle and slider knobs |
| `--bead` | `--white` | `--night-600` | Stepper steps not reached |
| `--ink` | `--ink-900` | `--night-50` | Text |
| `--ink-muted` | `--grey-600` | `--night-300` | Secondary text, labels, axis labels, placeholders |
| `--ink-faint` | `--grey-400` | `--night-500` | Disabled text only |
| `--on-accent` | `--ink-900` | `--night-950` | Text and icons on accent, danger and state fills |
| `--line` | ink 7 % | white 7 % | Hairlines, panel edges |
| `--edge` | ink 7 % | transparent | Edge of raised buttons (the lit edge replaces it in dark) |
| `--well-rim` | ink 4 % | white 6 % | Inner edge of data wells (tracks, dimples, upcoming pills) |
| `--knob-rim` | ink 16 % | black 35 % | Edge of the slider knob, so it reads over white |
| `--focus` | `--blue-700` | `--blue-350` | Focus ring |
| `--accent` | `--blue-400` | `--blue-400` | Primary fill, on-states, checks, fills, current pill, highlighted value |
| `--accent-hover` | `--blue-300` | `--blue-250` | Primary hover (a touch lighter) |
| `--accent-strong` | `--blue-700` | `--blue-350` | Links in text, latched button labels, accent text |
| `--accent-tint` | `--blue-100` | `--blue-900` | Text selection, selected rows, latched buttons |
| `--danger` / `--danger-hover` | `--rose-400` / `--rose-350` | same | Destructive buttons |
| `--success`, `--warning`, `--error`, `--info` | sage, honey, rose, blue `-400` | same | State fills: beads, icons on tints |
| `--*-text` | sage, honey, rose, blue `-700` | `-400`, rose `-300`, blue `-350` | State text and icons |
| `--*-tint` | sage, honey, rose, blue `-100` (30 % of the fill on white) | `-900` | Alert and banner backgrounds; blue also for text selection and selected rows |
| `--data-ink` | `--grey-500` | `--night-350` | Neutral chart bars, done pills |
| `--data-highlight` | `--accent` | `--accent` | The highlighted value in a chart |
| `--cat-*` / `--cat-*-text` | `-400` / `-700` | `-400` / `-400` | Categories: peach, lilac, blush, mist, sand, in that order |

### 3.2 Rules

- **Blue is the only brand colour.** It means "act here", "selected" or "this one". Info messages use the blue family too, always with the info icon and a label, so they can't be mistaken for a control.
- **Danger is rose.** Every destructive button is filled `--danger` with `--on-accent` text, wherever it appears. It never replaces the primary button of a screen that has another primary action.
- State colours never label categories; categories never signal state; neither is used for actions.
- Colour never stands alone: states carry an icon and words, categories carry their name, the highlighted value carries a label.
- Ratio: about 90 % neutrals, under 8 % colour, the rest accent. No coloured page backgrounds, no gradients between hues, no glows.
- Text selection uses `--accent-tint` behind `--ink`; the text caret is `--accent-strong`.
- Sequential data (heatmaps, intensity) runs `--accent-tint` → `--accent` → `--accent-strong`. Categorical data uses the category order above; more than five series is a sign the chart needs splitting.

### 3.3 Contrast

Measured ratios (WCAG 2.x). Text needs 4.5 (3 for 18 px+ or 14 px bold); graphics and control boundaries need 3.

| Pair | Light | Dark |
|---|---|---|
| `--ink` on paper / surface / well | 14.4 / 15.9 / 13.4 | 15.7 / 14.1 / 12.6 |
| `--ink-muted` on paper / surface / well | 5.9 / 6.5 / 5.5 | 7.7 / 6.9 / 6.2 |
| `--accent-strong` on paper / surface | 5.4 / 5.9 | 9.6 / 8.6 |
| `--on-accent` on accent / accent hover | 7.95 / 8.8 | 9.0 / 10.2 |
| `--on-accent` on danger / danger hover | 5.1 / 5.7 | 5.7 / 6.5 |
| State text on paper (each) | 4.9 | ≥ 7.0 |
| `--ink` on any tint | ≥ 11.5 | ≥ 11.0 |
| State icon on its tint (graphic: success / warning / error / info) | 4.3 / 4.5 / 3.9 / 4.8 | 5.6 / 6.8 / 5.5 / 6.8 |
| `--accent-strong` on accent tint (latched button) | 4.8 | 6.8 |
| Category text on paper (each) | ≥ 4.85 | ≥ 6.9 |
| `--data-ink` against paper | 5.3 | 6.5 |
| `--accent` against surface (graphic) | 2.0 | 8.1 |

- `--ink-faint` (3.3) is for disabled text only, which WCAG exempts.
- Because light `--accent` is a pale fill, nothing may rely on the accent fill alone: on-states also carry a moved knob, a check glyph or a radio centre; the selected option also turns its label ink; the highlighted chart bar carries a bold label.

---

## 4. Typography

### 4.1 Families

| Token | Font | Use |
|---|---|---|
| `--font-head` | **Outfit** 600–700 | Headings, figures, panel titles, wordmark |
| `--font-body` | **Inter** 400–600 | Text and every control |
| `--font-clock` | **DM Mono** 400 | Running clocks only |

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@600;700&family=Inter:wght@400;500;600&family=DM+Mono:wght@400&display=swap" rel="stylesheet">
```

### 4.2 Roles

Every text style in the product is one of these roles. Sizes come from the `--fs-*` scale (12, 13, 14, 15, 18, 22, 26, 32, 40, 56).

| Role | Size | Weight | Line height | Tracking | Family | Use |
|---|---|---|---|---|---|---|
| display | `--fs-10` (phones `--fs-9`) | bold | `--lh-tight` | `--ls-display` | head | One hero line per page |
| h1 | `--fs-9` (phones `--fs-8`) | bold | `--lh-snug` | `--ls-h1` | head | Page title, closing statement |
| h2 | `--fs-7` | semibold | `--lh-heading` | `--ls-h2` | head | Section title |
| title | `--fs-6` | semibold (wordmark bold) | `--lh-heading` | `--ls-h2` | head | Panel, dialog and player titles; wordmark |
| h3 | `--fs-5` | semibold | `--lh-title` | `--ls-h3` | head | Sub-section, list group |
| lead | `--fs-5` | regular | `--lh-body` | 0 | body | Intro paragraph |
| body | `--fs-4` | regular | `--lh-body` | 0 | body | Running text, field values |
| button | `--fs-4` (compact `--fs-3`) | semibold | `--lh-none` | 0 | body | Buttons, segmented options |
| ui | `--fs-3` | medium | `--lh-ui` | 0 | body | Tabs, menu items, legends, table cells, toasts |
| small | `--fs-2` | medium | `--lh-ui` | 0 | body | Labels, helper text, metadata, table headers, tooltips |
| caption | `--fs-1` | medium (highlight semibold) | `--lh-ui` | 0 | body | Chart axis labels, badges |
| figure | `--fs-8` (large `--fs-9`) | semibold | `--lh-tight` | `--ls-figure`, tabular | head | Key numbers, prices |
| clock | `--fs-9` | regular | `--lh-none` | `--ls-figure`, tabular | clock | Elapsed time |

- Display and h1 scale fluidly between their two sizes: `clamp(var(--fs-9), 5.4vw, var(--fs-10))` and `clamp(var(--fs-8), 4.2vw, var(--fs-9))`.
- Sentence case everywhere. No uppercase labels and no eyebrows above headings.
- Separate items with space or a line break, never with `·`, `|` or `/`.
- Headings get `text-wrap: balance`; running text stays within `--measure`.
- Numbers that line up use `font-variant-numeric: tabular-nums`.

### 4.3 Links

- In running text: `--accent-strong`, underlined `--bw-1` with an `--s-1` offset, underline colour at 40 % that becomes solid on hover (150 ms). Visited links look the same.
- In navigation and controls: no underline; the control's own states apply.
- Focus: the standard ring (§6.2).

---

## 5. Spacing, layout and sections

| Token | Value | Use |
|---|---|---|
| `--s-0` … `--s-10` | 2, 4, 8, 12, 16, 24, 32, 48, 64, 96, 128 px | Every margin, padding and gap |
| `--container` | 1120 px | Page content width |
| `--container-text` | 560 px | Section intros, single-column forms |
| `--measure` | 65ch | Running text |
| `--dialog-w` | 400 px | Dialogs |
| `--popover-w` | 240 px | Tooltips, menus (max) |
| `--gutter` | `max(16px, 4vw)` | Page side padding |
| `--grid-gap` | `--s-5`, phones `--s-4` | Between columns and cards |
| `--section` | `--s-9`, phones `--s-8` | Between page sections, and inside bands |
| `--panel-pad` | `--s-6`, phones `--s-5` | Inside panels and dialogs |

- **Grid:** 12 columns inside `--container`, gap `--grid-gap`.
- **Breakpoints:** 600 px (phone → tablet) and 960 px (two columns → one). Below 960 px multi-column layouts stack; below 600 px the phone values above apply and touch sizes take over.
- **Layers:** `--z-nav` (sticky header), `--z-overlay` (scrims, dialogs, sheets, menus), `--z-toast`, `--z-tooltip`.

### 5.1 Sections: paper, panel or band

Every block of content sits in one of three containers. A page made only of paper reads as a wall of text; a page where everything is a panel reads as a pile of cards. Decide **block by block**, top to bottom; the first question that answers yes decides:

1. **Is it something the person operates** (a form, a player, an editor, a filter bar, a settings group)? → **Panel.**
2. **Is it a self-contained unit with its own title**, one that could be moved or reordered as a whole (a chart with its legend, a list or queue, a table, a summary, a dashboard widget, a pricing plan, an activity feed)? → **Panel.**
3. **Does it sit next to similar units** (two charts, three plans, a grid of widgets)? → **A panel each**, same padding, tops aligned, equal heights in a row. Siblings are always treated alike.
4. **Is it reading content**: a hero, a page or section intro, prose, an article, a single statement, a short run of points? → **Paper.**
5. **Is it a short, self-explanatory set** (a row of figures, a quote, a few logos or proof points)? → **Paper**, or a **band** when the page needs a change of rhythm.

| Container | Looks like | Use for |
|---|---|---|
| Paper | Content directly on `--paper`, separated by `--section` space | Heroes, intros, prose, headings, short figure rows, closing statements |
| Panel | `--surface`, 1 px `--line`, `--r-2xl`, `--panel-pad`, `--shadow-sm` | Operable things and self-contained units (questions 1–3) |
| Band | Full-width strip of `--band`, `--section` padding top and bottom, content inside `--container` | One major section of a long page that needs to stand apart: proof, a demo, a group of panels |

**Bands.** Only on pages with four or more sections; never the first section, never two bands in a row, at most one band per three sections. A band can hold paper content or panels; panels on a band stand out more, which suits a group of widgets or plans.

**Inside a panel.**
- Anatomy: a header (the `title` role, optional `small` meta below it, optional ghost action on the right), the body `--s-4` below, and an optional footer (actions right-aligned, a hairline above, `--s-4` padding top, `--s-5` above the hairline).
- Split sub-groups with a hairline and an `h3`, never with a nested panel. A panel never contains another panel.
- A short read-only block inside a panel (a total, a summary line, a code snippet) may sit in a **well group**: `--well`, `--r-lg`, padding `var(--s-3) var(--s-4)`.

**Section header** (on paper or a band): `h2`, an optional `--ink-muted` description within `--container-text`, and an optional ghost action on the right ("View all"). `--s-6` below it.

**Balance check for every screen:**
- A screen with two or more independent units is never paper only.
- A single heading, sentence or figure is never wrapped in a panel on its own.
- Reading content in a panel uses `body` text at `--measure`; a panel full of prose is a sign it should be paper.
- On a screen, roughly: one or two paper sections for orientation, panels for the work, at most one band.

**Typical structures**

| Product | Structure |
|---|---|
| Marketing site | Hero on paper with one working piece of the product in a panel; feature points on paper; one band for proof (figures, quotes) or a demo; plans as sibling panels; closing statement on paper |
| Dashboard | Page title and key figures on paper; every chart, table, list and feed in its own panel, in a grid with `--grid-gap` |
| App screen (settings, editor, detail) | Page title on paper; content grouped by topic, one panel per topic; the primary action in the panel footer |
| Document, article, report | Paper only, at `--measure`; interactive pieces (a calculator, a live chart) in a panel within the flow |

---

## 6. Shape and depth

### 6.1 Radius

One rule: **a shape nested inside another has the outer radius minus the gap between them.** That is why the segmented track (`--r-xl`) holds a thumb with `--r-md` and 4 px padding, and a menu (`--r-xl`) holds items with `--r-md`.

| Token | Value | Use |
|---|---|---|
| `--r-xs` | 3 px | Base corners of chart bars |
| `--r-sm` | 6 px | Checks |
| `--r-md` | 10 px | Compact buttons, thumbs, menu items, tooltips, tags inside rows |
| `--r-lg` | 12 px | Buttons, fields, alerts |
| `--r-xl` | 14 px | Segmented track, toasts, menus |
| `--r-2xl` | 22 px | Panels, dialogs, sheets |
| `--r-pill` | 999 px | Beads, knobs, pills, toggles, tracks, tags, badges, avatars |

### 6.2 Borders and focus

| Token | Value | Use |
|---|---|---|
| `--bw-1` | 1 px | Hairlines, panel edges, button edges |
| `--bw-2` | 2 px | Focus ring, error edge |
| `--focus-offset` | 2 px | Gap between control and focus ring |

- **Focus (every control):** `outline: var(--bw-2) solid var(--focus); outline-offset: var(--focus-offset)`, shown on `:focus-visible` only. Fields use the same ring.
- **No outlines on controls.** Fields, checks, radios, toggles, thumbs and buttons are defined by their fill and relief alone: a pressed well or a raised body. The only lines a control ever shows are the keyboard focus ring and, on a field in error, a 2 px `--error-text` edge.

### 6.3 Elevation

| Level | What | Treatment |
|---|---|---|
| Paper | Reading content, intros, short figure rows | Nothing |
| Band | One major section of a long page | `--band`, full width, no line, no shadow |
| Surface | Panels | `--surface`, 1 px `--line`, `--shadow-sm` |
| Floating | Toasts, menus, tooltips, popovers | `--surface`, 1 px `--line`, `--shadow-md` |
| Modal | Dialogs, sheets | `--surface`, `--shadow-lg`, over `--scrim` with a `--blur-scrim` blur |

Shadows are wide, faint and warm in light mode, black in dark. Never transition between two shadow lists; fade a pseudo-element instead.

### 6.4 Relief

Relief is a material, not an elevation: it marks what you touch and what you read as data.

| Level | What | Treatment |
|---|---|---|
| Raised | Buttons, knobs, thumbs, check and radio fills, slider and progress fills, beads, pills, chart bars, colour swatches | `.f-raise` (shorter side ≥ 32 px) or `.f-raise-s` (< 32 px) |
| Pressed | Tracks, fields, sockets, dimples, upcoming pills, segmented track | `--well` + `.f-press` |

One light for the whole product: top left (azimuth 250°, elevation 62°). Put this SVG once at the top of `<body>`; it holds the light and dark sets:

```html
<svg width="0" height="0" style="position:absolute" aria-hidden="true" focusable="false">
  <defs>
    <filter id="sp-raise" x="-20%" y="-40%" width="140%" height="200%" color-interpolation-filters="sRGB">
      <feGaussianBlur in="SourceAlpha" stdDeviation="3" result="h"/>
      <feDiffuseLighting in="h" surfaceScale="1.8" diffuseConstant="1" lighting-color="#fff" result="d"><feDistantLight azimuth="250" elevation="62"/></feDiffuseLighting>
      <feComposite in="d" in2="SourceAlpha" operator="in" result="dI"/>
      <feComposite in="SourceGraphic" in2="dI" operator="arithmetic" k1="0.14" k2="0.876" k3="0.18" k4="-0.1589" result="obj"/>
      <feGaussianBlur in="SourceAlpha" stdDeviation="0.8" result="a"/><feOffset in="a" dy="1" result="ao"/>
      <feFlood flood-color="#6B5A44" flood-opacity="0.16"/><feComposite in2="ao" operator="in" result="aoC"/>
      <feGaussianBlur in="SourceAlpha" stdDeviation="4" result="b"/><feOffset in="b" dy="3" result="bo"/>
      <feFlood flood-color="#6B5A44" flood-opacity="0.12"/><feComposite in2="bo" operator="in" result="bC"/>
      <feMerge><feMergeNode in="bC"/><feMergeNode in="aoC"/><feMergeNode in="obj"/></feMerge>
    </filter>
    <filter id="sp-raise-s" x="-40%" y="-60%" width="180%" height="240%" color-interpolation-filters="sRGB">
      <feGaussianBlur in="SourceAlpha" stdDeviation="2" result="h"/>
      <feDiffuseLighting in="h" surfaceScale="1.58" diffuseConstant="1" lighting-color="#fff" result="d"><feDistantLight azimuth="250" elevation="62"/></feDiffuseLighting>
      <feComposite in="d" in2="SourceAlpha" operator="in" result="dI"/>
      <feComposite in="SourceGraphic" in2="dI" operator="arithmetic" k1="0.14" k2="0.876" k3="0.18" k4="-0.1589" result="obj"/>
      <feGaussianBlur in="SourceAlpha" stdDeviation="0.6" result="a"/><feOffset in="a" dy="1" result="ao"/>
      <feFlood flood-color="#6B5A44" flood-opacity="0.18"/><feComposite in2="ao" operator="in" result="aoC"/>
      <feGaussianBlur in="SourceAlpha" stdDeviation="2.5" result="b"/><feOffset in="b" dy="2" result="bo"/>
      <feFlood flood-color="#6B5A44" flood-opacity="0.133"/><feComposite in2="bo" operator="in" result="bC"/>
      <feMerge><feMergeNode in="bC"/><feMergeNode in="aoC"/><feMergeNode in="obj"/></feMerge>
    </filter>
    <filter id="sp-press" x="-5%" y="-20%" width="110%" height="140%" color-interpolation-filters="sRGB">
      <feGaussianBlur in="SourceAlpha" stdDeviation="3.2" result="h"/>
      <feComponentTransfer in="h" result="hi"><feFuncA type="linear" slope="-1" intercept="1"/></feComponentTransfer>
      <feDiffuseLighting in="hi" surfaceScale="2" diffuseConstant="1" lighting-color="#fff" result="d"><feDistantLight azimuth="250" elevation="62"/></feDiffuseLighting>
      <feComposite in="d" in2="SourceAlpha" operator="in" result="dI"/>
      <feComposite in="SourceGraphic" in2="dI" operator="arithmetic" k1="0.14" k2="0.876" k3="0.22" k4="-0.1942" result="obj"/>
      <feComponentTransfer in="SourceAlpha" result="inv"><feFuncA type="table" tableValues="1 0"/></feComponentTransfer>
      <feGaussianBlur in="inv" stdDeviation="1.5" result="ib"/><feOffset in="ib" dy="1" result="io"/>
      <feFlood flood-color="#6B5A44" flood-opacity="0.08"/><feComposite in2="io" operator="in" result="ic"/>
      <feComposite in="ic" in2="SourceAlpha" operator="in" result="inner"/>
      <feMerge><feMergeNode in="obj"/><feMergeNode in="inner"/></feMerge>
    </filter>
    <!-- dark-theme set -->
    <filter id="sp-raise-d" x="-20%" y="-40%" width="140%" height="200%" color-interpolation-filters="sRGB">
      <feGaussianBlur in="SourceAlpha" stdDeviation="3" result="h"/>
      <feDiffuseLighting in="h" surfaceScale="1.8" diffuseConstant="1" lighting-color="#fff" result="d"><feDistantLight azimuth="250" elevation="62"/></feDiffuseLighting>
      <feComposite in="d" in2="SourceAlpha" operator="in" result="dI"/>
      <feComposite in="SourceGraphic" in2="dI" operator="arithmetic" k1="0" k2="1" k3="0.3" k4="-0.2649" result="lit"/>
      <feComposite in="lit" in2="SourceAlpha" operator="in" result="obj"/>
      <feGaussianBlur in="SourceAlpha" stdDeviation="0.8" result="a"/><feOffset in="a" dy="1" result="ao"/>
      <feFlood flood-color="#000" flood-opacity="0.32"/><feComposite in2="ao" operator="in" result="aoC"/>
      <feGaussianBlur in="SourceAlpha" stdDeviation="4" result="b"/><feOffset in="b" dy="3" result="bo"/>
      <feFlood flood-color="#000" flood-opacity="0.4"/><feComposite in2="bo" operator="in" result="bC"/>
      <feMerge><feMergeNode in="bC"/><feMergeNode in="aoC"/><feMergeNode in="obj"/></feMerge>
    </filter>
    <filter id="sp-raise-s-d" x="-40%" y="-60%" width="180%" height="240%" color-interpolation-filters="sRGB">
      <feGaussianBlur in="SourceAlpha" stdDeviation="2" result="h"/>
      <feDiffuseLighting in="h" surfaceScale="1.58" diffuseConstant="1" lighting-color="#fff" result="d"><feDistantLight azimuth="250" elevation="62"/></feDiffuseLighting>
      <feComposite in="d" in2="SourceAlpha" operator="in" result="dI"/>
      <feComposite in="SourceGraphic" in2="dI" operator="arithmetic" k1="0" k2="1" k3="0.3" k4="-0.2649" result="lit"/>
      <feComposite in="lit" in2="SourceAlpha" operator="in" result="obj"/>
      <feGaussianBlur in="SourceAlpha" stdDeviation="0.6" result="a"/><feOffset in="a" dy="1" result="ao"/>
      <feFlood flood-color="#000" flood-opacity="0.32"/><feComposite in2="ao" operator="in" result="aoC"/>
      <feGaussianBlur in="SourceAlpha" stdDeviation="2.5" result="b"/><feOffset in="b" dy="2" result="bo"/>
      <feFlood flood-color="#000" flood-opacity="0.4"/><feComposite in2="bo" operator="in" result="bC"/>
      <feMerge><feMergeNode in="bC"/><feMergeNode in="aoC"/><feMergeNode in="obj"/></feMerge>
    </filter>
    <filter id="sp-press-d" x="-5%" y="-20%" width="110%" height="140%" color-interpolation-filters="sRGB">
      <feGaussianBlur in="SourceAlpha" stdDeviation="3.2" result="h"/>
      <feComponentTransfer in="h" result="hi"><feFuncA type="linear" slope="-1" intercept="1"/></feComponentTransfer>
      <feDiffuseLighting in="hi" surfaceScale="2" diffuseConstant="1" lighting-color="#fff" result="d"><feDistantLight azimuth="250" elevation="62"/></feDiffuseLighting>
      <feComposite in="d" in2="SourceAlpha" operator="in" result="dI"/>
      <feComposite in="SourceGraphic" in2="dI" operator="arithmetic" k1="0" k2="1" k3="0.367" k4="-0.324" result="lit"/>
      <feComposite in="lit" in2="SourceAlpha" operator="in" result="obj"/>
      <feComponentTransfer in="SourceAlpha" result="inv"><feFuncA type="table" tableValues="1 0"/></feComponentTransfer>
      <feGaussianBlur in="inv" stdDeviation="1.5" result="ib"/><feOffset in="ib" dy="1" result="io"/>
      <feFlood flood-color="#000" flood-opacity="0.2"/><feComposite in2="io" operator="in" result="ic"/>
      <feComposite in="ic" in2="SourceAlpha" operator="in" result="inner"/>
      <feMerge><feMergeNode in="obj"/><feMergeNode in="inner"/></feMerge>
    </filter>
  </defs>
</svg>
```

```css
.f-raise   { filter: var(--fx-raise); }
.f-raise-s { filter: var(--fx-raise-s); }
.f-press   { filter: var(--fx-press); }
.well      { background: var(--well); box-shadow: inset 0 0 0 var(--bw-1) var(--well-rim); }
```

- Both sets light every colour the same way, whatever its value: a little light is multiplied in and a little is added at the top-left edges (light: `k1 0.14, k2 0.876`, plus `k3 0.18` on raised shapes and `0.22` on pressed ones; dark: `k1 0, k2 1, k3 0.3` raised and `0.367` pressed). `k4 = -k3 × sin(62°)` and `k1 × sin(62°) + k2 ≈ 1`, so flat areas keep their exact colour and only the edges change; purely multiplied light would shade pale fills but leave blue, rose or ink almost flat.
- **Raised** shapes: height `surfaceScale` 1.8 (1.58 for the small set), a contact shade (light `#6B5A44` at 0.16–0.18, dark black 0.32) and a soft shadow underneath (light 0.12–0.133, dark 0.4).
- **Pressed** shapes: depth `surfaceScale` 2 with a soft 3.2 px edge, plus a faint inner shadow along the top edge (1.5 px blur, 1 px drop; light `#6B5A44` at 0.08, dark black 0.2), so fields and tracks read as gently carved into the surface.
- Same geometry, same light, same apparent height on every colour and in both themes.
- **Never filter an element that contains text.** Give the control a separate shape layer (`.btn__body`, `.well`, `.knob`) and filter only that.
- Relief only on things whose shorter side is 56 px or less. Don't push depth, shadows or the inner shadow beyond these values; stronger relief stops looking professional.
- Raised things never move up on hover.
- **Flat fallback** (native platforms, renderers without SVG filters): raised = 1 px top highlight `rgb(255 255 255 / 0.6)`, 1 px contact shadow `rgb(70 57 42 / 0.07)`, 4 px soft shadow `rgb(70 57 42 / 0.08)` offset 2 px; pressed = inner 2 px shadow `rgb(70 57 42 / 0.1)` offset 1 px.
- **Forced colours** (Windows high contrast): filters are dropped and every shape layer gets a 1 px `CanvasText` border; focus uses `Highlight`.

### 6.5 Marks

Every mark and every piece of data is puffy. Chart bars keep a flat base so they stand on their baseline.

| Mark | Size | Job | Build |
|---|---|---|---|
| Bead | `--size-bead` | One unit: a day, a done item | Not done: 12 px pressed dimple. Done: `--success` bead, raised, popping in (`scale(0.85)` → 1, 200 ms) |
| Category bead | `--size-cat` | Which category | `--cat-*` fill, raised; always next to the name |
| Pills | `--pill` tall, `--s-2` apart | Steps, chapters | Upcoming: `--pill-rest`, pressed. Done: `--data-ink`, raised. Current: `--accent`, raised. Puffs from rest to full height when reached (`--d-base`) |
| Progress bar | `--bar` | Amount | Pressed track, `--accent` fill raised; always with its value in text |
| Chart bar | `--chart-bar` wide | A value | Radius `calc(var(--chart-bar) / 2) calc(var(--chart-bar) / 2) var(--r-xs) var(--r-xs)`, raised |
| Share pills | `--pill` tall, `--s-2` apart | Parts of a whole | One pill per category, raised as a row |
| Status bead | `--size-cat` | Live state (saving, offline) | State fill, raised, breathing while the state lasts |

Marks never sit next to headings. A brand mark, when one is needed, is a single `--size-bead` accent bead.

---

## 7. Components

### 7.0 Shared rules

- **Construction:** a positioned control, a shape layer that carries colour and relief, content above it.
- **Heights:** `--h-xs` 24 (toggle), `--h-sm` 32 (segmented option, tag, menu item compact), `--h-md` 36 (compact button, menu item, table row compact), `--h-lg` 40 (button, field, select), `--h-xl` 48 (touch button, toast, table row), `--h-2xl` 52 (play button).
- **Hover** (fine pointers only, `--d-quick`): fills change colour, wells darken by 3 % ink (`color-mix(in srgb, var(--well), var(--ink) 3%)`), labels go from `--ink-muted` to `--ink`. Nothing moves.
- **Press:** `scale(0.97)` for controls up to `--h-2xl`, `scale(0.99)` for clickable rows and cards, `--d-press` `--ease-out`.
- **Focus:** the standard ring (§6.2).
- **Disabled (every control):** `--disabled-opacity`, no hover, no press, `cursor: not-allowed`, `aria-disabled` or `disabled`.
- **Touch:** below 600 px, buttons and fields use `--h-xl`; small controls keep a `--hit` hit area through an invisible `::after`.

### 7.1 Buttons

| Variant | Body | Label | Hover body |
|---|---|---|---|
| Primary | `--accent`, raised | `--on-accent` | `--accent-hover` |
| Secondary | `--raised`, 1 px `--edge`, raised | `--ink` | `--raised-hover` |
| Secondary inside a panel | `--well`, raised | `--ink` | well + 5 % ink |
| Ghost | none | `--ink` | `--well` |
| Latched (`aria-pressed="true"`) | `--accent-tint`, raised | `--accent-strong` | — |
| Danger | `--danger`, raised | `--on-accent` | `--danger-hover` |

- Sizes: `--h-lg` with `0 var(--s-4)` padding and `--r-lg`; compact `--h-md`, `0 var(--s-3)`, `--r-md`, `--fs-3`; touch `--h-xl`; icon buttons square; round play `--h-2xl`.
- One primary per screen. A dialog that confirms a destructive action uses Danger as its main button and Ghost "Cancel".
- **Loading:** width kept; label blurs (2 px), fades and rises 6 px; spinner (`--icon-xs`, one turn per `--d-spin`) and status text rise in; `aria-busy="true"`.
- **Success:** the spinner becomes a check (scale 0.9 → 1), the status reads the result ("Saved"); the label returns after 1.5 s.

```html
<button class="btn btn--primary" type="button">
  <span class="btn__body f-raise" aria-hidden="true"></span>
  <span class="btn__stack">
    <span class="btn__label">Save changes</span>
    <span class="btn__status"><span class="spinner" aria-hidden="true"></span><svg class="btn__check" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12.5l4.5 4.5L19 7.5"/></svg><span class="st">Saving</span></span>
  </span>
</button>
```

```css
.btn { position: relative; isolation: isolate; display: inline-flex; align-items: center; justify-content: center; gap: var(--s-2);
  height: var(--h-lg); padding: 0 var(--s-4); border: 0; border-radius: var(--r-lg); background: none; color: var(--ink);
  font: var(--fw-semibold) var(--fs-4)/var(--lh-none) var(--font-body); white-space: nowrap; cursor: pointer;
  transition: transform var(--d-press) var(--ease-out); }
.btn__body { position: absolute; inset: 0; z-index: -1; border-radius: inherit; background: var(--raised); border: var(--bw-1) solid var(--edge); transition: background-color var(--d-quick) ease; }
.btn--primary { color: var(--on-accent); }
.btn--primary .btn__body { background: var(--accent); border-color: transparent; }
.btn--danger { color: var(--on-accent); }
.btn--danger .btn__body { background: var(--danger); border-color: transparent; }
.btn--ghost { color: var(--ink); padding: 0 var(--s-3); }
.btn--ghost .btn__body { background: transparent; border-color: transparent; filter: none; }
@media (hover: hover) and (pointer: fine) {
  .btn:hover .btn__body { background: var(--raised-hover); }
  .btn--primary:hover .btn__body { background: var(--accent-hover); }
  .btn--danger:hover .btn__body { background: var(--danger-hover); }
  .btn--ghost:hover .btn__body { background: var(--well); }
}
.btn:active { transform: scale(0.97); }
.btn:focus-visible { outline: var(--bw-2) solid var(--focus); outline-offset: var(--focus-offset); }
.btn:disabled { opacity: var(--disabled-opacity); pointer-events: none; }
```

### 7.2 Text inputs

| Component | Spec |
|---|---|
| Field | `--h-lg`, pressed well, `--r-lg`, padding `0 var(--s-3)`, `body` text, placeholder `--ink-muted`; no outline; label `small` above (`--s-2` gap); helper or error text `small` below, in a slot one `small` line tall that stays even when empty |
| Textarea | Field look, min-height `--s-9`, padding `var(--s-3)`, vertical resize only |
| Search | Field with a `--icon-sm` search icon at `--s-3` from the left, text starting at `--h-md` from the left, a clear button (ghost icon, compact) once there is text |
| Select | Field look with a `--icon-sm` chevron at the right; opens a menu (§7.7) aligned to the field, same width |

States: hover darkens the well by 3 % ink; focus adds the standard ring; error adds a 2 px `--error-text` edge, shows the message in `--error-text`, and shakes once (300 ms, 5/4/2 px); disabled per §7.0; read-only drops the well.

### 7.3 Choice controls

| Component | Spec |
|---|---|
| Check | `--size-check`, `--r-sm`, pressed socket. Checked: `--accent` pip raised with an `--on-accent` check glyph (`--icon-xs`); pip appears with opacity and `scale(0.85)` → 1 in 200 ms. Indeterminate: same pip with a dash. A done item's label turns `--ink-muted` |
| Radio | `--size-check` circle, same pressed socket. Selected: `--accent` bead raised with an `--s-2` `--on-accent` centre |
| Toggle | `--h-lg` × `--h-xs` pressed track, `--size-knob-s` knob raised. On: track `--accent`, knob slides 16 px (`--d-base` `--ease-in-out`). Its label sits on the same row (rows at least `--h-2xl` tall, hairline between) |
| Segmented | Pressed track `--r-xl`, padding `--s-1`, options `--h-sm` in `button` compact style, muted; the selected thumb is `--raised`, raised, `--r-md`, sliding (`transform` + `width`, `--d-move` `--ease-in-out`); the selected label turns ink |
| Slider | `--h-sm` hit area, `--track` pressed track, `--accent` fill raised, `--size-knob` knob raised with a 1 px `--knob-rim` so it reads over white; hover scales the knob to 1.08, drag to 1.12 (`--d-press`); arrows ±5 %, Home and End to the ends |

### 7.4 Feedback

| Component | Spec |
|---|---|
| Alert (inline banner) | `--*-tint` background, `--r-lg`, padding `var(--s-3) var(--s-4)`, `--icon-md` state icon in `--*-text`, an optional title (`ui`, semibold) and body (`ui`, regular), both `--ink`, an optional ghost action. Kinds: info, success, warning, error. Sits on paper or in a panel; never full-bleed colour |
| Toast | Floating surface, `--h-xl`, `--r-xl`, padding `0 var(--s-1) 0 var(--s-4)`, `ui` text, optional ghost compact action (Undo); rises 8 px and fades in (`--d-base`), leaves in `--d-quick`; at most two; 3 s |
| Tooltip | Floating surface, `--r-md`, padding `var(--s-2) var(--s-3)`, `small` text, max `--popover-w`; appears after `--d-hint`, fades and rises 2 px in `--d-quick`; no arrow |
| Progress | Bar mark (§6.5) with its value in `small` text |
| Stepper | `--track` pressed line, `--accent` progress line raised, `--size-knob-s` beads raised (`--bead`, `--accent` when reached); line slides over `--d-slow`, the bead colours 150 ms later; labels `small` underneath, the current one `--ink` medium |
| Status | Status bead + `small` text in `--*-text`, only while the state lasts ("Saving", "Offline") |
| Loading | Buttons morph; content areas keep their size and show the pressed wells they will fill; no shimmer |
| Empty state | One sentence in `--ink-muted` where the content would be, optional ghost action |

### 7.5 Containers and data

| Component | Spec |
|---|---|
| Panel | Surface level, `--r-2xl`, padding `--panel-pad`; for operable things and self-contained units (§5.1); header, body, optional footer; never nested |
| Clickable row or card | Surface or paper row; hover `--raised-hover`; press `scale(0.99)`; focus ring; a trailing chevron or action makes the target obvious |
| List | Rows on paper or in a panel, hairlines between, min height `--h-xl`. Removing a row: fade and shift 8 px (`--d-quick`), then the height closes (`--d-base`) |
| Table | In a panel when it has its own title (§5.1), on paper inside a document. Header row `small`, `--ink-muted`, sentence case, hairline below. Rows `--h-xl` (compact `--h-md`), `ui` text, hairlines between. Numbers right-aligned, tabular. Hover `--well`; selected `--accent-tint` with the row title semibold; sort indicator `--icon-sm` chevron in `--accent-strong` |
| Tag | `--h-xs` pill, `--well` with `--well-rim`, `caption` medium `--ink`, optional category bead first; removable tags add a compact ghost × |
| Badge (count) | `--size-knob-s` pill, `--accent` fill, `caption` semibold `--on-accent`, min width `--size-knob-s` |
| Avatar | `--size-avatar` circle, image or initials (`caption` semibold on `--well`), 1 px `--line` |
| Charts | §6.5 marks, in a panel with the chart's title and legend (§5.1), on paper inside a document; labels `caption` `--ink-muted`, the highlighted label `--ink` semibold; gridlines only when values must be read precisely (1 px `--line`); bars grow once from a half-bead (height `--chart-bar` / 2) over `--d-slow` with `--stagger` |

### 7.6 Navigation

| Component | Spec |
|---|---|
| Top bar | Sticky, transparent at the top, `--nav-glass` with a `--blur-nav` backdrop blur and a hairline once scrolled; wordmark (`title`, bold) with the brand bead |
| Tabs | `ui` text, muted, ink when current; an `--indicator-w` × `--indicator-h` ink indicator slides to the current tab (`--d-move` `--ease-in-out`) |
| Sidebar | `--h-md` rows, `ui` text muted, `--icon-md` icons; the current row has a `--raised` thumb, raised, `--r-md`, that slides between rows like the segmented thumb; label ink semibold |
| Phone menu | Below 600 px, more than three destinations collapse into a menu button that opens a sheet from the bottom (`--r-2xl` top corners, `--ease-drawer` `--d-base`) with sidebar rows |
| Breadcrumb | `small`, muted, separated by a `--icon-sm` chevron (not a slash); the current page in ink |
| Pagination | Compact ghost buttons for previous and next, the page position in `small` text ("Page 2 of 8") |

### 7.7 Overlays

| Component | Spec |
|---|---|
| Dialog | Modal level, `--dialog-w`, padding `--panel-pad`, `title` heading, body, actions right-aligned; grows from the button that opened it (`scale(0.96)` → 1, `--d-base` `--ease-drawer`), shrinks back (`--d-quick`); Escape and scrim click close; focus starts on the main button, or on Cancel when the main button is Danger |
| Sheet | Phone dialog: from the bottom, full width, `--r-2xl` top corners, `--ease-drawer` |
| Menu | Floating surface, as wide as its trigger field, `--r-xl`, padding `--s-1`, items `--h-md` with `--r-md`, `ui` text, `--icon-sm` icon; hover `--well`; the selected item shows a check; grows from the trigger (`scale(0.96)`, `--d-quick`); arrow keys move, Escape, an outside click or scrolling close it; destructive items in `--error-text` with a hairline above |

---

## 8. Iconography and illustration

- **Icons:** 24 px grid, `--icon-stroke` stroke, round caps and joins, no fill except play and pause. Lucide fits exactly. Sizes: `--icon-xs` inside checks and spinners, `--icon-sm` in fields, menus and tables, `--icon-md` in buttons, alerts and navigation, `--icon-lg` in the play button. Icons use `currentColor` and never get relief; their button does.
- **State icons:** info (i in a circle), success (check in a circle), warning (triangle with a bar), error (circle with a cross).
- **Illustration:** none in product screens. When a visual is needed (a marketing hero, onboarding), show the product's own components at rest, or a few soft primitives (pills, beads, soft rounded blocks) in the palette, lit from the top left on a flat warm plane. No characters, mascots or decorative blobs.
- **Image prompt template:** "A few simple soft-edged geometric objects (pills, small beads, soft rounded blocks) in matte light blue `#84BDF0` and off-white, resting on a flat warm off-white plane `#F6F4EE`. Soft diffuse light from the top left, short soft contact shadows in warm brown, clean studio render, lots of empty space, calm and precise, no text, no characters, no gradients in the background."

---

## 9. Motion

### 9.1 Principles

1. **Every motion explains a change.**
2. **Continuity:** what persists moves to its new place.
3. **Origin:** overlays grow from their trigger and return to it.
4. **Instant feedback:** presses respond on the same frame.
5. **Interruptible:** state changes use transitions, not one-shot keyframes.
6. **Frequency decides:** typing and keyboard navigation don't animate; occasional actions get standard motion; rare moments may get more.
7. **Fast:** UI under 300 ms; screen changes and morphs up to `--d-slow`; the theme reveal `--d-reveal`.
8. **Never from nothing:** start from `scale(0.9–0.97)` with opacity 0; never `ease-in` for UI.

### 9.2 Tokens

| Token | Value | Use |
|---|---|---|
| `--d-press` | 160 ms | Press, knob scale |
| `--d-quick` | 150 ms | Hover, colour, exits, tooltips, menus |
| `--d-base` | 250 ms | Toggles, toasts, dialogs, morphs, pill puff |
| `--d-move` | 300 ms | Sliding thumbs and indicators |
| `--d-slow` | 450 ms | Shared elements, steps, chart growth |
| `--d-reveal` | 600 ms | Theme reveal, progress fill, counting figures |
| `--d-spin` | 700 ms | One spinner turn (linear) |
| `--d-hint` | 400 ms | Tooltip delay |
| `--d-breathe` | 1.6 s | Breathing live states |
| `--stagger` | 30 ms | Cascades, max 8 steps |
| `--ease-out` | `cubic-bezier(0.23, 1, 0.32, 1)` | Entries, exits, presses |
| `--ease-in-out` | `cubic-bezier(0.77, 0, 0.175, 1)` | Movement on screen |
| `--ease-drawer` | `cubic-bezier(0.32, 0.72, 0, 1)` | Dialogs, sheets |
| `--ease-settle` | spring, damping ratio 0.78 | Shared elements |

Framer Motion: `{ type: "spring", stiffness: 169, damping: 20.3 }` for shared layout; `{ duration: 0.25, ease: [0.23, 1, 0.32, 1] }` for entries. GSAP: `"power4.out"` for entries, `"expo.inOut"` for movement.

### 9.3 Patterns

| Pattern | Spec |
|---|---|
| Enter | `translateY(8px)` → 0 with opacity, `--d-base` `--ease-out`, `--stagger` cascade |
| Exit | opacity → 0 and `translateY(-4px)`, `--d-quick` |
| Press | `scale(0.97)` (rows 0.99), `--d-press` |
| Grow from origin | `scale(0.96)` → 1 from the trigger, `--d-base` `--ease-drawer` |
| Slide selection | `transform` + `width`, `--d-move` `--ease-in-out` |
| Button morph | label out (blur 2 px, −6 px, fade), status in (+6 px → 0), `--d-base` |
| Icon swap | old icon to `scale(0.8)` + blur 2 px + fade, new icon in, `--d-quick`–`--d-base` |
| Reflow | leaving row fades `--d-quick`, height closes `--d-base` |
| Count | figures tick to their value over `--d-reveal` |
| Shared element | View Transitions, `--d-slow` `--ease-settle` |
| Screen change | old fades `--d-quick`; new enters `--d-base` after 50 ms |
| Theme change | circular reveal from the theme button, `--d-reveal` `--ease-in-out` |
| Live state | a status bead or current pill breathes (opacity 1 → 0.6, `--d-breathe`) only while the state lasts |

```css
@keyframes settle-in { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: none; } }
@keyframes leave     { to { opacity: 0; transform: translateY(-4px); } }
@keyframes grow-in   { from { opacity: 0; transform: scale(0.96); } to { opacity: 1; transform: none; } }
@keyframes reveal    { from { clip-path: circle(0 at var(--vx) var(--vy)); } to { clip-path: circle(150vmax at var(--vx) var(--vy)); } }
::view-transition-old(root) { animation: leave var(--d-quick) var(--ease-out) both; }
::view-transition-new(root) { animation: settle-in var(--d-base) var(--ease-out) 50ms both; }
::view-transition-group(*)  { animation-duration: var(--d-slow); animation-timing-function: var(--ease-settle); }
html.is-theming::view-transition-old(root) { animation: none; }
html.is-theming::view-transition-new(root) { animation: reveal var(--d-reveal) var(--ease-in-out) both; }
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after { animation-duration: 1ms !important; animation-iteration-count: 1 !important; transition-duration: 1ms !important; }
  ::view-transition-group(*), ::view-transition-old(*), ::view-transition-new(*) { animation: none !important; }
}
```

Reduced motion keeps every state change and opacity; it removes movement, scaling and the reveal. The relief is static and stays.

---

## 10. Voice

- Headings name the thing, in sentence case: "Up next", "Your plan".
- Plain labels under figures: "minutes listened", "daily average".
- Buttons are verb + object; after success they state the result: "Save changes" → "Saved". Destructive buttons name what goes: "Delete project", not "OK".
- Errors say what happened and how to fix it: "Enter a full email address, like you@example.com."
- Info messages say what is true and what, if anything, to do: "Downloads pause on mobile data. Change this in settings."
- Empty states are one calm sentence: "Nothing queued."
- No exclamation marks, no separators between words.

---

## 11. Platforms and stacks

- **Marketing site, dashboard, app screen, document:** follow the structures in §5.1; one primary button per section.
- **Web app and dashboard:** sidebar navigation; compact controls in toolbars.
- **Mobile:** `--h-xl` controls, full-width panels, sheets instead of dialogs, the phone menu for navigation.
- **React, Vue, Svelte:** render the relief SVG once in the root layout; each control is a component that outputs the shape-layer markup; tokens stay CSS custom properties so the theme switch needs no re-render.
- **Tailwind:** map colours, radii, spacing and timing to the tokens (`theme.extend` from the JSON in §13); add `.f-raise`, `.f-raise-s` and `.f-press` as plain CSS.
- **iOS, Android, Flutter:** use the flat fallback (§6.4) with the same tokens.

---

## 12. Accessibility

- Every text pair passes AA in both themes (§3.3). Text on accent, danger and state fills is always `--on-accent`.
- Controls carry no outlines by design. They are identified by their visible label, their position and their relief, and every state change is shown by something other than colour: a knob that moves, a glyph, a label that turns ink. This is a deliberate trade-off: the soft wells sit below the 3:1 boundary contrast that WCAG 1.4.11 recommends for control edges, so every control must always have a visible text label next to it.
- Focus: `--bw-2` `--focus` ring with `--focus-offset` on every control, `:focus-visible` only, never removed.
- Targets: `--h-lg` minimum (`--h-xl` on phones); smaller controls get a `--hit` hit area.
- Semantics: toggles `role="switch"` + `aria-checked`; checks and radios native or with `role` and `aria-checked`; segmented and tabs `aria-pressed` or `role="tab"`; slider `role="slider"` with value attributes and keys; dialogs `aria-modal` with focus returned to the trigger; loading buttons `aria-busy`; results, toasts and errors announced through `aria-live="polite"`.
- Colour is never the only signal (§3.2). Category colours differ in lightness as well as hue.
- Hover effects only on fine pointers. Reduced motion respected (§9). Forced colours supported (§6.4).

---

## 13. Theme

The complete theme: every value, defined once. Copy it unchanged.

```css
/* ============ Soft Pop tokens v8 ============
   Layer 1, primitives: every raw value, defined once.
   Layer 2, roles: what components use; they only point at primitives.
   Light is the default. Dark mode is opt-in and remaps roles to dark primitives; it never introduces a new value. */
:root {
  color-scheme: light;

  /* ---- primitives: colour ---- */
  --white: #FFFFFF;
  --cream-25: #FAF9F6;  --cream-50: #F6F4EE;  --cream-100: #EFECE4;
  --grey-400: #85878B;  --grey-500: #62656D;  --grey-600: #5A5E6B;  --ink-900: #1D2230;
  --night-50: #F2F0EA;  --night-100: #E8E6E0; --night-300: #A6AAB6; --night-350: #9A9BA0;
  --night-500: #6E7383; --night-600: #4A5062; --night-750: #333949; --night-800: #2C3140;
  --night-850: #252A37; --night-900: #1D212C; --night-925: #181B24; --night-950: #14171F;
  --blue-100: #DAEBFA;   --blue-250: #97C9F3;  --blue-300: #93C6F2;  --blue-350: #8EC3F2;
  --blue-400: #84BDF0;  --blue-700: #2A66A8;  --blue-900: #22344B;
  --sage-100: #DBE8DE;   --sage-400: #86B391;  --sage-700: #497453;  --sage-900: #273232;
  --honey-100: #F7EAD0;  --honey-400: #E3B961; --honey-700: #896418; --honey-900: #37332A;
  --rose-100: #F3D5D8;   --rose-300: #E08A91;  --rose-350: #DC8289;  --rose-400: #D8747C; --rose-700: #C23641; --rose-900: #35272F;
  --peach-400: #E3997A; --peach-700: #AF4D25;
  --lilac-400: #A797D6; --lilac-700: #7259BD;
  --blush-400: #E29CB8; --blush-700: #BD376D;
  --mist-400: #74B4AE;  --mist-700: #3F746F;
  --sand-400: #CFA77C;  --sand-700: #8D6234;

  /* ---- roles: surfaces ---- */
  --paper: var(--cream-50);        /* page */
  --surface: var(--white);         /* panels, popovers, dialogs */
  --well: var(--cream-100);        /* pressed tracks, fields, sockets, well groups */
  --band: var(--cream-100);        /* full-width bands that set apart one page section */
  --raised: var(--white);          /* secondary buttons, thumbs */
  --raised-hover: var(--cream-25);
  --knob: var(--white);            /* toggle and slider knobs */
  --bead: var(--white);            /* stepper steps not reached */
  --scrim: rgb(246 244 238 / 0.62);
  --nav-glass: rgb(246 244 238 / 0.88);

  /* ---- roles: text ---- */
  --ink: var(--ink-900);           /* text */
  --ink-muted: var(--grey-600);    /* secondary text, labels, axis */
  --ink-faint: var(--grey-400);    /* disabled text and placeholders of disabled fields only */
  --on-accent: var(--ink-900);     /* text and icons on accent, danger and state fills */

  /* ---- roles: lines ---- */
  --line: rgb(29 34 48 / 0.07);    /* hairlines, panel edges */
  --edge: rgb(29 34 48 / 0.07);    /* edge of raised buttons */
  --well-rim: rgb(29 34 48 / 0.04);/* inner edge of data wells (tracks, dimples, upcoming pills) */
  --knob-rim: rgb(29 34 48 / 0.16);/* edge of the slider knob, so it reads on white */
  --focus: var(--blue-700);        /* focus ring */

  /* ---- roles: action ---- */
  --accent: var(--blue-400);
  --accent-hover: var(--blue-300);
  --accent-strong: var(--blue-700);  /* links in text, latched labels, accent text */
  --accent-tint: var(--blue-100);     /* selection, selected rows, latched buttons */
  --danger: var(--rose-400);
  --danger-hover: var(--rose-350);

  /* ---- roles: state ---- */
  --success: var(--sage-400);  --success-text: var(--sage-700);  --success-tint: var(--sage-100);
  --warning: var(--honey-400); --warning-text: var(--honey-700); --warning-tint: var(--honey-100);
  --error: var(--rose-400);    --error-text: var(--rose-700);    --error-tint: var(--rose-100);
  --info: var(--blue-400);     --info-text: var(--blue-700);     --info-tint: var(--blue-100);

  /* ---- roles: data ---- */
  --data-ink: var(--grey-500);
  --data-highlight: var(--accent);
  --cat-peach: var(--peach-400); --cat-peach-text: var(--peach-700);
  --cat-lilac: var(--lilac-400); --cat-lilac-text: var(--lilac-700);
  --cat-blush: var(--blush-400); --cat-blush-text: var(--blush-700);
  --cat-mist: var(--mist-400);   --cat-mist-text: var(--mist-700);
  --cat-sand: var(--sand-400);   --cat-sand-text: var(--sand-700);

  /* ---- relief and elevation ---- */
  --fx-raise: url(#sp-raise); --fx-raise-s: url(#sp-raise-s); --fx-press: url(#sp-press);
  --shadow-sm: 0 0.5px 1.3px -0.4px rgb(70 57 42 / 0.035), 0 1.9px 5.1px -0.8px rgb(70 57 42 / 0.031), 0 4.3px 11.5px -1.2px rgb(70 57 42 / 0.027), 0 7.7px 20.5px -1.6px rgb(70 57 42 / 0.022), 0 12px 32px -2px rgb(70 57 42 / 0.018);
  --shadow-md: 0 0.7px 1.7px -0.7px rgb(70 57 42 / 0.037), 0 2.7px 6.7px -1.3px rgb(70 57 42 / 0.033), 0 6px 15px -2px rgb(70 57 42 / 0.03), 0 10.7px 26.7px -2.7px rgb(70 57 42 / 0.026), 0 16.7px 41.7px -3.3px rgb(70 57 42 / 0.022), 0 24px 60px -4px rgb(70 57 42 / 0.018);
  --shadow-lg: 0 1.3px 3.1px -1.3px rgb(70 57 42 / 0.052), 0 5.3px 12.2px -2.7px rgb(70 57 42 / 0.047), 0 12px 27.5px -4px rgb(70 57 42 / 0.042), 0 21.3px 48.9px -5.3px rgb(70 57 42 / 0.036), 0 33.3px 76.4px -6.7px rgb(70 57 42 / 0.031), 0 48px 110px -8px rgb(70 57 42 / 0.026);

  /* ---- typography ---- */
  --font-head: "Outfit", "Avenir Next", system-ui, sans-serif;
  --font-body: "Inter", system-ui, -apple-system, "Segoe UI", sans-serif;
  --font-clock: "DM Mono", ui-monospace, Menlo, monospace;
  --fs-1: 12px; --fs-2: 13px; --fs-3: 14px; --fs-4: 15px; --fs-5: 18px;
  --fs-6: 22px; --fs-7: 26px; --fs-8: 32px; --fs-9: 40px; --fs-10: 56px;
  --fw-regular: 400; --fw-medium: 500; --fw-semibold: 600; --fw-bold: 700;
  --lh-none: 1; --lh-tight: 1.05; --lh-snug: 1.1; --lh-heading: 1.2; --lh-title: 1.3; --lh-ui: 1.45; --lh-body: 1.55;
  --ls-display: -0.03em; --ls-h1: -0.025em; --ls-figure: -0.02em; --ls-h2: -0.015em; --ls-h3: -0.005em;

  /* ---- spacing and layout ---- */
  --s-0: 2px; --s-1: 4px; --s-2: 8px; --s-3: 12px; --s-4: 16px; --s-5: 24px; --s-6: 32px; --s-7: 48px; --s-8: 64px; --s-9: 96px; --s-10: 128px;
  --container: 1120px; --container-text: 560px; --measure: 65ch; --dialog-w: 400px; --popover-w: 240px;
  --gutter: max(16px, 4vw);      /* page side padding */
  --grid-gap: var(--s-5);        /* var(--s-4) under 600px */
  --section: var(--s-9);         /* var(--s-8) under 600px */
  --panel-pad: var(--s-6);       /* var(--s-5) under 600px */
  /* breakpoints (constants, CSS cannot read variables in media queries): 600px, 960px */
  --z-nav: 50; --z-overlay: 80; --z-toast: 90; --z-tooltip: 100;

  /* ---- shape ---- */
  --r-xs: 3px; --r-sm: 6px; --r-md: 10px; --r-lg: 12px; --r-xl: 14px; --r-2xl: 22px; --r-pill: 999px;
  --bw-1: 1px; --bw-2: 2px; --focus-offset: 2px;

  /* ---- sizes ---- */
  --h-xs: 24px; --h-sm: 32px; --h-md: 36px; --h-lg: 40px; --h-xl: 48px; --h-2xl: 52px;
  --size-cat: 10px; --size-bead: 16px; --size-knob-s: 18px; --size-check: 20px; --size-knob: 22px; --size-avatar: 32px;
  --track: 6px; --bar: 8px; --pill-rest: 8px; --pill: 12px; --chart-bar: 22px;
  --icon-xs: 14px; --icon-sm: 16px; --icon-md: 18px; --icon-lg: 20px; --icon-stroke: 1.75;
  --indicator-w: 14px; --indicator-h: 3px; --hit: 44px;
  --disabled-opacity: 0.45; --blur-nav: 16px; --blur-scrim: 4px;

  /* ---- motion ---- */
  --d-press: 160ms; --d-quick: 150ms; --d-base: 250ms; --d-move: 300ms; --d-slow: 450ms; --d-reveal: 600ms;
  --d-spin: 700ms; --d-hint: 400ms; --d-breathe: 1.6s; --stagger: 30ms;
  --ease-out: cubic-bezier(0.23, 1, 0.32, 1);
  --ease-in-out: cubic-bezier(0.77, 0, 0.175, 1);
  --ease-drawer: cubic-bezier(0.32, 0.72, 0, 1);
  --ease-settle: linear(0, 0.026 3.1%, 0.092 6.2%, 0.182 9.4%, 0.283 12.5%, 0.388 15.6%, 0.489 18.8%, 0.584 21.9%, 0.669 25%, 0.744 28.1%, 0.807 31.2%, 0.86 34.4%, 0.903 37.5%, 0.937 40.6%, 0.964 43.8%, 0.984 46.9%, 0.998 50%, 1.008 53.1%, 1.014 56.2%, 1.018 59.4%, 1.02 62.5%, 1.02 65.6%, 1.019 68.8%, 1.017 71.9%, 1.016 75%, 1.013 78.1%, 1.011 81.2%, 1.009 84.4%, 1.008 87.5%, 1.006 90.6%, 1.005 93.8%, 1.003 96.9%, 1);
}

/* ---- dark: opt-in only. Light is the default; dark applies when the person chooses it (data-theme="dark"). ---- */
:root[data-theme="dark"] {
  color-scheme: dark;
  --paper: var(--night-950); --surface: var(--night-900); --well: var(--night-850); --band: var(--night-925);
  --raised: var(--night-800); --raised-hover: var(--night-750); --knob: var(--night-100); --bead: var(--night-600);
  --scrim: rgb(20 23 31 / 0.62); --nav-glass: rgb(20 23 31 / 0.88);
  --ink: var(--night-50); --ink-muted: var(--night-300); --ink-faint: var(--night-500); --on-accent: var(--night-950);
  --line: rgb(255 255 255 / 0.07); --edge: transparent; --well-rim: rgb(255 255 255 / 0.06); --knob-rim: rgb(0 0 0 / 0.35); --focus: var(--blue-350);
  --accent-hover: var(--blue-250); --accent-strong: var(--blue-350); --accent-tint: var(--blue-900);
  --success-text: var(--sage-400);  --success-tint: var(--sage-900);
  --warning-text: var(--honey-400); --warning-tint: var(--honey-900);
  --error-text: var(--rose-300);    --error-tint: var(--rose-900);
  --info-text: var(--blue-350);     --info-tint: var(--blue-900);
  --data-ink: var(--night-350);
  --cat-peach-text: var(--peach-400); --cat-lilac-text: var(--lilac-400); --cat-blush-text: var(--blush-400); --cat-mist-text: var(--mist-400); --cat-sand-text: var(--sand-400);
  --fx-raise: url(#sp-raise-d); --fx-raise-s: url(#sp-raise-s-d); --fx-press: url(#sp-press-d);
  --shadow-sm: 0 1px 2px rgb(0 0 0 / 0.25), 0 6px 18px rgb(0 0 0 / 0.2);
  --shadow-md: 0 2px 4px rgb(0 0 0 / 0.25), 0 12px 32px rgb(0 0 0 / 0.3);
  --shadow-lg: 0 2px 8px rgb(0 0 0 / 0.3), 0 24px 64px rgb(0 0 0 / 0.45);
}
body { background: var(--paper); color: var(--ink); font: var(--fw-regular) var(--fs-4)/var(--lh-body) var(--font-body); }
::selection { background: var(--accent-tint); color: var(--ink); }
input, textarea { caret-color: var(--accent-strong); }
```

The same theme as JSON, for Tailwind `theme.extend` or design tools. `{name}` points at a primitive.

```json
{
  "primitives": {
    "white": "#FFFFFF", "cream-25": "#FAF9F6", "cream-50": "#F6F4EE", "cream-100": "#EFECE4",
    "grey-400": "#85878B", "grey-500": "#62656D", "grey-600": "#5A5E6B", "ink-900": "#1D2230",
    "night-50": "#F2F0EA", "night-100": "#E8E6E0", "night-300": "#A6AAB6", "night-350": "#9A9BA0", "night-500": "#6E7383", "night-600": "#4A5062",
    "night-750": "#333949", "night-800": "#2C3140", "night-850": "#252A37", "night-900": "#1D212C", "night-925": "#181B24", "night-950": "#14171F",
    "blue-100": "#DAEBFA", "blue-250": "#97C9F3", "blue-300": "#93C6F2", "blue-350": "#8EC3F2", "blue-400": "#84BDF0", "blue-700": "#2A66A8", "blue-900": "#22344B",
    "sage-100": "#DBE8DE", "sage-400": "#86B391", "sage-700": "#497453", "sage-900": "#273232",
    "honey-100": "#F7EAD0", "honey-400": "#E3B961", "honey-700": "#896418", "honey-900": "#37332A",
    "rose-100": "#F3D5D8", "rose-300": "#E08A91", "rose-350": "#DC8289", "rose-400": "#D8747C", "rose-700": "#C23641", "rose-900": "#35272F",
    "peach-400": "#E3997A", "peach-700": "#AF4D25", "lilac-400": "#A797D6", "lilac-700": "#7259BD", "blush-400": "#E29CB8", "blush-700": "#BD376D",
    "mist-400": "#74B4AE", "mist-700": "#3F746F", "sand-400": "#CFA77C", "sand-700": "#8D6234"
  },
  "roles": {
    "paper": {"light": "{cream-50}", "dark": "{night-950}"},
    "surface": {"light": "{white}", "dark": "{night-900}"},
    "well": {"light": "{cream-100}", "dark": "{night-850}"},
    "band": {"light": "{cream-100}", "dark": "{night-925}"},
    "raised": {"light": "{white}", "dark": "{night-800}"},
    "raised-hover": {"light": "{cream-25}", "dark": "{night-750}"},
    "knob": {"light": "{white}", "dark": "{night-100}"},
    "bead": {"light": "{white}", "dark": "{night-600}"},
    "ink": {"light": "{ink-900}", "dark": "{night-50}"},
    "ink-muted": {"light": "{grey-600}", "dark": "{night-300}"},
    "ink-faint": {"light": "{grey-400}", "dark": "{night-500}"},
    "on-accent": {"light": "{ink-900}", "dark": "{night-950}"},
    "focus": {"light": "{blue-700}", "dark": "{blue-350}"},
    "accent": {"light": "{blue-400}", "dark": "{blue-400}"},
    "accent-hover": {"light": "{blue-300}", "dark": "{blue-250}"},
    "accent-strong": {"light": "{blue-700}", "dark": "{blue-350}"},
    "accent-tint": {"light": "{blue-100}", "dark": "{blue-900}"},
    "danger": {"light": "{rose-400}", "dark": "{rose-400}"},
    "danger-hover": {"light": "{rose-350}", "dark": "{rose-350}"},
    "success": {"light": "{sage-400}", "dark": "{sage-400}"}, "success-text": {"light": "{sage-700}", "dark": "{sage-400}"}, "success-tint": {"light": "{sage-100}", "dark": "{sage-900}"},
    "warning": {"light": "{honey-400}", "dark": "{honey-400}"}, "warning-text": {"light": "{honey-700}", "dark": "{honey-400}"}, "warning-tint": {"light": "{honey-100}", "dark": "{honey-900}"},
    "error": {"light": "{rose-400}", "dark": "{rose-400}"}, "error-text": {"light": "{rose-700}", "dark": "{rose-300}"}, "error-tint": {"light": "{rose-100}", "dark": "{rose-900}"},
    "info": {"light": "{blue-400}", "dark": "{blue-400}"}, "info-text": {"light": "{blue-700}", "dark": "{blue-350}"}, "info-tint": {"light": "{blue-100}", "dark": "{blue-900}"},
    "data-ink": {"light": "{grey-500}", "dark": "{night-350}"},
    "cat-peach": "{peach-400}", "cat-lilac": "{lilac-400}", "cat-blush": "{blush-400}", "cat-mist": "{mist-400}", "cat-sand": "{sand-400}"
  },
  "fontFamily": { "head": ["Outfit", "Avenir Next", "system-ui", "sans-serif"], "body": ["Inter", "system-ui", "-apple-system", "Segoe UI", "sans-serif"], "clock": ["DM Mono", "ui-monospace", "Menlo", "monospace"] },
  "fontSize": { "1": "12px", "2": "13px", "3": "14px", "4": "15px", "5": "18px", "6": "22px", "7": "26px", "8": "32px", "9": "40px", "10": "56px" },
  "spacing": { "0": "2px", "1": "4px", "2": "8px", "3": "12px", "4": "16px", "5": "24px", "6": "32px", "7": "48px", "8": "64px", "9": "96px", "10": "128px" },
  "borderRadius": { "xs": "3px", "sm": "6px", "md": "10px", "lg": "12px", "xl": "14px", "2xl": "22px", "pill": "999px" },
  "transitionDuration": { "press": "160ms", "quick": "150ms", "base": "250ms", "move": "300ms", "slow": "450ms", "reveal": "600ms" },
  "transitionTimingFunction": { "out": "cubic-bezier(0.23, 1, 0.32, 1)", "in-out": "cubic-bezier(0.77, 0, 0.175, 1)", "drawer": "cubic-bezier(0.32, 0.72, 0, 1)" }
}
```

Every other value (heights, sizes, line heights, tracking, shadows, motion extras) is in the CSS above; the CSS is the source of truth.

---

## 14. Do / Don't

| Do | Don't |
|---|---|
| Use roles and scale steps in components. | Write a raw hex, size or duration in a component. |
| Choose paper, panel or band block by block (§5.1). | Put everything on the background, or wrap every heading in a card. |
| Treat sibling units alike, a panel each. | Mix panels and bare blocks for the same kind of content, or nest panels. |
| Give soft relief to small things you touch and to data. | Put relief on panels, images or large areas. |
| Use puffy beads and pills for units, categories, progress and charts. | Use squares, sharp bars or flat dots. |
| Light dark mode with the dark relief set. | Reuse the light filters on dark colours. |
| Filter a separate shape layer under the label. | Filter an element that contains text. |
| Define controls by fill and relief, each with a visible label. | Outline controls, or leave one without a label. |
| Keep panels flat with a wide, faint, warm shadow. | Use grey or black shadows in light mode. |
| Use blue for the primary action, selection and info. | Add a second brand colour or colour backgrounds. |
| Fill destructive buttons with `--danger`. | Make a destructive action look like the primary. |
| Press with `scale(0.97)` and change only colour on hover. | Lift buttons on hover or sink them on press. |
| Morph a button through loading and success in place. | Replace the button with a separate spinner or message. |
| Slide thumbs, indicators and knobs to their new place. | Fade everything out and back in. |
| Start motion from `scale(0.9+)` with `ease-out`, under 300 ms. | Animate from `scale(0)` or use `ease-in`. |
| Show each piece of information once. | Repeat it as a number, a mark and a label. |
| Separate items with space. | Join items with `·`, `|` or `/`, or add uppercase eyebrows. |

---

## 15. Review checklist

1. Does every element have a job, shown once?
2. Does every component use roles and scale steps only, with no raw values?
3. Was every block placed with §5.1: reading on paper, operable things and self-contained units in panels, at most one band?
4. Do only small, touchable things and data have relief, subtle and on a shape layer, never on text?
5. Is there exactly one primary (blue) button per screen, and are destructive actions rose?
6. Do buttons press with a quick scale, hover with colour only, and morph through loading and success in place?
7. Is every control free of outlines, labelled, and is every on-state shown by more than colour?
8. Is every mark and every piece of data puffy, and only inside data and controls?
9. Are colours muted, meaningful and under 8 % of the screen, and never the only signal?
10. Do persistent things move to their new place, and do overlays grow from their trigger?
11. Is UI motion under 300 ms with `ease-out`, never from `scale(0)`, and do frequent actions skip animation?
12. Is the text free of separators and uppercase labels, and does every text style match a role in §4.2?
13. Does every text pair pass AA in light and dark, and does each control look like the same object in both themes?
14. Does it still work with reduced motion and in forced-colours mode?
15. Is it eye candy, nice to see, recognizable, clean, and does everything serve a purpose?
