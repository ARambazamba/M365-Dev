if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) {
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

#Variables
$WebAppURL = "http://sp2019"
$SiteURL = "/"

$PackagePath = ".\EventReceiversClassic\Published\"
$PackageName = "EventReceivers.wsp"
$FeatureID = [Guid]("4d164d13-c1dc-4894-885c-87981fcca573")
$SleepTime = 10

#Constants
$PackageFullPath = $PackagePath + $PackageName
$ActivateURL = $WebAppURL + $SiteURL

Add-SPSolution $PackageFullPath
Install-SPSolution -Identity $PackageName -GACDeployment

## Wait until deployment is done 
$Solution = Get-SPSolution -identity $PackageName
$lastStatus = ""

## loop whilst there is a Job attached to the Solution 
while ($Solution.JobExists -eq $True) { 
    $currentStatus = $Solution.JobStatus 
    if ($currentStatus -ne $lastStatus) { 
        Write-Host "$currentStatus…" -foreground green -nonewline 
        $lastStatus = $currentStatus 
    } 
    Write-Host "." -foreground green -nonewline 
    Start-Sleep $SleepTime 
} 

# Enable the feature
Enable-SPFeature $FeatureID –URL $ActivateURL

## completed 
Write-Host $Solution.LastOperationDetails -foreground green