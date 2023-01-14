﻿## Active Directory: PowerShell Script Solution to Monitor / Report on AD Group Membership Changes ##

<#
.SYNOPSIS
	This script is monitoring group(s) in Active Directory and send an email when someone is changing the membership.

.RESOURCES
	http://www.lazywinadmin.com/2013/11/update-powershell-monitor-and-report.html
	https://gallery.technet.microsoft.com/Monitor-Active-Directory-4c4e04c7
	
.DESCRIPTION
	This script is monitoring group(s) in Active Directory and send an email when someone is changing the membership.
	It will also report the Change History made for this/those group(s).

.PARAMETER Group
	Specify the group(s) to query in Active Directory.
	You can also specify the 'DN','GUID','SID' or the 'Name' of your group(s).
	Using 'Domain\Name' will also work.

.PARAMETER Group
	Specify the group(s) to query in Active Directory.
	You can also specify the 'DN','GUID','SID' or the 'Name' of your group(s).
	Using 'Domain\Name' will also work.

.PARAMETER SearchRoot
    Specify the DN, GUID or canonical name of the domain or container to search. By default, the script searches the entire sub-tree of which SearchRoot is the topmost object (sub-tree search). This default behavior can be altered by using the SearchScope parameter.
    
.PARAMETER SearchScope
    Specify one of these parameter values
        'Base'      Limits the search to the base (SearchRoot) object.
                    The result contains a maximum of one object.
        'OneLevel'  Searches the immediate child objects of the base (SearchRoot)
                    object, excluding the base object.
        'Subtree'   Searches the whole sub-tree, including the base (SearchRoot)
                    object and all its child objects.

.PARAMETER GroupScope
    Specify the group scope of groups you want to find. Acceptable values are: 
        'Global'; 
        'Universal'; 
        'DomainLocal'.

.PARAMETER GroupType
    Specify the group type of groups you want to find. Acceptable values are: 
        'Security';
        'Distribution'.

.PARAMETER File
    Specify the File where the Group are listed. DN, SID, GUID, or Domain\Name of the group are accepted.

.PARAMETER EmailServer
	Specify the Email Server IPAddress/FQDN.

.PARAMETER EmailTo
	Specify the Email Address(es) of the Destination. Example: fxcat@fx.lab

.PARAMETER EmailFrom
	Specify the Email Address of the Sender. Example: Reporting@fx.lab

.EXAMPLE
	.\TOOL-Monitor-AD_Group.ps1 -Group "FXGroup" -EmailFrom "From@Company.com" -EmailTo "To@Company.com" -EmailServer "mail.company.com"

	This will run the script against the group FXGROUP and send an email to To@Company.com using the address From@Company.com and the server mail.company.com.

.EXAMPLE
	.\TOOL-Monitor-AD_Group.ps1 -Group "FXGroup","FXGroup2","FXGroup3" -EmailFrom "From@Company.com" -Emailto "To@Company.com" -EmailServer "mail.company.com"

	This will run the script against the groups FXGROUP,FXGROUP2 and FXGROUP3  and send an email to To@Company.com using the address From@Company.com and the Server mail.company.com.

.EXAMPLE
	.\TOOL-Monitor-AD_Group.ps1 -Group "FXGroup" -EmailFrom "From@Company.com" -Emailto "To@Company.com" -EmailServer "mail.company.com" -Verbose

	This will run the script against the group FXGROUP and send an email to To@Company.com using the address From@Company.com and the server mail.company.com. Additionally the switch Verbose is activated to show the activities of the script.

.EXAMPLE
	.\TOOL-Monitor-AD_Group.ps1 -Group "FXGroup" -EmailFrom "From@Company.com" -Emailto "Auditor@Company.com","Auditor2@Company.com" -EmailServer "mail.company.com" -Verbose

	This will run the script against the group FXGROUP and send an email to Auditor@Company.com and Auditor2@Company.com using the address From@Company.com and the server mail.company.com. Additionally the switch Verbose is activated to show the activities of the script.

