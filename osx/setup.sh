#!/bin/bash

# inspiration from
# * https://www.davd.io/os-x-automated-provisioning-using-homebrew-and-cask/
# * https://github.com/kevinSuttle/macOS-Defaults/blob/master/.macos

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &



# This remaps Caps Lock to the Left Control button
# https://developer.apple.com/library/archive/technotes/tn2450/_index.html
#
#   hidutil property --set '{"UserKeyMapping":
#       [{"HIDKeyboardModifierMappingSrc":0x700000039,
#       "HIDKeyboardModifierMappingDst":0x7000000e0}]
#   }'
#
# But the hidutil effects get reset on reboot, so it has to be done with 
# a launch agent...

cat > ~/Library/LaunchAgents/com.ldaws.CapslockControl.plist <<- EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.ldaws.CapslockControl</string>
    <key>ProgramArguments</key>
    <array>
      <string>/usr/bin/hidutil</string>
      <string>property</string>
      <string>--set</string>
      <string>{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000e0}]}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
  </dict>
</plist>
EOS
launchctl load ~/Library/LaunchAgents/com.ldaws.CapslockControl.plist
# If the launchctl command returns a mysterious "Load failed: 5: Input/output error" it probably means
# that the load has already taken place. Great error handling there amigos...
# Use `launchctl unload ~/Library/LaunchAgents/com.ldaws.CapslockControl.plist` to reset...




# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "


# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
# Possible values: `WhenScrolling`, `Automatic` and `Always`



# Stop iTunes from responding to the keyboard media keys
#launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null
# Not sure if this is needed since spotify seems to respect the keys ok for now...

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Quit printer app when job is completed
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable smart quotes & dashes
#defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
#defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
#defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false


# Disable keyboard illumination on 5 minutes standby
# defaults write com.apple.BezelServices kDimTime -int 300

# Enable subpixel rendering on non-apple lcds
# defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true
#
# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show POSIX path as finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Finder status bar originating from $HOME instead of /
# defaults write /Library/Preferences/com.apple.finder PathBarRootAtHome -bool YES



# Show all file extensions
/usr/bin/defaults write com.apple.finder AppleShowAllExtensions -bool YES

# Show warning before changing an extension
/usr/bin/defaults write com.apple.finder FXEnableExtensionChangeWarning -bool YES


# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Home dir as default finder location
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"


# Show only open applications in the Dock
#defaults write com.apple.dock static-only -bool true




killall Finder
killall Dock





# If you want to enable additional items, look in ~/Library/Preferences/com.apple.systemuiserver.plist to find the specific name of the menu extra you are seeking.

defaults write com.apple.systemuiserver menuExtras -array \
"/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
"/System/Library/CoreServices/Menu Extras/Clock.menu"

defaults write com.apple.menuextra.battery ShowPercent YES
killall SystemUIServer