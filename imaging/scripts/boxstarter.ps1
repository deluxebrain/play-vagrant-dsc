# Boxstarter WinConfig features to customize the Windows experience
# http://boxstarter.org/WinConfig
Disable-MicrosoftUpdate
Disable-InternetExplorerESC
Disable-BingSearch
Enable-RemoteDesktop
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableOpenFileExplorerToQuickAccess -EnableShowRecentFilesInQuickAccess -EnableShowFrequentFoldersInQuickAccess -EnableExpandToOpenFolder

Write-BoxstarterMessage "Installing Powershell and WMI"
choco install powershell4 -y

# Install critical Windows udpates
Write-BoxstarterMessage "Installing critical Windows updates"
Install-WindowsUpdate -AcceptEula

Write-BoxstarterMessage "All done!"
