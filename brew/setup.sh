#!/bin/bash

echo "Checking Homebrew"
brew --version
if [ $? -eq 0 ]; then
  echo "Homebrew already installed"
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# I should look at using the unattended brew install, since this approach requires running
# the following commands before brew can be used, so the rest of the install fails the
# first time until it's in the path, then it starts to work again
# 
# (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/trosenbl/.zprofile
# eval "$(/opt/homebrew/bin/brew shellenv)"

echo "export HOMEBREW_NO_AUTO_UPDATE=1" >> ~/.zshrc

# This is to deal with conservative outbound proxies that block brew's UA
cd /opt/homebrew/Library/Homebrew
# Reset brew in case it broke (brew can still update as it does it through git)
git reset HEAD --hard
# update homebrew repository (this will reset changes as well)
/opt/homebrew/bin/brew update
# patch brew script to force curl user agent to be used
cat brew.sh | sed 's/^HOMEBREW_USER_AGENT=.*//' | sed 's/^HOMEBREW_USER_AGENT_CURL=.*/HOMEBREW_USER_AGENT_CURL="${curl_name_and_version\/\/ \/\/}"\
HOMEBREW_USER_AGENT="${curl_name_and_version\/\/ \/\/}"/' > brew2.sh
# replace original file
chmod +x brew2.sh
rm brew.sh
mv brew2.sh brew.sh
cd

brew install \
az \
k9s \
MonitorControl \