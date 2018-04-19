# PowerShell Toggl.com Download Tools (ps-toggldl)

Module created to allow for easy extraction of Time Data from Toggl's API, via PowerShell Invoke-WebRequest cmdlets. For use with other cmdlets and scripts.

## Installation

Clone the repository into your **$Home\Documents\WindowsPowerShell\Modules** folder (create the Modules folder if you dont have one already)

```powershell
cd $Home\Documents\WindowsPowerShell\Modules\
git clone git@github.com:mikepruett3/ps-toggldl.git
```

Then you can import the custom module into your running shell...

```powershell
Import-Module ps-toggldl
```

## Usage

### Connect to Toggl's API

Running this function will create a Global Variable which is used with subsequent functions of this module.

This function is looking for two User-Defined Environment Variables:

| Variable | Description|
|:---|:---|
| Toggl_Api | The [API key](https://toggl.com/app/profile) provided by Toggl.com|
| Toggl_Workspace | The [Workspace ID](https://toggl.com/app/workspaces) provided by Toggl.com |

Once you have these Environment Variables, run the following:

```powershell
Connect-Toggl
```

If no User-Defined Environment Variables are defined, the function is expecting these as Parameters:

```powershell
Connect-Toggl -Apitoken <Toggl-API-Token> -Workspace <Workspace-Token>
```


### Retrieve Time Entry Data from API

Retrieving Time Entry Data from Toggl's API can be performed by the following:

```powershell
Get-Summary
```

Which will return a PowerShell Object of all of the data from the last 24 hours (Earliest point at midnight). You can use the **-Detail** method to retrieve full Time Entry data, instead of a summary

```powershell
Get-Summary -Detail
```

If you want to return data from an older point, you can provide a negative integer in the **-Days** method.

```powershell
Get-Summary -Days -5
```

You can also use the following to retrieve the data, and place it in a CSV file

```powershell
Get-Summary | Export-Csv -Path \path\to\file\<filename.csv> -NoTypeInformation
```

Important to use the **-NoTypeInformation**, to strip the type information from the CSV file
