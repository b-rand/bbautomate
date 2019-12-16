<#
    .Synopsis
    PSCustomObject To HashTable Converter (ViceVersa)
#>
function Convert-HashTablePSCustomObject {
    <#
        .Synopsis
        converts HashTable object to PSCustomObject or reverse

        .Example
        C:\PS> Convert-HashTablePSCustomObject -InputObject $HashTable

        .Example
        C:\PS> Convert-HashTablePSCustomObject -InputObject $PSCustomObject
        
        .Parameter InputObject
        Accepts objects that are either type [HashTable] or [PSCustomObject]
    #>
    param(
        [CmdletBinding()]

        [Parameter(Mandatory = $true)]
        #[object]
        [object]
        $InputObject
    )
    #Determine if InputObject is of the correct type
    try {
        #Determine if InputObject is of the correct type
        $type = $InputObject.GetType().Name
        if ($type -ne 'PSCustomObject' -and $type -ne 'Hashtable') {
            throw "Invalid Object Type"
        }
        #Convert PSCustomObject to Hashtable
        if ($type -eq 'PSCustomObject') {
            $hashtable = @{ }
            $InputObject.psobject.properties | ForEach-Object { $hashtable[$_.Name] = $_.Value }
            return $hashtable
        }
        #Convert Hashtable to PSCustomObject
        if ($type -eq 'Hashtable') {
            $psCustomObject = New-Object PSCustomObject
            foreach($key in $InputObject.keys){                
                $psCustomObject | Add-Member -Name $key -MemberType NoteProperty -Value $InputObject[$key]
            }
            return $psCustomObject
        }
    }
    catch {
        if ($_.Exception.Message -eq "Invalid Object Type") {
            Write-Error $_.Exception.Message -Category InvalidType -CategoryReason "Object Must Be Of The Type Hashtable or Type PSCustomObject"            
        }
        else ($_.Exception.Message -ne "Invalid Object Type"){
            Write-Error $_.Exception
        }
    }
}
Export-ModuleMember -Function Convert-HashTablePSCustomObject
