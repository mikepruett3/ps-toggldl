function Connect-Toggl {
    <#
    .SYNOPSIS
        This function creates a Header variable for use with Rest Calls to Toggl API
    .DESCRIPTION
        This function creates a variable, used with other functions and cmdlets
    .PARAMETER ApiToken
        Specify the Toggl ApiToken for your account
    .PARAMETER Workspace
        Specify the Toggl Workspace ID for your account
    .OUTPUTS
        Creats a global variable $Global:Header that is available for use in other cmdlets. It contains the JSON auth session token.
    .EXAMPLE
        > Connect-Toggl -Apitoken 12345678901112 -Workspace 111111
        Initiates a new connection to the Toggl API
    #>

    [CmdletBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="Medium" 
    )]

    param (
        [string]$ApiToken,
        [string]$Workspace
    )

    begin {
        # Checking for Toggl ApiKey in Environment Variable
        try {
            if (Test-Path -IsValid $Env:Toggl_Api) {
                $ApiToken = $Env:Toggl_Api
            }
        }
        catch {
            Write-Host -ForeGround Red "Toggl API Key not found in Environment Variable!!!"
            Write-Host -ForeGround Red "Usage: Connect-Toggl -Apitoken <token> -Workspace <workspace-id>"
            Write-Host -ForeGround Red "or Create a Environment Variable called Toggl_Api, and include your Api Key."
            Break
        }

        # Checking for Toggl Workspace in Environment Variable
        try {
            if (Test-Path -IsValid $Env:Toggl_Workspace) {
                $Global:Workspace = $Env:Toggl_Workspace
            }
        }
        catch {
            Write-Host -ForeGround Red "Toggl Workspace ID not found in Environment Variable!!!"
            Write-Host -ForeGround Red "Usage: Connect-Toggl -Apitoken <token> -Workspace <workspace-id>"
            Write-Host -ForeGround Red "or Create a Environment Variable called Toggl_Workspace, and include your Workspace ID."
            Break
        }

        # Setting Global variables used for connecting to the Toggl V8 REST API
        $Global:RootURI = 'https://www.toggl.com/api/v8'
        $Global:contentType = "application/json"

        # Regular variables
        $ApiPass = "api_token"
        $userAgent = "ps-toggldl"
    }

    process {
        # Build out Headers
        $Passphrase = "$($ApiToken):$($ApiPass)"
        $Bytes = [System.Text.Encoding]::ASCII.GetBytes($Passphrase)
        $Base64 = [System.Convert]::ToBase64String($Bytes)
        $basicAuthValue = "Basic $Base64"

        # Creating Global Headers Variable
        $Global:Headers = @{
            Authorization = $basicAuthValue
            user_agent = $userAgent
            workspace_id = $Global:Workspace
        }
    }

    end {
        $ApiPass = $Null
        $Passphrase = $Null
        $Bytes = $Null
        $Base64 = $Null
        $basicAuthValue = $Null
    }
}

#http://powerbits.com.au/201573use-powershell-to-access-the-toggl-api/