.EXAMPLE
	.\TOOL-Monitor-AD_Group.ps1 -SearchRoot 'FX.LAB/TEST/Groups' -Emailfrom Reporting@fx.lab -Emailto "Catfx@fx.lab" -EmailServer 192.168.1.10 -Verbose

	This will run the script against all the groups present in the CanonicalName 'FX.LAB/TEST/Groups' and send an email to catfx@fx.lab using the address Reporting@fx.lab and the server 192.168.1.10. Additionally the switch Verbose is activated to show the activities of the script.

.EXAMPLE
	.\TOOL-Monitor-AD_Group.ps1 -file .\groupslist.txt -Emailfrom Reporting@fx.lab -Emailto "Catfx@fx.lab" -EmailServer 192.168.1.10 -Verbose

	This will run the script against all the groups present in the file groupslists.txt and send an email to catfx@fx.lab using the address Reporting@fx.lab and the server 192.168.1.10. Additionally the switch Verbose is activated to show the activities of the script.

.INPUTS
	System.String

.OUTPUTS
	Email Report
.NOTES
	NAME:	TOOL-Monitor-AD_Group.ps1
	AUTHOR:	Francois-Xavier CAT 
	DATE:	2012/02/01
	EMAIL:	info@lazywinadmin.com

	REQUIREMENTS:
		-Read Permission in Active Directory on the monitored groups
		-Quest Active Directory PowerShell Snapin
		-A Scheduled Task (in order to check every X seconds/minutes/hours)

	VERSION HISTORY:
	1.0 2012.02.01
		Initial Version

	1.1 2012.03.13
		CHANGE to monitor both Domain Admins and Enterprise Admins

	1.2 2013.09.23
		FIX issue when specifying group with domain 'DOMAIN\Group'
		CHANGE Script Format (BEGIN, PROCESS, END)
		ADD Minimal Error handling. (TRY CATCH)

	1.3 2013.10.05
		CHANGE in the PROCESS BLOCK, the TRY CATCH blocks and placed
		 them inside the FOREACH instead of inside the TRY block
		ADD support for Verbose
		CHANGE the output file name "DOMAIN_GROUPNAME-membership.csv"
		ADD a Change History File for each group(s)
		 example: "GROUPNAME-ChangesHistory-yyyyMMdd-hhmmss.csv"
		ADD more Error Handling
		ADD a HTML Report instead of plain text
		ADD HTML header
		ADD HTML header for change history

	1.4 2013.10.11
		CHANGE the 'Change History' filename to
		 "DOMAIN_GROUPNAME-ChangesHistory-yyyyMMdd-hhmmss.csv"
		UPDATE Comments Based Help
		ADD Some Variable Parameters
	1.5 2013.10.13
		ADD the full Parameter Names for each Cmdlets used in this script
		ADD Alias to the Group ParameterName
	1.6 2013.11.21
		ADD Support for Organizational Unit (SearchRoot parameter)
        ADD Support for file input (File Parameter)
        ADD ParamaterSetNames and parameters GroupType/GroupScope/SearchScope
		REMOVE [mailaddress] type on $Emailfrom and $EmailTo to make the script available to PowerShell 2.0
        ADD Regular expression validation on $Emailfrom and $EmailTo
	
		2013.11.23
		ADD ValidateScript on File Parameter
        ADD Additional information about the Group in the Report
        CHANGE the format of the $changes output, it will now include the DateTime Property
        UPDATE Help
        ADD DisplayName Property in the report
		
		2013.11.27
		Minor syntax changes
		UPDATE Help
#>

#requires -version 2.0
  
