# Restore-GPO can not import GPO's from a different forest so this seeks todo that.

$GPOGUIDs = Get-ChildItem -Path C:\Users\admin01\Downloads\GPOs\GPOs
$arrayGPOExclusion = ("Default Domain Controllers Policy" , "Default Domain Policy")
ForEach ($GPOGUID in $GPOGUIDs){
    [xml]$XmlDocument=Get-Content -Path  C:\Users\admin01\Downloads\GPOs\GPOs\$GPOGUID\gpreport.xml
    if ($XmlDocument.gpo.Name -notin $arrayGPOExclusion){
        $XmlDocument.gpo.Name
        #Import-GPO -BackupGpoName $GPOGUID.Name -TargetGUID $GPOGUID.Name -CreateIfNeeded -Path C:\Users\admin01\Downloads\GPOs\GPOs -WhatIf
        Import-GPO -BackupId $GPOGUID.Name -TargetName $XmlDocument.gpo.Name -CreateIfNeeded -Path C:\Users\admin01\Downloads\GPOs\GPOs
        }
    elseif ($XmlDocument.gpo.Name -in $arrayGPOExclusion){ # careful with arrays and conditional logic; i.e. -in vs eq,contains
        "---Skipping: " + $XmlDocument.gpo.Name
        }
    else{
        Write-Host "Exception has occured"
        }
}
# Report the new GPO List
Write-Host `n`n"__________________"`n"New list of GPOs:"`n"__________________"
Get-GPO -all | Select-Object -Property DisplayName | Format-Table
