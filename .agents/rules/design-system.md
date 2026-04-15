---
trigger: always_on
---

# 🎨 UI Design System (Supabase-Inspired)

## 1. 🌌 Visual Theme & Atmosphere

A dark-mode-native system inspired by developer tools and terminal environments.

### Core Characteristics
- Backgrounds:
  - `#0f0f0f` → deep surface
  - `#171717` → primary canvas
- Accent identity:
  - `#3ecf8e` → brand green
  - `#00c573` → interactive green
- No pure black → always slightly lifted tones
- Minimalist, high-contrast, content-focused

### Design Philosophy
- Feels like a **code editor UI evolved into product UI**
- Depth through **transparency + borders**, not shadows
- Green is an **identity signal**, not decoration

---

## 2. 🎨 Color System

### Brand Colors
| Role | Value | Usage |
|------|------|------|
| Primary Green | `#3ecf8e` | Logo, accents |
| Link Green | `#00c573` | Links, actions |
| Green Border | `rgba(62,207,142,0.3)` | Focus/accent |

---

### Neutral Scale (Dark Mode)
| Role | Value |
|------|------|
| Near Black | `#0f0f0f` |
| Background | `#171717` |
| Divider | `#242424` |
| Border | `#2e2e2e` |
| Mid Border | `#363636` |
| Light Border | `#393939` |
| Charcoal | `#434343` |
| Dark Gray | `#4d4d4d` |
| Muted | `#898989` |
| Secondary | `#b4b4b4` |
| Primary Text | `#fafafa` |

---

### Radix / Accent Tokens (Optional)
- Purple, Violet → secondary accents
- Crimson → alerts
- Yellow → warning
- Orange → highlight
- Indigo → subtle overlay

---

### Surface & Overlay
- Glass surface: `rgba(41,41,41,0.84)`
- Alpha overlays (HSL-based layering)
- Subtle blue tint overlays for depth

---

## 3. ✍️ Typography

### Font Families
- Primary: Circular
- Fallback: Helvetica, Arial
- Monospace: Source Code Pro

---

### Type Scale

| Role | Size | Weight | Line Height | Notes |
|------|------|--------|-------------|------|
| Hero | 72px | 400 | 1.00 | Signature style |
| Section Heading | 36px | 400 | 1.25 | Clean headings |
| Card Title | 24px | 400 | 1.33 | -0.16px tracking |
| Subheading | 18px | 400 | 1.56 | Secondary |
| Body | 16px | 400 | 1.50 | Default |
| Nav | 14px | 500 | 1.2 | Interactive |
| Button | 14px | 500 | 1.14 | Tight |
| Small | 12px | 400 | 1.33 | Metadata |
| Code Label | 12px | 400 | 1.33 | Uppercase + spaced |

---

### Typography Rules
- No bold (700)
- Use **size for hierarchy**
- Hero line-height = **1.00 (important)**
- Slight negative letter spacing for titles
- Monospace only for technical context

---

## 4. 🧩 Components

### Buttons

#### Primary (Pill)
- Background: `#0f0f0f`
- Text: `#fafafa`
- Border: `1px solid #fafafa`
- Radius: `9999px`
- Padding: `8px 32px`

#### Secondary
- Border: `1px solid #2e2e2e`
- Same structure as primary
- Lower emphasis

#### Ghost
- Transparent background
- Border: none
- Radius: `6px`

---

### Cards & Containers
- Background: `#171717`
- Border: `1px solid #2e2e2e`
- Radius: `8–16px`
- Padding: `16–24px`
- No shadows

---

### Tabs
- Pill-based layout (`9999px`)
- Active:
  - green highlight OR lighter bg
- Inactive:
  - muted dark
- Border: `#2e2e2e`

---

### Links
| Type | Color |
|------|------|
| Primary | `#fafafa` |
| Green | `#00c573` |
| Secondary | `#b4b4b4` |
| Muted | `#898989` |

---

### Navigation
- Background: `#171717`
- Font: 14px, weight 500
- Layout: horizontal
- CTA: pill button
- Sticky behavior

---

## 5. 📐 Layout System

### Spacing Scale
Base unit: **8px**


### Spacing Philosophy
- Large section gaps: **90–128px**
- Internal spacing: **16–24px**
- Dense content clusters

---

### Grid System
- Centered layout
- Max-width container
- Card-based grids
- Feature grids with consistent sizing

---

### Breakpoints
| Type | Width |
|------|------|
| Mobile | <600px |
| Desktop | >600px |

Mobile-first approach

---

## 6. 🧱 Border Radius

| Type | Value |
|------|------|
| Small | 6px |
| Standard | 8px |
| Medium | 12px |
| Large | 16px |
| Pill | 9999px |

---

## 7. 🌫️ Depth & Elevation

| Level | Style | Use |
|------|------|------|
| Flat | `#2e2e2e` | Default |
| Hover | `#363636` | Interaction |
| Focus | subtle shadow | Accessibility |
| Accent | green border | Highlight |

### Depth Rules
- No heavy shadows
- Use **border hierarchy**
- Transparency for layering

---

## 8. 📱 Responsive Behavior

### Mobile (<600px)
- Full-width buttons

## 9. 🤖 Agent Prompt Guide

This section is designed for AI agents (or devs using AI tools) to quickly generate UI components that strictly follow the design system.

---

## 🎨 Quick Color Reference

### Backgrounds
- Primary Surface: `#171717`
- Deep Surface / Button BG: `#0f0f0f`

### Text Colors
- Primary Text: `#fafafa`
- Secondary Text: `#b4b4b4`
- Muted Text: `#898989`

### Brand Colors
- Brand Green: `#3ecf8e`
- Interactive Green (Links): `#00c573`

### Borders
- Subtle Border: `#242424`
- Standard Border: `#2e2e2e`
- Prominent Border: `#363636`

### Accent Border
- Green Accent Border: `rgba(62, 207, 142, 0.3)`

