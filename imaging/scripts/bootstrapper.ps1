# Install Chocolatey
(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')))>$null 2>&1

# Reload profile
. $profile

# Set TZ
tzutil /s "UTC"

# Provisioing
choco install Boxstarter -y

# Minimum tooling
choco install 7zip -y
choco install -y 7zip.commandline

