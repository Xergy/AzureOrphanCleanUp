$subscriptions = get-azurermsubscription | where{$_.Name -like '*Internal*'}

$output = @()
$OrphanNics = @()
$RemoveOrphanNic = $false

foreach($sub in $subscriptions)
{ 
    Write-Host "Checking Subscription $($sub.Name) $($sub.ID)"
    Select-AzureRmSubscription -SubscriptionName $sub | out-Null
 
    #$RGs = Get-AzureRmResourceGroup | where {$_.Tags -like 'IAM' -or $_.Tags -like 'iam'}
    $RGs = Get-AzureRmResourceGroup

    Write-Host "Subscription RGs:"
    $RGs 

    foreach ($RG in $RGs)
    {
        Write-Host "Checking RG $($Rg.ResourceGroupName)"
        $ResourceGroup = $RG.ResourceGroupName
        $az_networkinterfaces = Get-AzureRmNetworkInterface -ResourceGroupName $ResourceGroup |  Where-Object {$_.VirtualMachine -eq $null}
                
        Write-host "Looking for Oprhan Nics..." 
        foreach ($NIC in $az_networkinterfaces)
        {
            Write-Host "$($NIC.Name)"
            $OrphanNics += $Nic            
        }
    } 
}  

Write-Host "All Orphan Nics:"
$OrphanNics | Ft -Property Name,VirtualMachine,IpConfigurations

# $OrphanNics | Remove-AzureRmNetworkInterface

