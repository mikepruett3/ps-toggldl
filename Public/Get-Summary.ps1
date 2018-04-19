function Get-Summary {
    <#
    .SYNOPSIS
        This function retrieves a Summary of all Time Entry Data from Toggl
    .DESCRIPTION
        This function creates a new Object of all Time Entry Data from Toggl
    .OUTPUTS
        Creats a variable $Result that is available for use in other cmdlets.
    .PARAMETER Detail
        Show detailed Time Entry information (Start, Stop, and Duration)

        > Get-Summary -Detail
    .PARAMETER Days
        An Negative-Integer value for the number of days to retrieve from Toggl's API. Must be a Negative whole,
        number. By default, only retrieve data from the previous (1) day

        > Get-Summary -Days -5
    .EXAMPLE
        > Get-Summary
    #>

    [CmdletBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="Medium"
    )]

    param (
        [switch]$Detail = $FALSE,
        [Int]$Days
    )

    begin {
        #Creating new Array for result
        $Result = New-Object System.Collections.ArrayList
    }

    process {
        Try {
            # Querying Toggle API for latest Time Entries
            $Query = Get-TimeEntries -NumberDays $Days
            $Projects = Get-Projects
            Write-Verbose "Retrieved!"
            # Building new Object of results from Time Entries Query
            foreach ($entry in $Query) {
                $Temp = New-Object System.Object
                $Temp | Add-Member -MemberType NoteProperty -Name "ID" -Value $entry.ID
                $Temp | Add-Member -MemberType NoteProperty -Name "Description" -Value $entry.Description
                $Temp | Add-Member -MemberType NoteProperty -Name "Client" -Value ($Projects | Where-Object {$_.ProjectID -eq $entry.ProjectID}| Select-Object -ExpandProperty Client | Out-String).replace("`n","")
                $Temp | Add-Member -MemberType NoteProperty -Name "Project" -Value ($Projects | Where-Object {$_.ProjectID -eq $entry.ProjectID} | Select-Object -ExpandProperty Name | Out-String).replace("`n","")
                # Only inlude this information if the $Detail parameter is present
                if ($Detail) {
                    $Temp | Add-Member -MemberType NoteProperty -Name "StartTime" -Value $entry.StartTime
                    $Temp | Add-Member -MemberType NoteProperty -Name "StopTime" -Value $entry.StopTime
                    $Temp | Add-Member -MemberType NoteProperty -Name "Duration" -Value $entry.Duration
                }
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
        $Days = $Null
        $Detail = $Null
    }
}
