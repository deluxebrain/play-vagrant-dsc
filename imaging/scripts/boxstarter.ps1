Update-ExecutionPolicy -Policy Unrestricted

Write-BoxstarterMessage "Setting timezone to UTC"
tzutil /s "UTC"

Write-BoxstarterMessage "Enabling RDP"
Enable-RemoteDesktop
Set-NetFirewallRule -Name RemoteDesktop-UserMode-In-TCP -Enabled True

# Remove the page file - saving a load of space in the packer image
# Its turned back on at end of this provisioning script and will be
# regenerated when image is first used
Write-BoxstarterMessage "Removing page file"
$pageFileMemoryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
Set-ItemProperty -Path $pageFileMemoryKey -Name PagingFiles -Value ""

# Disable-MicrosoftUpdate
Write-BoxstarterMessage "Setting general preferences"
Disable-InternetExplorerESC
Disable-BingSearch
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableOpenFileExplorerToQuickAccess -EnableShowRecentFilesInQuickAccess -EnableShowFrequentFoldersInQuickAccess -EnableExpandToOpenFolder

Write-BoxstarterMessage "Installing Powershell and WMI"
choco install powershell -y

Write-BoxstarterMessage "Installing tooling"
choco install 7zip -y
choco install 7zip.commandline -y

Write-BoxstarterMessage "Installing critical Windows updates"
Install-WindowsUpdate -AcceptEula
if(Test-PendingReboot){ Invoke-Reboot }

# Run the DISM cleanup that cleans the WinSxs folder of rollback files for all installed updates
Write-BoxstarterMessage "Cleaning SxS..."
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase

Write-BoxstarterMessage "defragging..."
Optimize-Volume -DriveLetter C

# Zero out empty space to help with compression
Write-BoxstarterMessage "0ing out empty space..."
wget http://download.sysinternals.com/files/SDelete.zip -OutFile sdelete.zip
[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem")
[System.IO.Compression.ZipFile]::ExtractToDirectory("sdelete.zip", ".") 
./sdelete.exe /accepteula -z c:

# Re-enable page file
Write-BoxstarterMessage "Recreate [agefile after sysprep"
$System = GWMI Win32_ComputerSystem -EnableAllPrivileges
$System.AutomaticManagedPagefile = $true
$System.Put()

Write-BoxstarterMessage "Setting up winrm"
Set-NetFirewallRule -Name WINRM-HTTP-In-TCP-PUBLIC -RemoteAddress Any
Enable-WSManCredSSP -Force -Role Server

# Turn on winrm - this will be detected by packer which will reboot the box
Enable-PSRemoting -Force -SkipNetworkProfileCheck
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

