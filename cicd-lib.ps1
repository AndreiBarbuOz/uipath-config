#requires -Module UiPath.PowerShell

$ErrorActionPreference = "Stop"

function Get-AssetChanges {
    <#
    .SYNOPSIS
        Get asset change set between desired state and current state.
    .DESCRIPTION
        The Get-AssetChanges performs a diff between the desired and current state of the Orchestrator
    .PARAMETER DesiredAssetState
        Desired process configuration state
    .PARAMETER Token
        The token to be used to aquire the state of the assets as they are currently stored on the Orchestrator
    #>
    [CmdletBinding()]
    param(
        [Parameter()]$DesiredAssetState,

        [Parameter()]$Token
    )
    process {
        $currentAssetState = Get-UiPathAsset -AuthToken $Token
        $create = @()
        $modify = @()
        foreach($asset in $DesiredAssetState){
            $existing = $currentAssetState | Where-Object {$_.Name -eq $asset.Name}
            if($null -ne $existing){
                if($existing.Value -ne $asset.Value -or $existing.ValueType -ne $asset.ValueType){
                    $modify += New-Object PSObject -Property @{
                        "Name"=$asset.Name
                        "OldValue"=$existing.Value
                        "NewValue"=$asset.Value
                        "OldType"=$existing.ValueType
                        "NewType"=$asset.ValueType
                    }
                }
            } else {
                $create += New-Object PSObject -Property @{
                    "Name"=$asset.Name
                    "NewValue"=$asset.Value
                    "NewType"=$asset.ValueType
                }
            }
        }
        return @{
            "create"=$create
            "modify"=$modify
        }
    }
}

function Set-AssetChanges {
    <#
    .SYNOPSIS
        Apply change set to the Orchestrator.
    .DESCRIPTION
        The Get-AssetChanges performs a diff between the desired and current state of the Orchestrator
    .PARAMETER DesiredAssetState
        Desired process configuration state
    .PARAMETER Token
        Orchestrator authentication token
    #>
    [CmdletBinding()]
    param(
        [Parameter()]$DesiredAssetState,

        [Parameter()]$Token
    )
    process {
        foreach($asset in $DesiredAssetState.create){
            switch($asset.NewType){
                "Text" { Add-UiPathAsset -AuthToken $Token -Name $asset.Name -TextValue $asset.NewValue}
                "Integer" {Add-UiPathAsset -AuthToken $Token -Name $asset.Name -IntValue $asset.NewValue}
                "Boolean" {
                    $boolVal = [System.Convert]::ToBoolean($asset.NewValue)
                    Add-UiPathAsset -AuthToken $Token -Name $asset.Name -BoolValue $boolVal
                }
            }
        }
        foreach($asset in $DesiredAssetState.modify){
            $oldAsset = Get-UiPathAsset -AuthToken $Token -Name $asset.Name
            Remove-UiPathAsset -AuthToken $Token -Asset $oldAsset

            switch($asset.NewType){
                "Text" { Add-UiPathAsset -AuthToken $Token -Name $asset.Name -TextValue $asset.NewValue}
                "Integer" {Add-UiPathAsset -AuthToken $Token -Name $asset.Name -IntValue $asset.NewValue}
                "Boolean" {
                    $boolVal = [System.Convert]::ToBoolean($asset.NewValue)
                    Add-UiPathAsset -AuthToken $Token -Name $asset.Name -BoolValue $boolVal
                }
            }
        }
    }
}

