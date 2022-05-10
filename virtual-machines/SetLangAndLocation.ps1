# MIT License
# Copyright 2022 Axiell Media AB

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all copies or substantial portions
# of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
# TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

# This script is copied from https://github.com/wvanbesien/regionalSettings and modified
# by setting $location as a parameter.

param(
    [string]$lng,
    [int]$location
)

if (-not [System.Environment]::Is64BitProcess)
{
    Write-Host "Not 64-bit process. Restart in 64-bit environment"

     # start new PowerShell as x64 bit process, wait for it and gather exit code and standard error output
    $sysNativePowerShell = "$($PSHOME.ToLower().Replace("syswow64", "sysnative"))\powershell.exe"

    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $sysNativePowerShell
    $pinfo.Arguments = "-ex bypass -file `"$PSCommandPath`""
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.CreateNoWindow = $true
    $pinfo.UseShellExecute = $false
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null

    $exitCode = $p.ExitCode

    $stderr = $p.StandardError.ReadToEnd()

    if ($stderr) { Write-Error -Message $stderr }

    exit $exitCode
}

Start-Transcript -Path "C:\Windows\Temp\SetLanguage.log" | Out-Null

#$lng = "en-AU"
$outFile = "C:\Windows\Temp\Lng.xml"
#https://docs.microsoft.com/en-au/windows/desktop/Intl/table-of-geographical-locations
#$location = 12

Write-Host "Set language: $lng"
Write-Host "Language file: $outFile"

Set-WinSystemLocale $lng

Write-Host "Set location: $location"
Set-WinHomeLocation $location

$lngList = New-WinUserLanguageList $lng
# Add any additional keyboards
#$lngList.Add("en-US")
Set-WinUserLanguageList $lngList -Force
Set-WinUILanguageOverride $lng

$xmlStr = @"
<gs:GlobalizationServices xmlns:gs="urn:longhornGlobalizationUnattend">
    <!--User List-->
    <gs:UserList>
        <gs:User UserID="Current" CopySettingsToSystemAcct="true" CopySettingsToDefaultUserAcct="true" /> 
    </gs:UserList>

    <!--User Locale-->
    <gs:UserLocale> 
        <gs:Locale Name="$($lng)" SetAsCurrent="true" ResetAllSettings="true"/>
    </gs:UserLocale>

    <gs:MUILanguagePreferences>
        <gs:MUILanguage Value="$($lng)"/>
        <!--<gs:MUIFallback Value="en-US"/>-->
    </gs:MUILanguagePreferences>

</gs:GlobalizationServices>
"@

$xmlStr | Out-File $outFile -Force -Encoding ascii

# Use this copy settings to system and default user 
Write-Host "Copy language settings with control.exe"
control.exe "intl.cpl,,/f:""$($outFile)"""

Stop-Transcript | Out-Null