[CmdletBinding()]
PARAM(
        [Parameter(ParameterSetName="Group",Mandatory=$true,HelpMessage="You must specify at least one Active Directory group")]
        [ValidateNotNull()]
		[Alias('DN','DistinguishedName','GUID','SID','Name')]
        [string[]]$Group,

        [Parameter(ParameterSetName="OU",Mandatory=$true)]
		[String[]]$SearchRoot,

        [Parameter(ParameterSetName="OU")]
		[ValidateSet("Base","OneLevel","Subtree")]
		[String]$SearchScope,

        [Parameter(ParameterSetName="OU")]
		[ValidateSet("Global","Universal","DomainLocal")]
		[String]$GroupScope,

        [Parameter(ParameterSetName="OU")]
		[ValidateSet("Security","Distribution")]
		[String]$GroupType,

        [Parameter(ParameterSetName="File",Mandatory=$true)]
		[ValidateScript({Test-Path -Path $_})]
		[String[]]$File,

		[Parameter(Mandatory=$true,HelpMessage="You must specify the Sender Email Address")]
		[ValidatePattern("[a-z0-9!#\$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")]
        [String]$Emailfrom,

		[Parameter(Mandatory=$true,HelpMessage="You must specify the Destination Email Address")]
		[ValidatePattern("[a-z0-9!#\$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")]
        [String[]]$Emailto,

		[Parameter(Mandatory=$true,HelpMessage="You must specify the Email Server to use (IPAddress or FQDN)")]
        [String]$EmailServer
    )

BEGIN {
    TRY{

        # Set the Paths Variables and create the folders if not present
        $ScriptPath = (Split-Path -Path ((Get-Variable -Name MyInvocation).Value).MyCommand.Path)
        $ScriptPathOutput = $ScriptPath + "\Output"
        IF (!(Test-Path -Path $ScriptPathOutput))
        {
            Write-Verbose -Message "Creating the Output Folder : $ScriptPathOutput"
            New-Item -Path $ScriptPathOutput -ItemType Directory | Out-Null
        }
        $ScriptPathChangeHistory = $ScriptPath + "\ChangeHistory"
        IF (!(Test-Path -Path $ScriptPathChangeHistory))
        {
            Write-Verbose -Message "Creating the ChangeHistory Folder : $ScriptPathChangeHistory"
            New-Item -Path $ScriptPathChangeHistory -ItemType Directory | Out-Null
        }
		
		# Set the Date and Time variables format
        $DateFormat = Get-Date -Format "yyyyMMdd_HHmmss"
        $ReportDateFormat = Get-Date -Format "yyyy\MM\dd HH:mm:ss"
 
        # Quest Active Directory Snapin 
        IF (!(Get-PSSnapin -Name Quest.ActiveRoles.ADManagement -ErrorAction SilentlyContinue -ErrorVariable ErrorBEGINGetQuestAD)) 
        {
            Write-Verbose -Message "Quest Active Directory - Loading"
            Add-PSSnapin -Name Quest.ActiveRoles.ADManagement -ErrorAction Stop -ErrorVariable ErrorBEGINAddQuestAd
            Write-Verbose -Message "Quest Active Directory - Loaded"
        }

        # HTML Report settings
        $Report				= 	"<p style=`"background-color:white;font-family:consolas;font-size:9pt`">"+
									"<strong>Report Time:</strong> $DateFormat <br>"+
									"<strong>Account:</strong> $env:userdomain\$($env:username.toupper()) on $($env:ComputerName.toUpper())"+
								"</p>"

		$Head				= 	"<style>"+
									"BODY{background-color:white;font-family:consolas;font-size:11pt}"+
									"TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse}"+
									"TH{border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color:`"#00297A`";font-color:white}"+
									"TD{border-width: 1px;padding-right: 2px;padding-left: 2px;padding-top: 0px;padding-bottom: 0px;border-style: solid;border-color: black;background-color:white}"+
								"</style>"
		$Head2				= 	"<style>"+
									"BODY{background-color:white;font-family:consolas;font-size:9pt;}"+
									"TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"+
									"TH{border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color:`"#C0C0C0`"}"+
									"TD{border-width: 1px;padding-right: 2px;padding-left: 2px;padding-top: 0px;padding-bottom: 0px;border-style: solid;border-color: black;background-color:white}"+
								"</style>"


    }#TRY
    CATCH{
        Write-Warning -Message "BEGIN BLOCK - Something went wrong"
        if ($ErrorBEGINGetQuestAD){Write-Warning -Message "BEGIN BLOCK - Can't Find the Quest Active Directory Snappin"}
        if ($ErrorBEGINAddQuestAD){Write-Warning -Message "BEGIN BLOCK - Can't Load the Quest Active Directory Snappin"}
    }#CATCH
}#BEGIN
 
