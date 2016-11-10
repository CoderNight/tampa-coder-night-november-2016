<#
	PowerShell console profile
	NOTES: contains five types of things: aliases, functions, psdrives, variables, and commands
	Created 2015-08-10 by Charles Oppermann <chuckop@live.com>
#>

#Functions
Function Test-IsAdmin
{
	<#
	.Synopsis
		Tests if the user is an administrator
	.Description
		Returns true if a user is an administrator, false if the user is not an administrator       
	.Example
		Test-IsAdmin
	#>
	$identity	= [Security.Principal.WindowsIdentity]::GetCurrent()
	$principal	= New-Object Security.Principal.WindowsPrincipal $identity
	$principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# Create a version of help that always gets everything
Function manpage { Get-Help -Full -Name "$args" | more }

# Be Out Spoken
$voice = New-Object -ComObject SAPI.SPVoice
#$voice.Rate = -3
Function Invoke-Speech
{
	<#
	.Synopsis
		Speak a string with speech synthisis 
	.Description
		Accepts a string which is sent to the Windows Speech API for speaking using default settings
	.Example
		Invoke-Speech "Hello world!"
	#>

	param([Parameter(ValueFromPipeline=$true)][string] $say )

	Process
	{
		$voice.Speak($say) | out-null;
	}
}

# Change Window Title
Function Set-WindowTitle
{
	param ( [string] $newtitle )

	Process
	{
		$host.ui.RawUI.WindowTitle = $newtitle + " " + $host.ui.RawUI.WindowTitle;
	}
}

#Variables

#PS_Drives

#Aliases
Set-Alias -Name "man"		-Value "manpage"		-Option AllScope -Description "Personal Script Alias"
New-Alias -Name "Out-Voice"	-Value "Invoke-Speech"	-Option AllScope -Description "Personal Script Alias"

#Commands

# Are we running with admin priv
if (Test-IsAdmin)
{
	Write-Warning "Test-IsAdmin returned True"
	Set-WindowTitle "Administrator"
#	$host.UI.RawUI.BackgroundColor = "DarkRed"
#	$host.UI.RawUI.ForegroundColor = "DarkYellow"
} else
{
	Write-Information "Test-IsAdmin returned False"
	Set-WindowTitle "Normal User"
#	$host.UI.RawUI.BackgroundColor = "DarkBlue"
}

# Set the console colors the way I like them
#Write-Host -ForegroundColor White -BackgroundColor DarkBlue -NoNewline

<#
## I love my random quotes ... 
Set-Variable QuoteDir (Resolve-Path (Join-Path (Split-Path $ProfileDir -parent) "@stuff\Quotes")) -Scope Global -Option AllScope -Description "Personal PATH Variable"

Set-Alias   RandomLine   Select-RandomLine         -Option AllScope -Description "Personal Script Alias"
Set-Alias   Get-Quote    Select-RandomLine         -Option AllScope -Description "Personal Script Alias"
Set-Alias   gq           Select-RandomLine         -Option AllScope -Description "Personal Script Alias"

#>





