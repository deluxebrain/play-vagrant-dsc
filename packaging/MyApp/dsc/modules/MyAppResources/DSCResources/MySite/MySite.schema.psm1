Configuration MySite
{
  param 
  (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$MachineName,
    [string]$SourcePath,
    [string]$AppPoolName = "MySite",
    [string]$WebAppPath = "c:\inetpub\wwwroot\MySit",
    [string]$WebAppName = "MySite",
    [string]$HostNameSuffix = "com",
    [string]$HostName = "MySite.example.${HostNameSuffix}"
  )

  Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
  Import-DscResource -Module 'xWebAdministration'
  Import-DscResource -Module 'xNetworking'

  Write-Host "MySite DSC Config :: MachineName=$MachineName, WebAppName=$WebAppName"
  
  Node $MachineName
  {
      File WebProject
      {
        Ensure = "Present"  
        SourcePath = $SourcePath
        DestinationPath = $WebAppPath
        Recurse = $true
        Type = "Directory"
      }

      xWebAppPool MySite
      {
        Ensure = "Present"
        Name = $AppPoolName
        State = "Started"
        IdentityType = "ApplicationPoolIdentity"
      }

      xWebsite MySite
      {
        Ensure = "Present"
        Name = $WebAppName
        ApplicationPool = $AppPoolName
        PhysicalPath = $WebAppPath
        State = "Started"
        BindingInfo = @(
          MSFT_xWebBindingInformation
          {
            Protocol = "http"
            Port = 80
            HostName = $HostName
            IPAddress = "*"
          })
        AuthenticationInfo = MSFT_xWebAuthenticationInformation
        {
            Anonymous = $true
            Basic = $false
            Digest = $false
            Windows = $false
        }
    }
  }
}
