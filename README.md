# Toijala Lunch

A Sailfish OS app that displays the daily lunch menu and provides a **Päivitä**
button to reload it. The menu is fetched from
[Leskirouva's lunch page](https://www.leskirouva.fi/lounas/).

The app opens directly to the lunch page. Menu text is scrollable and displayed
in a large font.

## Build from VS Code

Open this directory in VS Code and run **Terminal: Run Build Task** (or press
`Ctrl+Shift+B`) to build the aarch64 RPM with the Sailfish SDK in
`~/SailfishOS`. The SailfishOS 5.1.0.11 aarch64 target must be installed.

The application entry point is `qml/toijala-lunch.qml`, and its only page is
`qml/pages/LunchPage.qml`.
