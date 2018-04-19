function Get-Clients {
    <#
    .SYNOPSIS
        This function retrieves a list of Clients from Toggl
    .DESCRIPTION
        This function creates a new Object of Clients from Toggl
    .OUTPUTS
        Creats a variable $Result that is available for use in other cmdlets.
    .EXAMPLE
        > Get-Clients
    #>

    [CmdletBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="Medium" 
    )]

    param ()

    begin {
        #Creating new Array for result
        $Result = New-Object System.Collections.ArrayList
    }

    process {
        Try {
            # Querying Toggle API for latest Time Entries
            $Query = Invoke-RestMethod -Method Get -Uri ($RootURI + '/workspaces/' + $Workspace + "/clients") -Headers $Headers -ContentType $contentType -ErrorAction Stop
            Write-Verbose "Project List Retrieved!"
            # Building new Object of results from Time Entries Query
            foreach ($entry in $Query) {
                $Temp = New-Object System.Object
                $Temp | Add-Member -MemberType NoteProperty -Name "ClientID" -Value $entry.id
                $Temp | Add-Member -MemberType NoteProperty -Name "Name" -Value $entry.name
                $Result.Add($Temp) | Out-Null
            }
        }
        Catch {  
            $response = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($response)
            $reader.BaseStream.Position = 0
            $reader.DiscardBufferedData()
            $responseBody = $reader.ReadToEnd();
            Write-Host -ForegroundColor Red $_ "---->" $responseBody
            Break
        }
        $Result
    }

    end {
        $Query = $Null
        $Temp = $Null
        $response = $Null
        $reader = $Null
        $responseBody = $Null
    }
}
