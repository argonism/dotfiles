{ username, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";

  # These settings target the existing local account.
  system.primaryUser = username;
  users.users.${username}.home = "/Users/${username}";

  # Keep the NixOS/nix-installer installation as-is. nix-darwin manages
  # macOS, but does not replace the Nix daemon or /etc/nix/nix.conf.
  nix.enable = false;

  networking.localHostName = "Kota-UsuhaMacBook-Pro";
  networking.computerName = "Kota UsuhaのMacBook Pro";
  time.timeZone = "Asia/Tokyo";

  # Values captured from this Mac on 2026-07-25. Only preferences that
  # were explicitly present and have a supported nix-darwin option are
  # declared here.
  system.defaults = {
    NSGlobalDomain = {
      NSAutomaticCapitalizationEnabled = true;
      NSAutomaticPeriodSubstitutionEnabled = false;
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.trackpad.forceClick" = false;
    };

    dock = {
      autohide = true;
      tilesize = 39;
      mru-spaces = false;
      showMissionControlGestureEnabled = true;
      wvous-br-corner = 14;
    };

    finder = {
      AppleShowAllFiles = true;
      FXPreferredViewStyle = "Nlsv";
    };

    menuExtraClock = {
      ShowDate = 0;
      ShowDayOfWeek = true;
    };

    trackpad = {
      Clicking = true;
      Dragging = false;
      DragLock = false;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
      TrackpadThreeFingerTapGesture = 2;
      FirstClickThreshold = 1;
      SecondClickThreshold = 1;
      TrackpadCornerSecondaryClick = 0;
      ActuateDetents = true;
      TrackpadFourFingerHorizSwipeGesture = 2;
      TrackpadFourFingerPinchGesture = 2;
      TrackpadFourFingerVertSwipeGesture = 2;
      TrackpadMomentumScroll = true;
      TrackpadPinch = true;
      TrackpadRotate = true;
      TrackpadThreeFingerHorizSwipeGesture = 0;
      TrackpadThreeFingerVertSwipeGesture = 0;
      TrackpadTwoFingerDoubleTapGesture = true;
      TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
    };

    WindowManager = {
      AppWindowGroupingBehavior = true;
      AutoHide = false;
      HideDesktop = true;
      EnableTopTilingByEdgeDrag = false;
      EnableTiledWindowMargins = false;
      StandardHideWidgets = false;
      StageManagerHideWidgets = false;
    };
  };

  # Do not change after the first activation. This is the nix-darwin
  # compatibility version, not the macOS version.
  system.stateVersion = 7;
}
