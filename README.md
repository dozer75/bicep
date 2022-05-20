# Introduction

This repo contains various scripts that I use with Biceps in various circumstances.

## Virtual machine scripts

### ConfigureIntegratonServiceVM.ps1

This is a PowerShell script that initializes a Virtual Machine to be a Self-hosted Integration Runtime for Azure Data Factory.

It:
- Sets the language to the specified ```Language```
  - Uses [Language Culture Name](https://docs.microsoft.com/en-us/previous-versions/commerce-server/ee797784(v=cs.20)?redirectedfrom=MSDN) as valid values
- Sets the location to the specified ```location```
  - See [Geographical location identifier (decimal)](https://docs.microsoft.com/en-au/windows/win32/intl/table-of-geographical-locations) for valid values
- Installs and configures the self-hosted integration runtime with the specified ```AuthKey```
  - Get the ```AuthKey``` from your DataFactory Self-Hosted integration runtime.
- Installs Microsoft OpenJDK 11

### SetLangAndLocation.ps1

This is a PowerShell script that sets the language and location of a virtual machine to the specified values

It:
- Sets the language to the specified ```lang```
  - Uses [Language Culture Name](https://docs.microsoft.com/en-us/previous-versions/commerce-server/ee797784(v=cs.20)?redirectedfrom=MSDN) as valid values
- Sets the location to the specified ```location```
  - See [Geographical location identifier (decimal)](https://docs.microsoft.com/en-au/windows/win32/intl/table-of-geographical-locations) for valid values

DISCLAIMER: This script is copied from the https://github.com/wvanbesien/regionalSettings and adjusted by adding location as a parameter, otherwise it is
the same script.