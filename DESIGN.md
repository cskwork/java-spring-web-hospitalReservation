---
name: Dr.Her
description: 의료 예약 서비스
colors:
  ink: '#142d40'
  muted: '#4c626c'
  action: '#006b65'
  action-hover: '#004f4b'
  line: '#d4dfe3'
  surface: '#f3f6f7'
  white: '#ffffff'
  error: '#9b2636'
  field: '#8c9ea6'
  focus: '#188a84'
typography:
  title:
    fontFamily: -apple-system, BlinkMacSystemFont, "Noto Sans KR", "Malgun Gothic",
      sans-serif
    fontSize: 30px
    lineHeight: 1.3
  body:
    fontFamily: -apple-system, BlinkMacSystemFont, "Noto Sans KR", "Malgun Gothic",
      sans-serif
    fontSize: 16px
    lineHeight: 1.65
rounded:
  control: 6px
  surface: 10px
spacing:
  field: 12px
  section: 24px
  column: 48px
components:
  button-primary:
    backgroundColor: '{colors.action}'
    textColor: '#ffffff'
    rounded: '{rounded.control}'
    padding: 10px 18px
  button-primary-hover:
    backgroundColor: '{colors.action-hover}'
  input:
    backgroundColor: '#ffffff'
    textColor: '{colors.ink}'
    rounded: '{rounded.control}'
    padding: 10px 12px
---

# Design System: Dr.Her

## Overview

**Creative North Star: "의료 예약 서비스"**

White content, navy text and teal actions organize hospital search, reservation, personal records and administration. Neutral summary areas separate supporting information from the next task. The source JSP presentation and synthetic compatibility workspace use the same color roles but retain their own layout selectors.

The JSP/Tiles UI is the native server path. The separate workspace is newly authored compatibility presentation with synthetic local state; its successful actions do not prove an operational provider or database.

Evidence: [portfolio-demo/runtime/workspace.css](portfolio-demo/runtime/workspace.css) and [src/main/webapp/css/ui.css](src/main/webapp/css/ui.css). This document records the implemented cascade on 2026-09-26. Browser control, rendering and screenshots were excluded by the user; visual layout, screen-reader output and real keyboard behavior remain unverified.

## Colors

The frontmatter is the normative inventory: action for primary work, ink for readable content, muted for secondary facts, line for separation, and surface for supporting regions. Errors retain textual feedback alongside color. No new raster assets were added.

## Typography

Use the actual system/Korean sans stack in the frontmatter. Do not require a downloaded font to complete a task. Titles establish hierarchy through size and weight. Form controls inherit the body face; tabular records remain readable at the body scale.

## Layout

Native content is bounded at 1152px; the compatibility workspace is 1176px including 24px side padding. Task content and summary use a 1.7fr / minimum 280px grid with 48px separation. At 760px the workspace and native home become one column; native administrative navigation also stacks. Native home titles use 32px (27px on mobile); workspace titles use 30px (26px on mobile).

## Elevation & Depth

Task surfaces use flat fills and dividers. The documented components do not add decorative shadows.

## Shapes

Controls use 6px corners; supporting surfaces use 10px. Rows use a bottom divider. Avoid nesting additional panels inside the existing task structure.

## Components

- Primary action: action fill, white label, action-hover state and visible focus ring.
- Inputs: white fill, field border, control radius and accent caret. Keep labels and errors adjacent.
- Navigation: preserve the current-state indication and native links.
- Records: use separators and concrete status text. Empty content has an explicit message.
- Responsive and reduced-motion rules remain in the source stylesheet.

The companion [.impeccable/design.json](.impeccable/design.json) contains 6 isolated HTML/CSS samples of these implemented patterns. They are illustrative samples, not live application controls.

## Do's and Don'ts

- Do preserve original route, field and listener contracts.
- Do identify synthetic data and the selected execution environment.
- Do retain visible focus and reduced-motion treatment.
- Do use source values when extending an existing component.
- Don't claim a native provider succeeded from a synthetic demo result.
- Don't treat this code-only review as visual approval.
