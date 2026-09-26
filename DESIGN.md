---
name: Dr.Her
description: 의료 예약 서비스
colors:
  ink: '#13263f'
  muted: '#4a5f76'
  action: '#1f5fb4'
  action-hover: '#184d93'
  line: '#d5e0ec'
  surface: '#f1f5fa'
  white: '#ffffff'
  error: '#a3262f'
  available: '#17663f'
  attention: '#8a5a00'
  field: '#8fa1b8'
  focus: '#2d7ad6'
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

Clinical white content, dark-blue text and medical-blue actions organize hospital search, reservation, personal records and administration. Neutral summary areas separate supporting information from the next task. The source JSP presentation and synthetic compatibility workspace use the same color roles but retain their own layout selectors.

The JSP/Tiles UI is the native server path. The separate workspace is newly authored compatibility presentation with synthetic local state; its successful actions do not prove an operational provider or database.

Evidence: [portfolio-demo/runtime/workspace.css](portfolio-demo/runtime/workspace.css) and [src/main/webapp/css/ui.css](src/main/webapp/css/ui.css). This document records the implemented cascade on 2026-09-26. The 2026-09-26 booking refresh was written without browser access; root performs the rendered desktop/mobile review. Screen-reader output and real keyboard behavior remain unverified until then.

## Colors

The frontmatter is the normative inventory. On 2026-09-26 the user asked for a hospital-appropriate palette: medical blue `#1f5fb4` for actions, selection and the brand cross mark; dark blue `#13263f` text; cool clinical surfaces `#f1f5fa`/`#eaf1fa`; green `#17663f` on `#e3f4ea` only for available/confirmed states (open slots, 온라인 예약, 예약 확정, success); amber `#8a5a00` on `#fdf1d8` for pending attention (후기 대기, 처리할 예정 예약); red `#a3262f` on `#fbeaea` for cancelled/closed and errors. The native JSP stylesheet uses the same blue roles. Errors retain textual feedback alongside color. No new raster assets were added.

## Typography

Use the actual system/Korean sans stack in the frontmatter. Do not require a downloaded font to complete a task. Titles establish hierarchy through size and weight. Form controls inherit the body face; tabular records remain readable at the body scale.

## Layout

Native content is bounded at 1152px; the compatibility workspace is 1176px including 24px side padding. Task content and summary use a 1.7fr / minimum 280px grid with 48px separation. The search form collapses to two columns at 960px and one at 760px; the day strip is a four-column grid; booking and summary panels are sticky above 760px. At 760px the workspace and native home become one column; native administrative navigation also stacks. Native home titles use 32px (27px on mobile); workspace titles use 30px (26px on mobile).

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
- Header: one 64px sticky bar (brand cross mark, horizontally scrollable main menu with a 2px blue current underline, account) and a slim blue-tinted environment line; wraps to two rows at 960px.
- Workspace search: one-row search form (condition, query, sort, action) with manual coordinates folded; department chips built from catalog MAJOR values with counts (`aria-pressed` on the active one). Result rows show name, department chip, online-booking chip (`온라인 예약` green / `전화 문의` red), first H_COMM sentence, hours, INTERVALL, address, distance, rating. The aside shows the next reservation, or 오늘 예약 가능 hospitals computed from today's real `times` (earliest time and count; each opens the slot view).
- Hospital detail: H_COMM lede, facts list (hours with meal hour, interval, address, phone), DOC_COMM split into a doctor list (existing synthetic 가상 의사 text only), review block from existing RATING rows (four category meters + five latest comments). Sticky white booking panel with an 8-day strip whose counts are the real `times` availability; days without slots are disabled `마감`.
- Booking: time slots as radio chips grouped 오전/오후 under a legend with remaining count and interval; the summary aside repeats hospital, department, date, selected time and point use.
- Reservations/past/admin rows start with a date block (month, day, weekday). Status chips: 예정/예약 확정 green, 진료 완료 grey, 취소 red, 후기 대기 amber.
- Admin opens with a five-cell count strip (예정/완료/취소 예약, 회원 with 이용 중지, 후기) computed from stored state; pending reservations sort first.

The companion [.impeccable/design.json](.impeccable/design.json) contains 6 isolated HTML/CSS samples of these implemented patterns. They are illustrative samples, not live application controls.

## Do's and Don'ts

- Do preserve original route, field and listener contracts.
- Do identify synthetic data and the selected execution environment.
- Do retain visible focus and reduced-motion treatment.
- Do use source values when extending an existing component.
- Don't claim a native provider succeeded from a synthetic demo result.
- Don't treat this code-only review as visual approval.
