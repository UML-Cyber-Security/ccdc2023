##################################################################################
#
#
#  Script name: Add-SPUserField.ps1
#
#  Author:      	niklas.goude@zipper.se
#  Homepage:    	www.powershell.nu
#  Company:		www.zipper.se
#
##################################################################################

param([string]$url, [string]$List, [string]$Name, [string]$Description, [switch]$Required, [switch]$help)

[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")

function GetHelp() {


$HelpText = @"

DESCRIPTION:
NAME: Add-SPUserField
Adds a User Field to a SP List

PARAMETERS: 
-url		Url to SharePoint Site
-List		List Name
-Name		Name of the Field
-Description	Field Description
-Required	Boolean Value, If True, Field will be Required

SYNTAX:

Add-SPUserField -url http://moss -List Users -Name User -Description "User"

Adds the User Field to The Users List

Add-SPUserField -help

Displays the help topic for the script

"@
$HelpText

}

function Get-SPSite([string]$url) {

	New-Object Microsoft.SharePoint.SPSite($url)
}

function Get-SPWeb([string]$url) {

	$SPSite = Get-SPSite $url
	return $SPSite.OpenWeb()
	$SPSite.Dispose()
}

function Add-SPUserField([string]$url, [string]$List, [string]$Name, [string]$Description, [switch]$Required) {

	$OpenWeb = Get-SPWeb $url
	$OpenList = $OpenWeb.Lists[$List]
	[void]$OpenList.Fields.Add($Name, "User", $Required)
	$OpenList.Fields[$Name].Description = $Description

	$OpenList.Fields[$Name].Update()

	$OpenWeb.Dispose()
}

if($help) { GetHelp; Continue }

if($url -AND $List -AND $Name -AND $Description) {
	if($Required) {
		Add-SPUserField -url $url -List $List -Name $Name -Description $Description -Required
	} else {
		Add-SPUserField -url $url -List $List -Name $Name -Description $Description
	}
}