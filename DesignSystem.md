# Qulpynai Design System

Production-level UI/UX design system for the Qulpynai bakery/coffee chain MVP iOS app.

## Typography

| Style | Size | Weight | Use |
|-------|------|--------|-----|
| Display | 34pt | Bold | Splash, hero |
| Headline | 28pt | Semibold | Screen titles |
| Subheadline | 22pt | Semibold | Section headers |
| Title | 17pt | Semibold | Card/product titles |
| Body | 17pt | Regular | Descriptions |
| BodySmall | 15pt | Regular | Secondary text |
| Caption | 13pt | Regular | Labels, metadata |
| CaptionSmall | 11pt | Medium | Badges |

## Colors

| Token | Light | Dark |
|-------|-------|------|
| Primary | #2C1810 | #E8D5C4 |
| Secondary | #8B6914 | #D4A84B |
| Accent | #C4A77D | #A68B5B |
| Background | #FFFBF7 | #1A1512 |
| Surface | #FFFFFF | #2C2420 |
| SurfaceVariant | #F5EFE8 | #3D342E |
| TextPrimary | #1A1512 | #FFFBF7 |
| TextSecondary | #6B5B52 | #B8A99A |
| Error | #C62828 | #EF5350 |
| Success | #2E7D32 | #66BB6A |

## Spacing (8pt grid)

- xs: 4pt | sm: 8pt | md: 16pt | lg: 24pt | xl: 32pt | xxl: 48pt

## Corner Radius

- small: 8pt | medium: 12pt | large: 16pt | modal: 24pt

## Components

- **DSButton** — Primary, Secondary, Tertiary, Disabled
- **DSCard** — Default, elevated
- **DSProductCard** — Grid, list
- **DSInput** — Text, password
- **DSChip** — Category/filter
- **DSBadge** — Count overlay
- **DSEmptyState** — Empty cart, no orders
- **DSLoadingState** — Spinner, skeleton
- **DSBanner** — Promo, alert

## SwiftUI Mapping

```
Qulpynai/Core/Theme/
├── Colors.swift
├── Typography.swift
├── Spacing.swift
└── Components/
    ├── DSButton.swift
    ├── DSCard.swift
    ├── DSProductCard.swift
    ├── DSInput.swift
    ├── DSChip.swift
    ├── DSBadge.swift
    ├── DSEmptyState.swift
    ├── DSLoadingState.swift
    └── DSBanner.swift
```

## Localization

- **Localizable.xcstrings** — EN + RU
- All user-facing strings use `String(localized:)` or `LocalizedStringKey`
