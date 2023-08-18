# cardly

## App Overview

A simple starter design and app outline.

```text
                                                CARDLY APP
                                               ────────────
┌─────────────────────────┐
│ BANNDED COUNTRIES MODEL │
│ + banned List<str>      │
└──────────┬──────────────┘   ┌─────────────────────────────────────────────┐
           │                  │                                             │
           ▼                  │ ┌───────┐                                   │
   Configure list of ─────────┤►├┼┼┼┼┼┼┼│                                   │
   banned countries           │ │┼┼┼┼┼┼┼│                                   │
                              │ └───────┘                                   │
                              │                                             │
                              │                                             │
                              │ ┌─────────────────────────────────────────┐ │
                              │ │    24                         6         │ │
                              │ │  CARDS                    COUNTRIES     │ │
                              │ │                                         │ │
                              │ └─────────────────────────────────────────┘ │
                              │                                             │
                              │ ┌─────────────────────────────────────────┐ │
    Card form input,          │ │    +                            +       │◄├──────── Camera captures card information
    bottom up modal  ─────────┤►│ Input Card                Capture Card  │ │
                              │ │                                         │ │
                              │ └─────────────────────────────────────────┘ │
                              │                                             │
                              │                                             │              ┌─────────────────────────────┐
    List view builder,        │                                             │              │                             │
    sort cards by type,──────►│  Cards From Today:                          │              │ CARD MODEL                  │
    created or country        │ ┌─────────────────────────────────────────┐ │              │ + card number               │
                              │ │ ******** 45 6123                  VISA  ◄─┼──────────────┤ + card type                 │
                              │ │ South Africa                            │ │              │ + cvv                       │
                              │ └─────────────────────────────────────────┘ │              │ + issuing country           │
                              │                                             │              │ + valid through (null=True) │
                              │ ┌─────────────────────────────────────────┐ │              │ + card holder (null=True)   │
                              │ │ ******** 09 1234              MASTERCARD│ │              │ + created                   │
                              │ │ United Kingdom                          │ │              │                             │
                              │ └─────────────────────────────────────────┘ │              └─────────────────────────────┘
                              │                                             │
                              │ ┌─────────────────────────────────────────┐ │
                              │ │                                         │ │
                              │ │                                         │ │
                              │ └─────────────────────────────────────────┘ │
                              │                                             │
                              │                                             │
                              │                                             │
                              └─────────────────────────────────────────────┘
```