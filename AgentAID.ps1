#==========================================================================
#
# NAME:		AgentAID.ps1
#
# AUTHOR:	Spuzzelsnest
# EMAIL:	jan.mpdesmet@gmail.com
#
# COMMENT: 
#			Agent Aid to automate the job 
#
#           	
#       VERSION HISTORY:
#       1.0     02.17.2017 	- Initial release
#							
#==========================================================================
#MODULES
#Exchange 
#installed in %ExchangeInstallPath%\bin
#
#if ( (Get-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.E2010 -ErrorAction SilentlyContinue) -eq $null )
#      {
#        Add-PsSnapin Microsoft.Exchange.Management.PowerShell.E2010
#      }
#
#if (!(Get-PSSnapin Quest.ActiveRoles.ADManagement -registered -ErrorAction SilentlyContinue)) { Plugin needed }
#Add-PSSnapin Quest.ActiveRoles.ADManagement -ErrorAction SilentlyContinue
#
#

#Functions

function UserInfo ($Id){

        $private:Id = $Id
        'Processing ' + $private:Id + '...'
        $userLog = @{}
        $userLog. 'UserID' = Get-ADUser -Identity $private:Id -ErrorAction SilentlyContinue -properties * | select SamAccountName, Name, surName, GivenName,  StreetAddress, PostalCode, City, Country, OfficePhone, otherTelephone, Title, Department, Company, Organization, UserPrincipalName, DistinguishedName, ObjectClass, Enabled,scriptpath, homedrive, homedirectory, SID
        $userLog. 'Groups' = Get-ADPrincipalGroupMembership $private:Id | select name |Format-Table -HideTableHeaders
   #----------------------------------------------
        $manager = Get-ADUser $pritvate:Id -Properties manager | Select-Object -Property @{label='Manager';expression={$_.manager -replace '^CN=|,.*$'}} | Format-Table -HideTableHeaders |Out-String
        $manager = $manager.Trim()
        $userLog. 'Manager' = Get-ADUser -filter {displayName -like $manager} -properties * | Select displayName, EmailAddress, mobile | Format-List
   #----------------------------------------------
        $userLog. 'Email Info '= Get-Recipient -Identity $Id | Select Name -ExpandProperty EmailAddresses |  Format-Table Name,  SmtpAddress 
        
        $userLog.GetEnumerator() | Sort-Object 'Name' | Format-Table -AutoSize
        $userLog.GetEnumerator() | Sort-Object 'Name' | Out-GridView -Title "$private:computer Information"

}

function PCInfo($pc){
    
        $private:pc = $pc
        'Processing ' + $private:pc + '...'
        $PCLog = @{}
        $PCLog.'PC-Name' = $private:pc
        
        # Try an ICMP ping the only way Powershell knows how...
        $private:ping = Test-Connection -quiet -count 1 $private:pc
        $PCLog.Ping = $(if ($private:ping) { 'Yes' } else { 'No' })



}





#Main

$h = get-host
$c = $h.UI.RawUI
$c.BackgroundColor = ($bckgrnd = 'black')


mode con:cols=140 lines=70
set-location $env:userprofile\Desktop

$instDir = $env:userprofile +"\Documents\dev\AgentAid"
$version = "v 0.1 - beta"
$agent = $env:UserName
$intro = get-content $instDir\bin\skins\intro1 | out-string
$menu =  @"


                      Press:
                               (1)   User info
                               (2)   PC info
                               (3)   Antivirus Tools
                               (4)   Admin Tools
                               (Q)   Exit


"@  

clear
#STart MEnu Build

write-host $intro -ForegroundColor Magenta
write-host "                 Welcome " $agent " to Agent AID         version  " $version -foregroundcolor white
write-host "                                                      powered by Powershell " $ 
write-host $menu -ForegroundColor Green



$mainMenu = [System.Management.Automation.Host.ChoiceDescription[]] @("&1_UserInfo", "&2_PCInfo", "&3_ACTools", "&4_ATools", "&Quit")
[int]$defaultchoice = 0
$opt =  $host.UI.PromptForChoice($Title , $Info , $mainMenu, $defaultchoice)
switch($opt)
{
0 { clear
                write-host "#####################################################################################"
                write-host "                                       USERINFO INFO" -ForegroundColor Green
                write-host "#####################################################################################"
                write-host ". "
                $Id =  read-host "                    What is the userID: "
                
                Write-Host User info -ForegroundColor Green
                userInfo $Id   
                              
    
  }
1 { clear

                write-host "#####################################################################################"
                write-host "                                       PCINFO INFO" -ForegroundColor Green
                write-host "#####################################################################################"
                write-host ". "
                $PCName =  read-host "   What is the PC-Name or IP address: "

        
                Write-Host "Offline INFO" -ForegroundColor red

                
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
   }
2 { clear
        set-location $instDir
        Write-Host "Good Bye!!!" -ForegroundColor Green}
3 { clear

        Write-Host "Good Bye!!!" -ForegroundColor Green}
4 {
    Write-Host "Good Bye!!!" -ForegroundColor Green
    clear  
    
  }



}