PROCESS{

	# SearchRoot parameter specified
    IF ($PSBoundParameters['SearchRoot']) {
		FOREACH ($item in $SearchRoot) {
			
			# Splatting
            $GetQADGroupParams = @{
                SearchRoot = $item
            }
            IF ($PSBoundParameters['SearchScope']){
                $GetQADGroupParams.SearchScope = $SearchScope
            }#IF ($PSBoundParameters['SearchScope'])
            IF ($PSBoundParameters['GroupScope']){
                $GetQADGroupParams.GroupScope = $GroupScope
            }#IF ($PSBoundParameters['GroupScope'])
            IF ($PSBoundParameters['GroupType']){
                $GetQADGroupParams.GroupType = $GroupType
            }#IF ($PSBoundParameters['GroupType'])

			# Add the Groups in the $group variable
            $group += (Get-QADGroup @GetQADGroupParams).DN
			Write-Verbose -Message "OU: $item"

		}#FOREACH ($item in $OU)
	}#IF ($PSBoundParameters['SearchRoot'])
	
	# File parameter specified
    IF ($PSBoundParameters['File']) {
		FOREACH ($item in $File)
		{
			Write-Verbose -Message "Loading File: $item"
			$Group += Get-Content -Path $File
		}#FOREACH ($item in $File)
	}#IF ($PSBoundParameters['File'])

    FOREACH ($item in $Group){
        TRY{

            Write-Verbose -Message "GROUP: $item"

            # CURRENT MEMBERSHIP
            $GroupName = Get-QADgroup $item -ErrorAction Continue -ErrorVariable ErrorProcessGetQADGroup

            # GroupName Found
            IF ($GroupName){
                
                # Get GroupName Membership
                $Members = Get-QADGroupMember -Identity $GroupName -Indirect -ErrorAction Stop -ErrorVariable ErrorProcessGetQADGroupMember #| Select-Object -Property Name, SamAccountName, DN
                
                # NO MEMBERS, Add some info in $members to avoid the $null
                # If the value is $null the compare-object won't work
                IF (-not($Members)){
                    $Members = New-Object -TypeName PSObject -Property @{
                        Name = "No User or Group"
                        SamAccountName = "No User or Group"}
                }
          
                
                # GroupName Membership File
                # If the file doesn't exist, assume we don't have a record to refer to
                $StateFile = "$($GroupName.domain.name)_$($GroupName.name)-membership.csv"
                IF (!(Test-Path -Path (Join-Path -Path $ScriptPathOutput -ChildPath $StateFile))){
                    Write-Verbose -Message "$item - The following file did not exist: $StateFile"
                    Write-Verbose -Message "$item - Exporting the current membership information into the file: $StateFile"
                    $Members | Export-csv -Path (Join-Path -Path $ScriptPathOutput -ChildPath $StateFile) -NoTypeInformation
                }ELSE {
                    Write-Verbose -Message "$item - The following file Exists: $StateFile"
                }


                # GroupName Membership File is compared with the current GroupName Membership
                Write-Verbose -Message "$item - Comparing Current and Before"
                $ImportCSV = Import-Csv -Path (Join-Path -path $ScriptPathOutput -childpath $StateFile) -ErrorAction Stop -ErrorVariable ErrorProcessImportCSV
                $Changes =  Compare-Object -DifferenceObject $ImportCSV -ReferenceObject $Members -ErrorAction stop -ErrorVariable ErrorProcessCompareObject -Property Name,SamAccountName, DN | Select-Object @{Name="DateTime";Expression={Get-Date -Format "yyyyMMdd-hh:mm:ss"}},@{n='State';e={IF ($_.SideIndicator -eq "=>"){"Removed"}ELSE { "Added" }}},DisplayName, SamAccountName, DN | Where-Object {$_.name -notlike "*no user or group*"}
                Write-Verbose -Message "$item - Compare Block Done !"
   
                # CHANGES FOUND !
                If ($Changes) {
                    Write-Verbose -Message "$item - Some changes found"
                    $changes

                    # CHANGE HISTORY
                    #  Get the Past Changes History
                    Write-Verbose -Message "$item - Get the change history for this group"
		            $ChangesHistoryFiles = Get-ChildItem -Path $ScriptPathChangeHistory\$($GroupName.domain.name)_$($GroupName.name)-ChangeHistory.csv -ErrorAction 'SilentlyContinue'
                    Write-Verbose -Message "$item - Change history files: $(($ChangesHistoryFiles|Measure-Object).Count)"
                    
                    # Process each history changes
                    IF ($ChangesHistoryFiles){
			            $infoChangeHistory=@()
                        FOREACH ($file in $ChangesHistoryFiles.FullName){
                            Write-Verbose -Message "$item - Change history files - Loading $file"
				            # Import the file and show the $file creation time and its content
                            $ImportedFile = Import-Csv -Path $file -ErrorAction Stop -ErrorVariable ErrorProcessImportCSVChangeHistory
				            FOREACH ($obj in $ImportedFile){
					            $Output = "" | Select-Object -Property DateTime,State,DisplayName,SamAccountName,DN
					            #$Output.DateTime = $file.CreationTime.GetDateTimeFormats("u") | Out-String
                                $Output.DateTime = $obj.DateTime
					            $Output.State	= $obj.State
					            $Output.DisplayName	= $obj.DisplayName
					            $Output.SamAccountName	= $obj.SamAccountName
					            $Output.DN		= $obj.DN
					            $infoChangeHistory = $infoChangeHistory + $Output
				            }#FOREACH $obj in Import-csv $file
                        }#FOREACH $file in $ChangeHistoryFiles
                        Write-Verbose -Message "$item - Change history process completed" 
                    }#IF($ChangeHistoryFiles)
                    
                    # CHANGE(S) EXPORT TO CSV
                    Write-Verbose -Message  "$item - Save changes to a ChangesHistory file"

                    IF (-not(Test-Path -path (Join-Path -Path $ScriptPathChangeHistory -ChildPath "$($GroupName.domain.name)_$($GroupName.name)-ChangeHistory.csv"))){
                        $Changes | Export-Csv -Path (Join-Path -Path $ScriptPathChangeHistory -ChildPath "$($GroupName.domain.name)_$($GroupName.name)-ChangeHistory.csv") -NoTypeInformation
                    }
                    ELSE{
		                #$Changes | Export-Csv -Path (Join-Path -Path $ScriptPathChangeHistory -ChildPath "$($GroupName.domain.name)_$($GroupName.name)-ChangeHistory-$DateFormat.csv") -NoTypeInformation
                        $Changes | Export-Csv -Path (Join-Path -Path $ScriptPathChangeHistory -ChildPath "$($GroupName.domain.name)_$($GroupName.name)-ChangeHistory.csv") -NoTypeInformation -Append
                    }


                    # EMAIL
                    Write-Verbose -Message "$item - Preparing the notification email..."

                    $EmailSubject = "PS MONITORING - $($GroupName.NTAccountName) Membership Change"

                    #  Preparing the body of the Email
                    $body = "<h2>Group: $($GroupName.NTAccountName)</h2>"
                    $body += "<p style=`"background-color:white;font-family:consolas;font-size:8pt`">"
                    $body += "<u>Group Description:</u> $($GroupName.Description)<br>"
                    $body += "<u>Group DN:</u> $($GroupName.DN)<br>"
                    $body += "<u>Group CanonicalName:</u> $($GroupName.CanonicalName)<br>"
                    $body += "<u>Group SID:</u> $($GroupName.Sid)<br>"
                    $body += "<u>Group Scope/Type:</u> $($GroupName.GroupScope) / $($GroupName.GroupType)<br>"
                    $body += "</p>"

                    $body += "<h3> Membership Change"
                    $body += "</h3>"
                    $body += "<i>The membership of this group changed. See the following Added or Removed members.</i>"
                    $body += $changes | ConvertTo-Html -head $head | Out-String
                    $body += "<br><br><br>"
                    IF ($ChangesHistoryFiles){
                        $body += "<h3>Change History</h3>"
                        $body += "<i>List of the previous changes on this group observed by the script</i>"
                        $body += $infoChangeHistory | Sort-Object -Property DateTime -Descending  | ConvertTo-Html -Fragment -PreContent $Head2| Out-String
                    }
                    $body = $body -replace "Added","<font color=`"blue`"><b>Added</b></font>"
                    $body = $body -replace "Removed","<font color=`"red`"><b>Removed</b></font>"
                    $body += $Report

                    #  Preparing the Email properties
                    $SmtpClient = New-Object -TypeName system.net.mail.smtpClient
                    $SmtpClient.host = $EmailServer
                    $MailMessage = New-Object -TypeName system.net.mail.mailmessage
                    #$MailMessage.from = $EmailFrom.Address
                    $MailMessage.from = $EmailFrom
                    #FOREACH ($To in $Emailto){$MailMessage.To.add($($To.Address))}
                    FOREACH ($To in $Emailto){$MailMessage.To.add($($To))}
                    $MailMessage.IsBodyHtml = 1
                    $MailMessage.Subject = $EmailSubject
                    $MailMessage.Body = $Body

                    #  Sending the Email
                    $SmtpClient.Send($MailMessage)
                    Write-Verbose -Message "$item - Email Sent."

                    
                    # GroupName Membership export to CSV
                    Write-Verbose -Message "$item - Exporting the current membership to $StateFile"
                    $Members | Export-csv -Path (Join-Path -Path $ScriptPathOutput -ChildPath $StateFile) -NoTypeInformation -Encoding Unicode
                }#IF $Change
                ELSE {Write-Verbose -Message "$item - No Change"}

            }#IF ($GroupName)
            ELSE{
                Write-Verbose -message "$item - Group can't be found"
                #IF (Get-ChildItem (Join-Path $ScriptPathOutput "*$item*-membership.csv" -ErrorAction Continue) -or (Get-ChildItem (Join-Path $ScriptPathChangeHistory "*$item*.csv" -ErrorAction Continue)))
                #{
                #    Write-Warning "$item - Looks like a file contains the name of this group, this group was possibly deleted from Active Directory"
                #}
                
            }#ELSE $GroupName
        }#TRY
        CATCH{
            Write-Warning -Message "PROCESS BLOCK - Something went wrong"
            
            if($ErrorProcessGetQADGroup){Write-warning -Message "Error When querying the group $item in Active Directory"}
            if($ErrorProcessGetQADGroupMember){Write-warning -Message "Error When querying the group $item members in Active Directory"}
            if($ErrorProcessImportCSV){Write-warning -Message "Error Importing $StateFile"}
            if($ErrorProcessCompareObject){Write-warning -Message "Error when comparing"}
            if($ErrorProcessImportCSVChangeHistory){Write-warning -Message "Error Importing $file"}

            Write-Warning -Message "LAST ERROR: $error[0]"
        }#CATCH
    }#FOREACH
}#PROCESS
END{
    Write-Verbose -message "Script Completed"
}