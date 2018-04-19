function Get-TimeEntries {
    <#
    .SYNOPSIS
        This function retrieves the latest Time Entries from Toggl
    .DESCRIPTION
        This function creates a new Object of Time Entries from Toggl
    .OUTPUTS
        Creats a variable $Result that is available for use in other cmdlets.
    .PARAMETER NumberDays
        An Negative-Integer value for the number of days to retrieve from Toggl's API. Must be a Negative whole,
        number. By default, only retrieve data from the previous (1) day

        > Get-TimeEntries -NumberDays -5
    .EXAMPLE
        > Get-TimeEntries
    #>

    [CmdletBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="Medium" 
    )]

    param (
        [ValidateScript({$_ -le 0})]
        [Int]$NumberDays = "-1"
    )

    begin {
        # Creating start_date and end_date variables
        $start_date = ((Get-Date).AddDays($NumberDays) | Get-Date -Format "yyyy-MM-ddT00\%3A00\%3A00zzzz")
        $end_date = (Get-Date -Format "yyyy-MM-ddTHH\%3Amm\%3Asszzzz")
        #Creating new Array for result
        $Result = New-Object System.Collections.ArrayList
    }

    process {
        Try {
            # Querying Toggle API for latest Time Entries
            $Query = Invoke-RestMethod -Method Get -Uri ($RootURI + '/time_entries?start_date=' + $start_date + '&end_date=' + $end_date ) -Headers $Headers -ContentType $contentType -ErrorAction Stop
            Write-Verbose "Recent Time Entries Retrieved!"
            # Building new Object of results from Time Entries Query
            foreach ($entry in $Query) {
                $Temp = New-Object System.Object
                $Temp | Add-Member -MemberType NoteProperty -Name "ID" -Value $entry.id
                $Temp | Add-Member -MemberType NoteProperty -Name "ProjectID" -Value $entry.pid
                $Temp | Add-Member -MemberType NoteProperty -Name "Description" -Value $entry.description
                $Temp | Add-Member -MemberType NoteProperty -Name "StartTime" -Value $entry.start
                $Temp | Add-Member -MemberType NoteProperty -Name "StopTime" -Value $entry.stop
                $Temp | Add-Member -MemberType NoteProperty -Name "Duration" -Value $entry.duration
                $Temp | Add-Member -MemberType NoteProperty -Name "Tags" -Value $entry.tags
                $Temp | Add-Member -MemberType NoteProperty -Name "Billable" -Value $entry.billable
                $Temp | Add-Member -MemberType NoteProperty -Name "EnteredDate" -Value $entry.at
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
        $NumberDays = $Null
        $start_date = $Null
        $end_date = $Null
    }
}
