Configuration MyApp
{
  param 
  (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$MachineName,
    [string]$SourcePath
  )

  Import-DscResource -Module PSDesiredStateConfiguration
  Import-DscResource -Module MyAppResources
  Import-DscResource -Module xWebAdministration
  Import-DscResource -Module xNetworking

  Write-Host "MyApp DSC Config :: MachineName=$MachineName"
  
  Node $MachineName
  {
    WindowsFeature IIS
    {
      Ensure = "Present"
      Name = "Web-Server"
    }

    WindowsFeature IISManagerFeature
    {
      Ensure = "Present"
      Name = "Web-Mgmt-Tools"
    }

    xFirewall webFirewall
    {
      Ensure = "Present"
      Name = "WebFirewallOpen"
      Direction = "Inbound"
      LocalPort = "80"
      Protocol = "TCP"
      Action = "Allow"
    }
    
    xWebsite DefaultSite
    {
      Ensure = "Absent"
      Name = "Default Web Site"
      State = "Stopped"
      PhysicalPath = "c:\inetput\wwwroot"
    }

    MySite sWebsite
    {
      MachineName = $MachineName
      SourcePath = $SourcePath
    }
  }
}
