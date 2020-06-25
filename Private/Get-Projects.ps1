function Get-Projects {
    <#
    .SYNOPSIS
        This function retrieves a list of Projects from Toggl
    .DESCRIPTION
        This function creates a new Object of Projects from Toggl
    .OUTPUTS
        Creats a variable $Result that is available for use in other cmdlets.
    .EXAMPLE
        > Get-Projects
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
        # Querying Toggle API for latest Time Entries
        Write-Verbose "Project List Retrieved!"
        Try {
            $Query = Invoke-RestMethod -Method Get -Uri ($RootURI + '/workspaces/' + $Workspace + "/projects") -Headers $Headers -ContentType $contentType -ErrorAction Stop
        }
        Catch {  
            $response = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($response)
            $reader.BaseStream.Position = 0
            $reader.DiscardBufferedData()
            $responseBody = $reader.ReadToEnd();
            Write-Error $_ "---->" $responseBody
            Break
        }
        # Building new Object of results from Time Entries Query
        foreach ($entry in $Query) {
            $Temp = New-Object System.Object
            $Temp | Add-Member -MemberType NoteProperty -Name "ProjectID" -Value $entry.id
            $Temp | Add-Member -MemberType NoteProperty -Name "Client" -Value (Get-Clients | Where-Object {$_.ClientID -eq $entry.cid} | Select-Object -ExpandProperty Name)
            $Temp | Add-Member -MemberType NoteProperty -Name "Name" -Value $entry.name
            $Temp | Add-Member -MemberType NoteProperty -Name "Active" -Value $entry.active
            $Temp | Add-Member -MemberType NoteProperty -Name "Private" -Value $entry.is_private
            $Result.Add($Temp) | Out-Null
        }
        Return $Result
    }

    end {
        $Query = $Null
        $Temp = $Null
        $response = $Null
        $reader = $Null
        $responseBody = $Null
    }
}
