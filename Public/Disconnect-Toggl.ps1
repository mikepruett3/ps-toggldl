function Disconnect-Toggl {
    <#
    .SYNOPSIS
        This cmdlet ends the session created prior with cmdlet Connect-Toggl.
    .DESCRIPTION
        This cmdlet closes the session created with Connect-Toggl and sets the global variable $Global:Headers to NULL
    .EXAMPLE
        > Disconnect-Toggl
        Disconnect the active session.
    #>

    [CmdletBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="Medium"
    )]

    param ()

    begin {}

    process {
        # Cleanup Globally Defined Variables
        Clear-Variable -Name RootURI -Scope Global -ErrorAction SilentlyContinue
        Clear-Variable -Name Headers -Scope Global -ErrorAction SilentlyContinue
        Clear-Variable -Name Workspace -Scope Global -ErrorAction SilentlyContinue
        Clear-Variable -Name contentType -Scope Global -ErrorAction SilentlyContinue
    }

    end {}
}