Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010
. $env:ExchangeInstallPath\bin\RemoteExchange.ps1
Connect-ExchangeServer -auto

Get-Mailbox | ft PrimarySMTPAddress > C:\scripts\mailusers_out\mailscript_output\recipients_raw
Get-DistributionGroup | ft PrimarySMTPAddress >> C:\scripts\mailusers_out\mailscript_output\recipients_raw
