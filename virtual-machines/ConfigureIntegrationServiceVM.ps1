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

# Configures a Data Factory Integration Service VM using the specified parameters
[CmdletBinding()]
param(
    # The locale to use in the format en-US
    [Parameter(Position=0,Mandatory=$true)]
    [string]
    $Language,
    # The location of this server, refer to the Geographical location identifier (decimal) in
    # https://docs.microsoft.com/en-au/windows/desktop/Intl/table-of-geographical-locations
    # for values
    [Parameter(Position=1,Mandatory=$true)]
    [int]
    $Location,
    # The key from the Data Factory Integration runtime to be used to register the integration service VM
    [Parameter(Position=2,Mandatory=$true)]
    [string]
    $AuthKey
)

New-Item C:\Temp -ItemType Directory -ErrorAction SilentlyContinue

Invoke-WebRequest https://raw.githubusercontent.com/dozer75/bicep/master/virtual-machines/SetLangAndLocation.ps1 -OutFile C:\Temp\SetLangAndLocation.ps1

Invoke-WebRequest https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.compute/vms-with-selfhost-integration-runtime/gatewayInstall.ps1 -OutFile C:\Temp\gatewayInstall.ps1

& C:\Temp\SetLangAndLocation.ps1 -lng $Language -location $Location

& C:\Temp\gatewayInstall.ps1 -gatewayKey $AuthKey