#!/bin/bash

# https://macos-defaults.com/

# keyboard
#
# https://linkarzu.com/posts/2024-macos-workflow/macos-keyrepeat-rate/
#
# * (todo) remap caps to control
# * key repeat rate
# * delay until repeat
#
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 20
defaults write -g ApplePressAndHoldEnabled -bool false

# dock
#
# autohide     = true
# show-recents = false
# orientation  = bottom
#
defaults write com.apple.dock orientation -string left
defaults write com.apple.dock autohide    -bool   true
defaults write com.apple.dock mru-spaces -bool false
killall Dock

# trackpad
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.AppleMultitouchTrackpad Dragging -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -bool true
defaults write -g AppleEnableSwipeNavigateWithScrolls -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2

# screenshot
defaults write com.apple.screencapture type -string "png"


# menu bar
#
# only show = [Wi-Fi, VPN, Battery]
#

# finder
#

# login window
#
# guest login = false
#

# pam
sudo rm -rf /etc/pam.d/sudo_local
cat /etc/pam.d/sudo_local.template \
  | sed -e 's/#auth/auth/g' \
  | sudo tee /etc/pam.d/sudo_local >/dev/null
