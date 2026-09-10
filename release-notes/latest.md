- Fixed UI scale slider clamping loaded value incorrectly.
- UI scaling properly responds to window size changes when manage
  resolution is off.
- `UIScalingSubViewport` no longer loses its connections if you change
  the local options on `OptionsProvider`, or instantiate it before
  calling `start_up()`.
- Fixed default UI scale not calculating correctly.
- Add manage VSync mode capability
- Update `README.md` install instructions to direct users to releases
  page.
